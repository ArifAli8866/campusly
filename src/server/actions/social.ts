"use server";

import { revalidatePath } from "next/cache";

import { RATE_LIMITS } from "@/lib/constants";
import { reportSchema } from "@/lib/validation/schemas";
import { requireUser } from "@/server/auth/context";
import { assertRateLimit } from "@/server/lib/rate-limit";
import { fail, ok, okWith, runAction, type ActionResult } from "@/server/lib/results";

/* --------------------------------------------------------------------- likes */

export async function togglePostLikeAction(postId: string): Promise<ActionResult<{ liked: boolean }>> {
  return runAction(async () => {
    const context = await requireUser();
    await assertRateLimit(context.db, "like", RATE_LIMITS.like);

    const posts = await context.db.select<{ id: string; author_id: string | null }>("posts", {
      // author_id is null here for anonymous posts authored by someone else,
      // which is exactly what we need: no notification, no identity.
      columns: "id",
      where: { id: postId, deleted_at: null },
      limit: 1,
    });
    if (posts.length === 0) return fail("That post is no longer available.");

    const existing = await context.db.select("post_likes", {
      columns: "id",
      where: { post_id: postId, user_id: context.id },
      limit: 1,
    });

    if (existing.length > 0) {
      await context.db.delete("post_likes", { post_id: postId, user_id: context.id });
      revalidatePath("/home");
      return okWith<{ liked: boolean }>({ liked: false });
    }

    // The unique index on (post_id, user_id) makes a double-tap a no-op
    // conflict rather than a duplicate row. `post_likes_notify` (migration
    // 0005) delivers the notification, so we never need to touch the author
    // id here — which is what keeps anonymous posts safe on this path.
    const inserted = await context.db
      .insert("post_likes", { post_id: postId, user_id: context.id }, { columns: "id" })
      .catch(() => [] as { id: string }[]);

    revalidatePath("/home");
    return okWith<{ liked: boolean }>({ liked: inserted.length > 0 });
  });
}

export async function toggleCommentLikeAction(commentId: string): Promise<ActionResult<{ liked: boolean }>> {
  return runAction(async () => {
    const context = await requireUser();

    const existing = await context.db.select("comment_likes", {
      columns: "id",
      where: { comment_id: commentId, user_id: context.id },
      limit: 1,
    });

    if (existing.length > 0) {
      await context.db.delete("comment_likes", { comment_id: commentId, user_id: context.id });
      return okWith<{ liked: boolean }>({ liked: false });
    }

    await context.db.insert("comment_likes", { comment_id: commentId, user_id: context.id }, { columns: "id" });
    return okWith({ liked: true });
  });
}

/* --------------------------------------------------------------------- saves */

export async function toggleSavePostAction(postId: string): Promise<ActionResult<{ saved: boolean }>> {
  return runAction(async () => {
    const context = await requireUser();

    const existing = await context.db.select("saved_posts", {
      columns: "post_id",
      where: { post_id: postId, user_id: context.id },
      limit: 1,
    });

    if (existing.length > 0) {
      await context.db.delete("saved_posts", { post_id: postId, user_id: context.id });
      revalidatePath("/saved");
      return okWith<{ saved: boolean }>({ saved: false }, "Removed from your saved posts.");
    }

    await context.db.insert("saved_posts", { post_id: postId, user_id: context.id }, { returning: false });
    revalidatePath("/saved");
    return okWith<{ saved: boolean }>({ saved: true }, "Saved privately. Only you can see this.");
  });
}

/* ------------------------------------------------------------------- sharing */

export async function recordShareAction(postId: string, channel = "copy_link"): Promise<ActionResult> {
  return runAction(async () => {
    const context = await requireUser();
    await context.db
      .insert("post_shares", { post_id: postId, user_id: context.id, channel }, { returning: false })
      .catch(() => undefined);
    return ok();
  });
}

/* ------------------------------------------------------------------ reports */

export async function reportContentAction(formData: FormData): Promise<ActionResult> {
  return runAction(async () => {
    const context = await requireUser();
    await assertRateLimit(context.db, "report", RATE_LIMITS.report);

    const payload = reportSchema.parse({
      targetType: formData.get("targetType"),
      targetId: formData.get("targetId"),
      reason: formData.get("reason"),
      description: formData.get("description") ?? "",
    });

    // Snapshot the reported content so a moderator can still review it after
    // the author deletes it. The snapshot deliberately excludes author identity.
    let snapshot: Record<string, unknown> | null = null;

    if (payload.targetType === "post") {
      const rows = await context.db.rpc<{
        id: string;
        body: string;
        is_anonymous: boolean;
        channel_slug: string;
        channel_name: string;
        created_at: string;
      }>("feed_posts", { p_ids: [payload.targetId], p_limit: 1 });

      const post = rows[0];
      if (!post) return fail("That post is no longer available to report.");
      snapshot = {
        kind: "post",
        body: post.body,
        is_anonymous: post.is_anonymous,
        channel_slug: post.channel_slug,
        channel_name: post.channel_name,
        created_at: post.created_at,
      };
    } else if (payload.targetType === "comment") {
      const rows = await context.db.select<{ id: string; post_id: string; body: string; is_anonymous: boolean }>(
        "comments",
        { columns: "id, post_id, body, is_anonymous", where: { id: payload.targetId }, limit: 1 },
      );
      const comment = rows[0];
      if (!comment) return fail("That comment is no longer available to report.");
      snapshot = {
        kind: "comment",
        post_id: comment.post_id,
        body: comment.body,
        is_anonymous: comment.is_anonymous,
      };
    } else {
      const rows = await context.db.select<{ username: string; display_name: string }>("profiles", {
        columns: "username, display_name",
        where: { id: payload.targetId },
        limit: 1,
      });
      if (!rows[0]) return fail("That profile is no longer available to report.");
      snapshot = { kind: "user", username: rows[0].username, display_name: rows[0].display_name };
    }

    const inserted = await context.db
      .insert(
        "reports",
        {
          reporter_id: context.id,
          target_type: payload.targetType,
          target_id: payload.targetId,
          target_snapshot: snapshot,
          reason: payload.reason,
          description: payload.description || null,
        },
        { columns: "id" },
      )
      .catch((error) => {
        if ((error as { code?: string }).code === "23505") return [] as { id: string }[];
        throw error;
      });

    if (inserted.length === 0) {
      return ok("You have already reported this. Our moderators are reviewing it.");
    }

    return ok("Thanks — our moderators will review this.");
  });
}

/* ------------------------------------------------------------ block & mute */

export async function toggleBlockUserAction(userId: string): Promise<ActionResult<{ blocked: boolean }>> {
  return runAction(async () => {
    const context = await requireUser();
    if (userId === context.id) return fail("You cannot block yourself.");

    const existing = await context.db.select("blocked_users", {
      columns: "blocker_id",
      where: { blocker_id: context.id, blocked_user_id: userId },
      limit: 1,
    });

    if (existing.length > 0) {
      await context.db.delete("blocked_users", { blocker_id: context.id, blocked_user_id: userId });
      revalidatePath("/home");
      return okWith<{ blocked: boolean }>({ blocked: false }, "You have unblocked this person.");
    }

    await context.db.insert(
      "blocked_users",
      { blocker_id: context.id, blocked_user_id: userId },
      { returning: false },
    );
    revalidatePath("/home");
    return okWith<{ blocked: boolean }>({ blocked: true }, "Blocked. You will no longer see each other's posts or comments.");
  });
}

export async function toggleChannelMuteAction(channelId: string): Promise<ActionResult<{ muted: boolean }>> {
  return runAction(async () => {
    const context = await requireUser();

    const existing = await context.db.select("channel_mutes", {
      columns: "channel_id",
      where: { user_id: context.id, channel_id: channelId },
      limit: 1,
    });

    if (existing.length > 0) {
      await context.db.delete("channel_mutes", { user_id: context.id, channel_id: channelId });
      return okWith<{ muted: boolean }>({ muted: false }, "Notifications for this community are back on.");
    }

    await context.db.insert(
      "channel_mutes",
      { user_id: context.id, channel_id: channelId },
      { returning: false },
    );
    return okWith<{ muted: boolean }>({ muted: true }, "Muted. You will still see the feed, just fewer notifications.");
  });
}

/* ------------------------------------------------------------ notifications */

export async function markNotificationReadAction(notificationId: string): Promise<ActionResult> {
  return runAction(async () => {
    const context = await requireUser();
    // RLS restricts this to the recipient's own rows.
    await context.db.update("notifications", { is_read: true }, {
      id: notificationId,
      recipient_id: context.id,
    });
    revalidatePath("/notifications");
    return ok();
  });
}

export async function markAllNotificationsReadAction(): Promise<ActionResult> {
  return runAction(async () => {
    const context = await requireUser();
    await context.db.update("notifications", { is_read: true }, { recipient_id: context.id, is_read: false });
    revalidatePath("/notifications");
    return ok("All caught up.");
  });
}

export async function deleteNotificationAction(notificationId: string): Promise<ActionResult> {
  return runAction(async () => {
    const context = await requireUser();
    await context.db.delete("notifications", { id: notificationId, recipient_id: context.id });
    revalidatePath("/notifications");
    return ok();
  });
}

/* -------------------------------------------------------------- poll voting */

export async function votePollAction(pollId: string, optionId: string): Promise<ActionResult> {
  return runAction(async () => {
    const context = await requireUser();
    await assertRateLimit(context.db, "poll_vote", RATE_LIMITS.pollVote);

    const inserted = await context.db
      .insert("poll_votes", { poll_id: pollId, option_id: optionId, user_id: context.id }, { columns: "id" })
      .catch((error) => {
        if ((error as { code?: string }).code === "23505") return [] as { id: string }[];
        throw error;
      });

    if (inserted.length === 0) return fail("You have already voted in this poll.");
    return ok("Vote recorded.");
  });
}
