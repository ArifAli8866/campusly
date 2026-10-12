import "server-only";

import type { Db } from "@/lib/db/interface";
import { extractMentionHandles } from "@/lib/mentions";

/**
 * Resolve @handles in a body and record them as structured mention rows.
 *
 * Deliberately does *not* create notifications: `mentions_notify` (migration
 * 0005) fires on insert and produces them inside the same transaction, with the
 * anonymity sanitisation applied. One write path, one place to audit.
 *
 * Unresolvable handles are ignored rather than failing the post — a typo in
 * "@sumone" should not lose the student's confession.
 */
export async function recordMentions(
  db: Db,
  options: {
    sourceType: "post" | "comment";
    sourceId: string;
    body: string;
    authorId: string;
  },
): Promise<string[]> {
  const handles = extractMentionHandles(options.body);
  if (handles.length === 0) return [];

  const profiles = await db.select<{ id: string }>("profiles", {
    columns: "id",
    where: { username: handles, is_suspended: false },
  });

  const recipients = profiles.map((row) => row.id).filter((id) => id !== options.authorId);
  if (recipients.length === 0) return [];

  await db
    .insert(
      "mentions",
      recipients.map((id) => ({
        source_type: options.sourceType,
        source_id: options.sourceId,
        mentioned_user_id: id,
      })),
      { returning: false },
    )
    // The unique index makes a re-edit idempotent; a conflict is not an error.
    .catch(() => undefined);

  return recipients;
}
