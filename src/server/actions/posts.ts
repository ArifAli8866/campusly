"use server";

import { revalidatePath } from "next/cache";

import { POST_MAX_LENGTH, RATE_LIMITS } from "@/lib/constants";
import type { PostCategory } from "@/lib/db/types";
import { createPostSchema, draftSchema, updatePostSchema } from "@/lib/validation/schemas";
import { requireUser } from "@/server/auth/context";
import { fail, ok, okWith, runAction, type ActionResult } from "@/server/lib/results";
import { assertRateLimit } from "@/server/lib/rate-limit";
import { recordMentions } from "@/server/services/mentions";

/**
 * Publish a confession.
 *
 * Identity handling, in order:
 *  1. `author_id` is ALWAYS taken from the server session — never from the form.
 *  2. `is_anonymous` is a stored, immutable-by-readers boolean.
 *  3. Once written, only RPC reads (which null the author for everyone but the
 *     owner) can retrieve the row; the client cannot select `author_id` at all.
 */
export async function createPostAction(formData: FormData): Promise<ActionResult<{ postId: string; channelSlug: string }>> {
  return runAction(async () => {
    const context = await requireUser();
    await assertRateLimit(context.db, "post", RATE_LIMITS.post);

    const rawPoll = formData.get("poll");
    const payload = createPostSchema.parse({
      channelId: formData.get("channelId"),
      body: formData.get("body"),
      isAnonymous: formData.get("isAnonymous") !== "false",
      category: (formData.get("category") as string) || null,
      mediaPath: (formData.get("mediaPath") as string) || null,
      poll: rawPoll ? JSON.parse(String(rawPoll)) : null,
    });

    if (context.profile.isSuspended) {
      return fail("Your account is currently restricted, so you cannot publish.");
    }

    // The channel must be one the user belongs to (or an open channel).
    const channels = await context.db.select<{ id: string; slug: string; posting_policy: string; is_active: boolean }>(
      "channels",
      { columns: "id, slug, posting_policy, is_active", where: { id: payload.channelId }, limit: 1 },
    );
    const channel = channels[0];
    if (!channel || !channel.is_active) return fail("That community is not available.");

    if (channel.posting_policy === "members") {
      const membership = await context.db.select("channel_members", {
        columns: "id",
        where: { user_id: context.id, channel_id: channel.id },
        limit: 1,
      });
      if (membership.length === 0) {
        return fail("Join this community before posting in it.");
      }
    }

    const universityRows = await context.db.select<{ university_id: string }>("channels", {
      columns: "university_id",
      where: { id: channel.id },
      limit: 1,
    });

    const inserted = await context.db.insert<{ id: string }>(
      "posts",
      {
        channel_id: channel.id,
        university_id: universityRows[0]!.university_id,
        author_id: context.id, // never client-supplied
        body: payload.body,
        is_anonymous: payload.isAnonymous,
        category: (payload.category as PostCategory) ?? null,
        media_path: payload.mediaPath ?? null,
      },
      { columns: "id" },
    );

    const postId = inserted[0]!.id;

    if (payload.poll) {
      const pollRows = await context.db.insert<{ id: string }>(
        "polls",
        {
          post_id: postId,
          question: payload.poll.question,
          allow_multiple: payload.poll.allowMultiple,
          anonymous_votes: payload.poll.anonymousVotes,
          closes_at: payload.poll.closesAt ?? null,
        },
        { columns: "id" },
      );
      await context.db.insert(
        "poll_options",
        payload.poll.options
          .map((label) => label.trim())
          .filter(Boolean)
          .map((label, index) => ({ poll_id: pollRows[0]!.id, label, position: index })),
        { returning: false },
      );
    }

    // Mentions are stored as structured rows; `mentions_notify` (migration
    // 0005) raises the notifications inside the same transaction.
    await recordMentions(context.db, {
      sourceType: "post",
      sourceId: postId,
      body: payload.body,
      authorId: context.id,
    });

    revalidatePath("/home");
    revalidatePath(`/channels/${channel.slug}`);
    revalidatePath("/explore");

    return okWith({ postId, channelSlug: channel.slug }, "Published.");
  });
}

export async function updatePostAction(formData: FormData): Promise<ActionResult> {
  return runAction(async () => {
    const context = await requireUser();
    const payload = updatePostSchema.parse({
      postId: formData.get("postId"),
      body: formData.get("body"),
      category: (formData.get("category") as string) || null,
    });

    const rows = await context.db.update(
      "posts",
      {
        body: payload.body,
        category: (payload.category as PostCategory) ?? null,
        edited_at: new Date().toISOString(),
      },
      { id: payload.postId, author_id: context.id },
      { columns: "id" },
    );

    if (rows.length === 0) return fail("You can only edit your own posts.");

    revalidatePath("/home");
    return ok("Post updated.");
  });
}

/** Soft delete: the row is kept so moderation history and audit remain intact. */
export async function deletePostAction(postId: string): Promise<ActionResult> {
  return runAction(async () => {
    const context = await requireUser();

    const owned = await context.db.select<{ id: string; channel_id: string }>("posts", {
      columns: "id, channel_id",
      where: { id: postId, author_id: context.id },
      limit: 1,
    });

    const isModerator = context.role === "moderator" || context.role === "admin";
    if (owned.length === 0 && !isModerator) {
      return fail("You can only delete your own posts.");
    }

    const updated = await context.db.update(
      "posts",
      { deleted_at: new Date().toISOString() },
      { id: postId },
      { columns: "id" },
    );
    if (updated.length === 0) return fail("That post is no longer available.");

    if (owned[0]) {
      const channels = await context.db.select<{ slug: string }>("channels", {
        columns: "slug",
        where: { id: owned[0].channel_id },
        limit: 1,
      });
      if (channels[0]) revalidatePath(`/channels/${channels[0].slug}`);
    }
    revalidatePath("/home");
    return ok("Post deleted.");
  });
}

/* ------------------------------------------------------------------ drafts */

export async function saveDraftAction(formData: FormData): Promise<ActionResult<{ draftId: string }>> {
  return runAction(async () => {
    const context = await requireUser();
    const payload = draftSchema.parse({
      draftId: formData.get("draftId") || null,
      channelId: formData.get("channelId") || null,
      body: formData.get("body") ?? "",
      isAnonymous: formData.get("isAnonymous") !== "false",
      category: (formData.get("category") as string) || null,
    });

    const values = {
      user_id: context.id,
      channel_id: payload.channelId,
      body: payload.body.slice(0, POST_MAX_LENGTH),
      is_anonymous: payload.isAnonymous,
      category: (payload.category as PostCategory) ?? null,
    };

    if (payload.draftId) {
      const updated = await context.db.update<{ id: string }>("drafts", values, {
        id: payload.draftId,
        user_id: context.id,
      }, { columns: "id" });
      if (updated[0]) {
        revalidatePath("/drafts");
        return okWith({ draftId: updated[0].id }, "Draft saved.");
      }
    }

    const inserted = await context.db.insert<{ id: string }>("drafts", values, { columns: "id" });
    revalidatePath("/drafts");
    return okWith({ draftId: inserted[0]!.id }, "Draft saved.");
  });
}

export async function deleteDraftAction(draftId: string): Promise<ActionResult> {
  return runAction(async () => {
    const context = await requireUser();
    const removed = await context.db.delete("drafts", { id: draftId, user_id: context.id });
    if (removed === 0) return fail("That draft is no longer available.");
    revalidatePath("/drafts");
    return ok("Draft discarded.");
  });
}

/** Publish straight from a saved draft, then remove the draft. */
export async function publishDraftAction(formData: FormData): Promise<ActionResult<{ postId: string; channelSlug: string }>> {
  return runAction(async () => {
    const context = await requireUser();
    const draftId = String(formData.get("draftId") ?? "");

    const drafts = await context.db.select<{ id: string; channel_id: string | null; body: string; is_anonymous: boolean; category: string | null }>(
      "drafts",
      { columns: "id, channel_id, body, is_anonymous, category", where: { id: draftId, user_id: context.id }, limit: 1 },
    );
    const draft = drafts[0];
    if (!draft) return fail("That draft is no longer available.");
    if (!draft.channel_id) return fail("Choose a community before publishing this draft.");

    const forwarded = new FormData();
    forwarded.set("channelId", draft.channel_id);
    forwarded.set("body", draft.body);
    forwarded.set("isAnonymous", String(draft.is_anonymous));
    if (draft.category) forwarded.set("category", draft.category);

    const result = await createPostAction(forwarded);
    if (!result.ok) return result;

    await context.db.delete("drafts", { id: draft.id, user_id: context.id });
    revalidatePath("/drafts");
    return result;
  });
}
