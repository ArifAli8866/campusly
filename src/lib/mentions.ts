
/**
 * Mention parsing and body segmentation.
 *
 * Isomorphic on purpose: the composer, the post card and the server must agree
 * on exactly what counts as a mention, so they share one implementation. That
 * is why this lives outside `server-only`.
 *
 * Mentions are stored as structured rows (`mentions.mentioned_user_id`), never
 * as text re-parsed at render time, so renaming a user cannot silently rewrite
 * the history of who was mentioned — and an unavailable user degrades to plain
 * text instead of a dead link.
 */

/** Matches `@handle` at the start of the string or after whitespace. */
const MENTION_PATTERN = /(^|\s)@([a-zA-Z0-9_]{3,24})(?![a-zA-Z0-9_])/g;

export function extractMentionHandles(body: string): string[] {
  const handles = new Set<string>();
  for (const match of body.matchAll(MENTION_PATTERN)) {
    const handle = match[2]?.toLowerCase();
    if (handle) handles.add(handle);
  }
  return Array.from(handles);
}

/**
 * Resolves handles to user ids and inserts mention rows.
 *
 * Silently ignores handles that do not exist, that point at the author, or that
 * point at someone the model should not notify — a mistyped @name must never
 * fail the whole post. Returns the ids that were actually recorded.

/**
 * Splits a body into renderable segments. The caller maps `mention` segments to
 * profile links using the resolved map, so an unresolvable handle renders as
 * plain text rather than a dead link.
 */
export type BodySegment =
  | { type: "text"; value: string }
  | { type: "mention"; handle: string }
  | { type: "hashtag"; value: string }
  | { type: "link"; value: string };

const SEGMENT_PATTERN =
  /(^|\s)@([a-zA-Z0-9_]{3,24})(?![a-zA-Z0-9_])|#([A-Za-z][A-Za-z0-9_]{2,24})|(https?:\/\/[^\s<]+)/g;

export function segmentBody(body: string): BodySegment[] {
  const segments: BodySegment[] = [];
  let cursor = 0;

  for (const match of body.matchAll(SEGMENT_PATTERN)) {
    const index = match.index ?? 0;
    const leading = match[1] ?? "";

    if (index > cursor) {
      segments.push({ type: "text", value: body.slice(cursor, index) });
    }
    if (leading) segments.push({ type: "text", value: leading });

    if (match[2]) segments.push({ type: "mention", handle: match[2].toLowerCase() });
    else if (match[3]) segments.push({ type: "hashtag", value: match[3].toLowerCase() });
    else if (match[4]) segments.push({ type: "link", value: match[4] });

    cursor = index + match[0].length;
  }

  if (cursor < body.length) segments.push({ type: "text", value: body.slice(cursor) });
  return segments;
}
