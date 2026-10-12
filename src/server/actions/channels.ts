"use server";

import { revalidatePath } from "next/cache";

import { RATE_LIMITS } from "@/lib/constants";
import { requireUser } from "@/server/auth/context";
import { assertRateLimit } from "@/server/lib/rate-limit";
import { fail, okWith, runAction, type ActionResult } from "@/server/lib/results";

/**
 * Join a campus community.
 *
 * Exactly-one-membership is guaranteed by the database, not by this function:
 * `channel_members_unique_key` is a unique index on (user_id, channel_id), and
 * the insert below treats a 23505 as "already joined" instead of an error. Two
 * concurrent taps therefore cannot produce two rows.
 */
export async function joinChannelAction(channelId: string): Promise<ActionResult<{ joined: boolean }>> {
  return runAction(async () => {
    const context = await requireUser();
    await assertRateLimit(context.db, "channel_join", RATE_LIMITS.channelJoin);

    const channels = await context.db.select<{ id: string; slug: string; university_id: string; is_active: boolean }>(
      "channels",
      { columns: "id, slug, university_id, is_active", where: { id: channelId }, limit: 1 },
    );
    const channel = channels[0];
    if (!channel || !channel.is_active) return fail("That community is not available.");

    // A re-join is a silent success, not a duplicate-key error.
    const inserted = await context.db
      .insert<{ id: string }>(
        "channel_members",
        {
          user_id: context.id,
          channel_id: channel.id,
          university_id: channel.university_id,
        },
        { columns: "id" },
      )
      .catch((error) => {
        if ((error as { code?: string }).code === "23505") return [] as { id: string }[];
        throw error;
      });

    revalidatePath(`/channels/${channel.slug}`);
    revalidatePath("/joined");
    revalidatePath("/home");

    return okWith(
      { joined: true },
      inserted.length > 0 ? "Joined. Say hello when you are ready." : "You are already in this community.",
    );
  });
}

export async function leaveChannelAction(channelId: string): Promise<ActionResult<{ joined: boolean }>> {
  return runAction(async () => {
    const context = await requireUser();

    const channels = await context.db.select<{ slug: string }>("channels", {
      columns: "slug",
      where: { id: channelId },
      limit: 1,
    });

    // RLS restricts the delete to the caller's own membership row.
    await context.db.delete("channel_members", { user_id: context.id, channel_id: channelId });

    if (channels[0]) revalidatePath(`/channels/${channels[0].slug}`);
    revalidatePath("/joined");
    revalidatePath("/home");

    return okWith({ joined: false }, "You left this community. You can rejoin any time.");
  });
}

/** Join several channels at once — used by the onboarding "discover" step. */
export async function joinChannelsAction(channelIds: string[]): Promise<ActionResult<{ joined: number }>> {
  return runAction(async () => {
    const context = await requireUser();
    if (channelIds.length === 0) return okWith({ joined: 0 });
    if (channelIds.length > 30) return fail("Please choose fewer communities at a time.");

    const channels = await context.db.select<{ id: string; university_id: string }>("channels", {
      columns: "id, university_id",
      where: { id: channelIds, is_active: true },
    });

    if (channels.length === 0) return fail("Those communities are not available.");

    const rows = channels.map((channel) => ({
      user_id: context.id,
      channel_id: channel.id,
      university_id: channel.university_id,
    }));

    // on-conflict-do-nothing semantics: re-joining something already joined is
    // a silent success rather than a duplicate-key error.
    await context.db
      .insert("channel_members", rows, { returning: false })
      .catch((error) => {
        if ((error as { code?: string }).code !== "23505") throw error;
      });

    revalidatePath("/joined");
    revalidatePath("/home");
    return okWith({ joined: rows.length }, "Communities joined.");
  });
}
