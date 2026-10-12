"use client";

import { useCallback, useEffect, useRef, useState } from "react";
import { Loader2, MessageSquareDashed } from "lucide-react";

import { PostCard } from "@/components/content/post-card";
import { Button } from "@/components/ui/button";
import { EmptyState, PostCardSkeleton } from "@/components/ui/primitives";
import type { PostView } from "@/lib/db/types";

export interface FeedFetcher {
  (cursor: { createdAt: string; id: string } | null): Promise<{ posts: PostView[]; hasMore: boolean }>;
}

/**
 * Infinite feed with a stable cursor.
 *
 * Pagination is keyset-based on (created_at, id) for "latest", so inserting new
 * posts while a student scrolls cannot cause a duplicate or a skipped page — an
 * OFFSET-based feed has exactly that bug under load.
 */
export function Feed({
  initialPosts,
  initialHasMore,
  fetchMore,
  emptyTitle = "Nothing here yet",
  emptyDescription = "When students post in this community, you will see it here.",
  mentions,
  hideChannel = false,
}: {
  initialPosts: PostView[];
  initialHasMore: boolean;
  fetchMore: FeedFetcher;
  emptyTitle?: string;
  emptyDescription?: string;
  mentions?: Record<string, string>;
  hideChannel?: boolean;
}) {
  const [posts, setPosts] = useState(initialPosts);
  const [hasMore, setHasMore] = useState(initialHasMore);
  const [loading, setLoading] = useState(false);
  const sentinel = useRef<HTMLDivElement | null>(null);

  // Reset when the server sends a fresh first page (filter change, refresh).
  useEffect(() => {
    setPosts(initialPosts);
    setHasMore(initialHasMore);
  }, [initialPosts, initialHasMore]);

  const loadMore = useCallback(async () => {
    if (loading || !hasMore || posts.length === 0) return;
    setLoading(true);
    try {
      const last = posts[posts.length - 1]!;
      const result = await fetchMore({ createdAt: last.created_at, id: last.id });
      setPosts((current) => {
        const seen = new Set(current.map((post) => post.id));
        return [...current, ...result.posts.filter((post) => !seen.has(post.id))];
      });
      setHasMore(result.hasMore);
    } finally {
      setLoading(false);
    }
  }, [fetchMore, hasMore, loading, posts]);

  useEffect(() => {
    const node = sentinel.current;
    if (!node || !hasMore) return;

    const observer = new IntersectionObserver(
      (entries) => {
        if (entries[0]?.isIntersecting) void loadMore();
      },
      { rootMargin: "600px 0px" },
    );

    observer.observe(node);
    return () => observer.disconnect();
  }, [hasMore, loadMore]);

  function handleDeleted(postId: string) {
    setPosts((current) => current.filter((post) => post.id !== postId));
  }

  if (posts.length === 0) {
    return <EmptyState icon={MessageSquareDashed} title={emptyTitle} description={emptyDescription} />;
  }

  return (
    <div className="space-y-3">
      {posts.map((post) => (
        <PostCard key={post.id} post={post} mentions={mentions} hideChannel={hideChannel} onDeleted={handleDeleted} />
      ))}

      {loading ? (
        <>
          <PostCardSkeleton />
          <PostCardSkeleton />
        </>
      ) : null}

      {/* Sentinel: also the accessible affordance for keyboard users. */}
      <div ref={sentinel} aria-hidden className="h-px" />

      {hasMore ? (
        <div className="flex justify-center py-2">
          <Button variant="outline" size="sm" onClick={loadMore} loading={loading} loadingLabel="Loading…">
            <Loader2 className={loading ? "animate-spin" : ""} /> Load more
          </Button>
        </div>
      ) : (
        <p className="py-4 text-center text-xs text-muted-foreground">You have reached the end of this feed.</p>
      )}
    </div>
  );
}
