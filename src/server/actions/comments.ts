"use server";

import { revalidatePath } from "next/cache";

import { RATE_LIMITS } from "@/lib/constants";
import { commentSchema } from "@/lib/validation/schemas";
import { requireUser } from "@/server/auth/context";
import { assertRateLimit } from "@/server/lib/rate-limit";
import { fail, ok, okWith, runAction, type ActionResult } from "@/server/lib/results";
import { recordMentions } from "@/server/services/mentions";

export async function createCommentAction(formData: FormData): Promise<ActionResult<{ commentId: string }>> {
  return runAction(async () => {
    const context = await requireUser();
    await assertRateLimit(context.db, "comment", RATE_LIMITS.comment);

    const payload = commentSchema.parse({
      postId: formData.get("postId"),
      parentId: (formData.get("parentId") as string) || null,
      body: formData.get("body"),
      isAnonymous: formData.get("isAnonymous") === "true",
    });

    if (context.profile.isSuspended) {
      return fail("Your account is currently restricted, so you cannot comment.");
    }

    // Confirm the post is visible to this user before attaching a comment.
    const posts = await context.db.rpc<{ id: string; channel_slug: string; author_id: string | null }>("feed_posts", {
      p_ids: [payload.postId],
      p_limit: 1,
    });
    const post = posts[0];
    if (!post) return fail("That post is no longer available.");

    const inserted = await context.db.insert<{ id: string }>(
      "comments",
      {
        post_id: payload.postId,
        author_id: context.id, // server-derived, never from the form
        parent_id: payload.parentId,
        body: payload.body,
        is_anonymous: payload.isAnonymous,
      },
      { columns: "id" },
    );

    const commentId = inserted[0]!.id;

    // Comment, reply and mention notifications are raised by database
    // triggers (migration 0005) inside the same transaction, which is what
    // guarantees an anonymous comment can never be attributed through the
    // notification feed.
    await recordMentions(context.db, {
      sourceType: "comment",
      sourceId: commentId,
      body: payload.body,
      authorId: context.id,
    });

    revalidatePath(`/channels/${post.channel_slug}`);
    revalidatePath("/home");

    return okWith({ commentId }, "Comment posted.");
  });
}

export async function updateCommentAction(commentId: string, body: string): Promise<ActionResult> {
  return runAction(async () => {
    const context = await requireUser();
    const parsed = commentSchema.pick({ body: true }).parse({ body });

    const updated = await context.db.update(
      "comments",
      { body: parsed.body, edited_at: new Date().toISOString() },
      { id: commentId, author_id: context.id },
      { columns: "id" },
    );

    if (updated.length === 0) return fail("You can only edit your own comments.");
    return ok("Comment updated.");
  });
}

export async function deleteCommentAction(commentId: string): Promise<ActionResult> {
  return runAction(async () => {
    const context = await requireUser();
    const isModerator = context.role === "moderator" || context.role === "admin";

    const owned = await context.db.select<{ id: string }>("comments", {
      columns: "id",
      where: { id: commentId, author_id: context.id },
      limit: 1,
    });

    if (owned.length === 0 && !isModerator) return fail("You can only delete your own comments.");

    const updated = await context.db.update(
      "comments",
      { deleted_at: new Date().toISOString() },
      { id: commentId },
      { columns: "id" },
    );

    if (updated.length === 0) return fail("That comment is no longer available.");
    return ok("Comment deleted.");
  });
}
