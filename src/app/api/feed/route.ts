import { NextResponse } from "next/server";

import { getFeed, viewerScope } from "@/server/services/queries";
import { FEED_PAGE_SIZE } from "@/lib/constants";

export const runtime = "nodejs";
export const dynamic = "force-dynamic";

const SORTS = new Set(["latest", "trending", "most_liked", "following", "mentioned"]);

/**
 * Keyset-paginated feed endpoint used by the infinite scroll client component.
 *
 * It intentionally reuses the same `feed_posts` RPC as the server-rendered
 * first page, so pagination can never show a different (or wider) view of the
 * data than the initial render — including the anonymous-author rules.
 */
export async function GET(request: Request) {
  const url = new URL(request.url);

  const sort = url.searchParams.get("sort") ?? "latest";
  if (!SORTS.has(sort)) {
    return NextResponse.json({ error: "Unsupported sort order." }, { status: 400 });
  }

  const scope = await viewerScope();
  const isFollowing = sort === "following" || url.searchParams.get("following") === "1";

  const posts = await getFeed(scope, {
    channelId: url.searchParams.get("channelId"),
    sort: (sort === "following" ? "latest" : sort) as "latest" | "trending" | "most_liked" | "following" | "mentioned",
    cursor: url.searchParams.get("cursor"),
    cursorId: url.searchParams.get("cursorId"),
    category: url.searchParams.get("category"),
    search: url.searchParams.get("q"),
    followingOnly: isFollowing,
    limit: FEED_PAGE_SIZE,
  });

  return NextResponse.json({
    posts,
    hasMore: posts.length === FEED_PAGE_SIZE,
  });
}
