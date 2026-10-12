import { NextResponse } from "next/server";

import { COMMENT_PAGE_SIZE } from "@/lib/constants";
import { getComments, getReplies, viewerScope } from "@/server/services/queries";

export const runtime = "nodejs";
export const dynamic = "force-dynamic";

const UUID = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

/**
 * Paginated comments for a post.
 *
 * Goes through the same RPCs as the server-rendered first page, so the anonymity
 * projection (author_* nulled for anonymous rows) can never be bypassed by
 * paginating on the client.
 */
export async function GET(request: Request) {
  const url = new URL(request.url);
  const postId = url.searchParams.get("postId") ?? "";
  const cursor = url.searchParams.get("cursor");
  const cursorId = url.searchParams.get("cursorId");

  if (!UUID.test(postId)) {
    return NextResponse.json({ error: "A valid postId is required." }, { status: 400 });
  }

  const scope = await viewerScope();
  // Keyset pagination on (created_at, id), matching the feed: a comment added
  // while a student is reading cannot shift a page and duplicate or skip a row.
  const comments = await getComments(scope, postId, {
    cursor,
    cursorId: UUID.test(cursorId ?? "") ? cursorId : null,
    limit: COMMENT_PAGE_SIZE,
  });

  const entries = await Promise.all(
    comments
      .filter((comment) => comment.reply_count > 0)
      .map(async (comment) => [comment.id, await getReplies(scope, comment.id)] as const),
  );

  return NextResponse.json({
    comments,
    replies: Object.fromEntries(entries),
    hasMore: comments.length === COMMENT_PAGE_SIZE,
  });
}
