"use client";

import { useEffect, useState } from "react";

import { CommentComposer, CommentThread } from "@/components/content/comment-thread";
import { useRouter } from "next/navigation";
import type { CommentView } from "@/lib/db/types";

/**
 * Comments for a single post.
 *
 * Root comments are paginated through /api/comments (same RPCs as the first
 * page). New comments do not get spliced in optimistically: an anonymous
 * comment's public shape is decided in the database, so we let the server
 * re-render rather than invent a local copy that might carry the author's name.
 */
export function PostComments({
  postId,
  channelSlug,
  signedIn,
  allowAnonymous = true,
  initialComments,
  initialReplies,
  mentions,
  hasMoreInitially,
}: {
  postId: string;
  channelSlug: string;
  signedIn: boolean;
  allowAnonymous?: boolean;
  initialComments: CommentView[];
  initialReplies: Record<string, CommentView[]>;
  mentions?: Record<string, string>;
  hasMoreInitially: boolean;
}) {
  const router = useRouter();
  const [comments, setComments] = useState(initialComments);
  const [replies, setReplies] = useState(initialReplies);
  const [hasMore, setHasMore] = useState(hasMoreInitially);
  const [loading, setLoading] = useState(false);

  // Replace local state whenever the server sends a fresh first page.
  useEffect(() => {
    setComments(initialComments);
    setReplies(initialReplies);
    setHasMore(hasMoreInitially);
  }, [initialComments, initialReplies, hasMoreInitially]);

  async function loadMore() {
    if (loading || !hasMore) return;
    setLoading(true);
    try {
      const last = comments[comments.length - 1];
      if (!last) return;
      const params = new URLSearchParams({ postId, cursor: last.created_at, cursorId: last.id });
      const response = await fetch(`/api/comments?${params.toString()}`, {
        headers: { accept: "application/json" },
      });
      if (!response.ok) return;

      const data = (await response.json()) as {
        comments: CommentView[];
        replies: Record<string, CommentView[]>;
        hasMore: boolean;
      };

      setComments((current) => {
        const seen = new Set(current.map((comment) => comment.id));
        return [...current, ...data.comments.filter((comment) => !seen.has(comment.id))];
      });
      setReplies((current) => ({ ...current, ...data.replies }));
      setHasMore(data.hasMore);
    } finally {
      setLoading(false);
    }
  }

  return (
    <div className="space-y-3">
      <CommentComposer
        postId={postId}
        channelSlug={channelSlug}
        signedIn={signedIn}
        allowAnonymous={allowAnonymous}
      />

      <CommentThread
        postId={postId}
        comments={comments}
        replies={replies}
        mentions={mentions}
        signedIn={signedIn}
        allowAnonymousComments={allowAnonymous}
        onLoadMore={() => void loadMore()}
        hasMore={hasMore}
        loadingMore={loading}
      />

      {!signedIn ? (
        <p className="px-1 text-xs text-muted-foreground">
          You can read every comment signed out.{" "}
          <button type="button" className="underline underline-offset-2" onClick={() => router.push("/login")}>
            Log in
          </button>{" "}
          to reply.
        </p>
      ) : null}
    </div>
  );
}
