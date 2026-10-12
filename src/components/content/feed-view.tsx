"use client";

import { useCallback, useMemo } from "react";

import { Feed, type FeedFetcher } from "@/components/content/feed";
import type { PostView } from "@/lib/db/types";

export interface FeedQuery {
  sort?: "latest" | "trending" | "most_liked" | "following" | "mentioned";
  channelId?: string;
  category?: string;
  q?: string;
  following?: boolean;
}

/**
 * Client half of the feed.
 *
 * The server component renders page 1 through `getFeed`, and this component
 * fetches the *same* endpoint for every later page. Because both paths call one
 * query function, pagination cannot accidentally widen what a viewer is allowed
 * to see — in particular an anonymous author stays nulled on every page.
 */
export function FeedView({
  query,
  initialPosts,
  initialHasMore,
  emptyTitle,
  emptyDescription,
  mentions,
  hideChannel = false,
}: {
  query: FeedQuery;
  initialPosts: PostView[];
  initialHasMore: boolean;
  emptyTitle?: string;
  emptyDescription?: string;
  mentions?: Record<string, string>;
  hideChannel?: boolean;
}) {
  const queryKey = JSON.stringify(query);

  const fetchMore: FeedFetcher = useCallback(
    async (cursor) => {
      const params = new URLSearchParams();
      const parsed = JSON.parse(queryKey) as FeedQuery;

      if (parsed.sort) params.set("sort", parsed.sort);
      if (parsed.channelId) params.set("channelId", parsed.channelId);
      if (parsed.category) params.set("category", parsed.category);
      if (parsed.q) params.set("q", parsed.q);
      if (parsed.following) params.set("following", "1");
      if (cursor) {
        params.set("cursor", cursor.createdAt);
        params.set("cursorId", cursor.id);
      }

      const response = await fetch(`/api/feed?${params.toString()}`, {
        headers: { accept: "application/json" },
      });

      if (!response.ok) return { posts: [], hasMore: false };
      return (await response.json()) as { posts: PostView[]; hasMore: boolean };
    },
    [queryKey],
  );

  // A new server-rendered first page (filter change) must replace, not merge.
  const key = useMemo(() => queryKey, [queryKey]);

  return (
    <Feed
      key={key}
      initialPosts={initialPosts}
      initialHasMore={initialHasMore}
      fetchMore={fetchMore}
      emptyTitle={emptyTitle}
      emptyDescription={emptyDescription}
      mentions={mentions}
      hideChannel={hideChannel}
    />
  );
}
