"use client";

import Link from "next/link";
import { useRouter } from "next/navigation";
import { useState, useTransition } from "react";
import { CornerDownRight, EyeOff, Flag, Heart, MoreHorizontal, Reply, Send, Trash2 } from "lucide-react";
import { toast } from "sonner";

import { PostBody } from "@/components/content/post-body";
import { ReportDialog } from "@/components/content/report-dialog";
import { Avatar, Badge, EmptyState, Skeleton } from "@/components/ui/primitives";
import { Button } from "@/components/ui/button";
import { Textarea } from "@/components/ui/fields";
import {
  ConfirmDialog,
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/overlays";
import { COMMENT_MAX_LENGTH } from "@/lib/constants";
import type { CommentView } from "@/lib/db/types";
import { cn, compactNumber, relativeTime } from "@/lib/utils";
import { createCommentAction, deleteCommentAction } from "@/server/actions/comments";
import { toggleCommentLikeAction } from "@/server/actions/social";

interface CommentThreadProps {
  postId: string;
  comments: CommentView[];
  replies: Record<string, CommentView[]>;
  mentions?: Record<string, string>;
  signedIn: boolean;
  allowAnonymousComments?: boolean;
  /** Fetches the next page of root comments. */
  onLoadMore?: () => void;
  hasMore?: boolean;
  loadingMore?: boolean;
  className?: string;
}

export function CommentThread({
  postId,
  comments,
  replies,
  mentions,
  signedIn,
  allowAnonymousComments = true,
  onLoadMore,
  hasMore,
  loadingMore,
  className,
}: CommentThreadProps) {
  const [replyTo, setReplyTo] = useState<string | null>(null);
  const [expanded, setExpanded] = useState<Set<string>>(new Set());
  const [hidden, setHidden] = useState<Set<string>>(new Set());

  function toggleReplies(commentId: string) {
    setExpanded((current) => {
      const next = new Set(current);
      if (next.has(commentId)) next.delete(commentId);
      else next.add(commentId);
      return next;
    });
  }

  function markHidden(commentId: string) {
    setHidden((current) => new Set(current).add(commentId));
  }

  if (comments.length === 0) {
    return (
      <div id="comments" className={className}>
        <EmptyState
          icon={Send}
          title="No comments yet"
          description="Be the first to reply. Comments on an anonymous confession never reveal who wrote it."
        />
      </div>
    );
  }

  return (
    <div id="comments" className={cn("space-y-3", className)}>
      <ul className="space-y-3">
        {comments
          .filter((comment) => !hidden.has(comment.id))
          .map((comment) => {
            const commentReplies = (replies[comment.id] ?? []).filter((reply) => !hidden.has(reply.id));
            const isOpen = expanded.has(comment.id);

            return (
              <li key={comment.id} className="space-y-2">
                <CommentRow
                  comment={comment}
                  postId={postId}
                  mentions={mentions}
                  signedIn={signedIn}
                  onReply={() => setReplyTo(replyTo === comment.id ? null : comment.id)}
                  onDelete={() => markHidden(comment.id)}
                />

                {replyTo === comment.id ? (
                  <ReplyForm
                    postId={postId}
                    parentId={comment.id}
                    signedIn={signedIn}
                    allowAnonymousComments={allowAnonymousComments}
                    onDone={() => setReplyTo(null)}
                    className="ml-7 sm:ml-11"
                  />
                ) : null}

                {comment.reply_count > 0 ? (
                  <div className="ml-7 sm:ml-11">
                    <Button
                      variant="link"
                      size="sm"
                      onClick={() => toggleReplies(comment.id)}
                      aria-expanded={isOpen}
                      className="gap-1.5 text-xs"
                    >
                      <CornerDownRight className="size-3" aria-hidden />
                      {isOpen ? "Hide" : "Show"} {compactNumber(comment.reply_count)}{" "}
                      {comment.reply_count === 1 ? "reply" : "replies"}
                    </Button>
                  </div>
                ) : null}

                {isOpen && commentReplies.length > 0 ? (
                  <ul className="ml-7 space-y-2 border-l border-border pl-3 sm:ml-11">
                    {commentReplies.map((reply) => (
                      <li key={reply.id}>
                        <CommentRow
                          comment={reply}
                          postId={postId}
                          mentions={mentions}
                          signedIn={signedIn}
                          isReply
                          onReply={() => setReplyTo(reply.id)}
                          onDelete={() => markHidden(reply.id)}
                        />
                        {replyTo === reply.id ? (
                          <ReplyForm
                            postId={postId}
                            parentId={reply.id}
                            signedIn={signedIn}
                            allowAnonymousComments={allowAnonymousComments}
                            onDone={() => setReplyTo(null)}
                            className="mt-2"
                          />
                        ) : null}
                      </li>
                    ))}
                  </ul>
                ) : null}
              </li>
            );
          })}
      </ul>

      {hasMore && onLoadMore ? (
        <div className="flex justify-center pt-1">
          <Button variant="outline" size="sm" onClick={onLoadMore} loading={loadingMore} loadingLabel="Loading…">
            Load more comments
          </Button>
        </div>
      ) : null}
    </div>
  );
}

/* ------------------------------------------------------------------ one row */

function CommentRow({
  comment,
  mentions,
  signedIn,
  isReply = false,
  onReply,
  onDelete,
}: {
  comment: CommentView;
  postId?: string;
  mentions?: Record<string, string>;
  signedIn: boolean;
  isReply?: boolean;
  onReply: () => void;
  onDelete: () => void;
}) {
  const [isPending, startTransition] = useTransition();
  const [liked, setLiked] = useState(comment.viewer_has_liked);
  const [likeCount, setLikeCount] = useState(comment.like_count);

  // An anonymous comment exposes nothing: the RPC already nulled author fields.
  const name = comment.is_anonymous ? "Anonymous" : (comment.author_display_name ?? "Student");
  const username = comment.is_anonymous ? null : comment.author_username;

  function toggleLike() {
    const next = !liked;
    setLiked(next);
    setLikeCount((count) => Math.max(count + (next ? 1 : -1), 0));
    startTransition(async () => {
      const result = await toggleCommentLikeAction(comment.id);
      if (!result.ok) {
        setLiked(!next);
        setLikeCount((count) => Math.max(count + (next ? -1 : 1), 0));
        toast.error(result.error);
      }
    });
  }

  function remove() {
    startTransition(async () => {
      const result = await deleteCommentAction(comment.id);
      if (!result.ok) {
        toast.error(result.error);
        return;
      }
      onDelete();
      toast.success(result.message ?? "Comment deleted.");
    });
  }

  return (
    <article className={cn("group", isReply && "pt-1")}>
      <div className="flex items-start gap-2.5">
        <Avatar
          src={comment.is_anonymous ? null : comment.author_avatar_url}
          name={name}
          anonymous={comment.is_anonymous}
          seed={comment.id}
          size="sm"
        />

        <div className="min-w-0 flex-1">
          <div className="flex flex-wrap items-center gap-x-1.5 gap-y-0.5 rounded-xl bg-muted/45 px-3 py-2">
            <div className="flex w-full flex-wrap items-center gap-x-1.5 text-[0.8125rem]">
              {username ? (
                <Link href={`/u/${username}`} className="font-semibold hover:underline">
                  {name}
                </Link>
              ) : (
                <span className="font-semibold text-muted-foreground">Anonymous</span>
              )}

              {comment.is_anonymous ? (
                <Badge variant="neutral" size="sm" className="gap-1">
                  <EyeOff className="size-2.5" aria-hidden /> Anonymous
                </Badge>
              ) : null}

              <time dateTime={comment.created_at} className="text-muted-foreground">
                · {relativeTime(comment.created_at)}
              </time>
              {comment.edited_at ? <span className="text-muted-foreground">(edited)</span> : null}
            </div>

            <div className="mt-1 w-full">
              <PostBody
                body={comment.body}
                resolved={mentions}
                className="[&_p]:text-[0.8125rem] [&_p]:leading-relaxed"
              />
            </div>
          </div>

          <div className="mt-1 flex items-center gap-0.5 pl-1">
            <Button
              variant="ghost"
              size="sm"
              onClick={toggleLike}
              aria-pressed={liked}
              aria-label={liked ? "Unlike comment" : "Like comment"}
              className={cn("h-7 gap-1 px-2 text-xs", liked && "text-danger hover:text-danger")}
            >
              <Heart className={cn("size-3.5", liked && "fill-current")} />
              {likeCount > 0 ? <span className="tabular-nums">{compactNumber(likeCount)}</span> : null}
            </Button>

            {signedIn ? (
              <Button variant="ghost" size="sm" onClick={onReply} className="h-7 gap-1 px-2 text-xs">
                <Reply className="size-3.5" /> Reply
              </Button>
            ) : null}

            <DropdownMenu>
              <DropdownMenuTrigger asChild>
                <Button
                  variant="ghost"
                  size="icon-sm"
                  className="h-7 w-7 opacity-0 transition-opacity group-hover:opacity-100 focus-visible:opacity-100"
                  aria-label="Comment options"
                >
                  <MoreHorizontal />
                </Button>
              </DropdownMenuTrigger>
              <DropdownMenuContent>
                <ReportDialog
                  targetType="comment"
                  targetId={comment.id}
                  trigger={
                    <DropdownMenuItem onSelect={(event) => event.preventDefault()}>
                      <Flag /> Report comment
                    </DropdownMenuItem>
                  }
                />
                {comment.viewer_can_manage ? (
                  <>
                    <DropdownMenuSeparator />
                    <ConfirmDialog
                      trigger={
                        <DropdownMenuItem destructive onSelect={(event) => event.preventDefault()}>
                          <Trash2 /> Delete comment
                        </DropdownMenuItem>
                      }
                      title="Delete this comment?"
                      description="It will be removed from the thread. The moderation record is kept."
                      confirmLabel="Delete"
                      loading={isPending}
                      onConfirm={remove}
                    />
                  </>
                ) : null}
              </DropdownMenuContent>
            </DropdownMenu>
          </div>
        </div>
      </div>
    </article>
  );
}

/* --------------------------------------------------------------- reply form */

function ReplyForm({
  postId,
  parentId,
  signedIn,
  allowAnonymousComments,
  onDone,
  className,
}: {
  postId: string;
  parentId: string;
  signedIn: boolean;
  allowAnonymousComments: boolean;
  onDone: () => void;
  className?: string;
}) {
  const [body, setBody] = useState("");
  const [isAnonymous, setIsAnonymous] = useState(false);
  const [isPending, startTransition] = useTransition();

  if (!signedIn) {
    return (
      <p className={cn("text-xs text-muted-foreground", className)}>
        <Link href={`/login?next=/p/${postId}`} className="font-medium text-accent hover:underline">
          Sign in
        </Link>{" "}
        to reply.
      </p>
    );
  }

  function submit(formData: FormData) {
    startTransition(async () => {
      const result = await createCommentAction(formData);
      if (!result.ok) {
        toast.error(result.error);
        return;
      }
      setBody("");
      onDone();
      toast.success(result.message ?? "Reply posted.");
    });
  }

  return (
    <form action={submit} className={cn("space-y-2", className)}>
      <input type="hidden" name="postId" value={postId} />
      <input type="hidden" name="parentId" value={parentId} />
      <input type="hidden" name="isAnonymous" value={String(isAnonymous)} />

      <Textarea
        name="body"
        value={body}
        onChange={(event) => setBody(event.target.value.slice(0, COMMENT_MAX_LENGTH))}
        placeholder="Write a reply…"
        rows={2}
        maxLength={COMMENT_MAX_LENGTH}
        aria-label="Reply text"
      />

      <div className="flex items-center gap-2">
        {allowAnonymousComments ? (
          <Button
            type="button"
            variant={isAnonymous ? "subtle" : "ghost"}
            size="sm"
            onClick={() => setIsAnonymous((value) => !value)}
            aria-pressed={isAnonymous}
            className="gap-1.5 text-xs"
          >
            <EyeOff className="size-3.5" />
            {isAnonymous ? "Replying anonymously" : "Reply anonymously"}
          </Button>
        ) : null}

        <span className="ml-auto text-[0.6875rem] tabular-nums text-muted-foreground">
          {COMMENT_MAX_LENGTH - body.length}
        </span>

        <Button type="button" variant="ghost" size="sm" onClick={onDone}>
          Cancel
        </Button>
        <Button type="submit" size="sm" loading={isPending} loadingLabel="Posting…" disabled={body.trim().length === 0}>
          Reply
        </Button>
      </div>
    </form>
  );
}

/* ------------------------------------------------------- top-level comment box */

export function CommentComposer({
  postId,
  channelSlug,
  signedIn,
  allowAnonymous = true,
}: {
  postId: string;
  channelSlug: string;
  signedIn: boolean;
  allowAnonymous?: boolean;
}) {
  const router = useRouter();
  const [body, setBody] = useState("");
  const [isAnonymous, setIsAnonymous] = useState(false);
  const [isPending, startTransition] = useTransition();

  if (!signedIn) {
    return (
      <div className="surface flex flex-wrap items-center justify-between gap-3 p-4">
        <p className="text-sm text-muted-foreground">Sign in to join the conversation.</p>
        <div className="flex gap-2">
          <Button asChild variant="outline" size="sm">
            <Link href={`/login?next=/channels/${channelSlug}`}>Log in</Link>
          </Button>
          <Button asChild size="sm">
            <Link href={`/signup?next=/channels/${channelSlug}`}>Create account</Link>
          </Button>
        </div>
      </div>
    );
  }

  function submit(formData: FormData) {
    startTransition(async () => {
      const result = await createCommentAction(formData);
      if (!result.ok) {
        toast.error(result.error);
        return;
      }
      setBody("");
      toast.success(result.message ?? "Comment posted.");
      // The server is the only place that knows how to project an anonymous
      // comment, so re-render from it rather than guessing at a local shape.
      router.refresh();
    });
  }

  return (
    <form action={submit} className="surface space-y-2 p-4">
      <input type="hidden" name="postId" value={postId} />
      <input type="hidden" name="isAnonymous" value={String(isAnonymous)} />

      <label htmlFor="comment-body" className="text-[0.8125rem] font-medium">
        Add a comment
      </label>
      <Textarea
        id="comment-body"
        name="body"
        value={body}
        onChange={(event) => setBody(event.target.value.slice(0, COMMENT_MAX_LENGTH))}
        placeholder="What do you think?"
        rows={3}
        maxLength={COMMENT_MAX_LENGTH}
      />

      <div className="flex flex-wrap items-center gap-2">
        {allowAnonymous ? (
          <Button
            type="button"
            variant={isAnonymous ? "subtle" : "ghost"}
            size="sm"
            onClick={() => setIsAnonymous((value) => !value)}
            aria-pressed={isAnonymous}
            className="gap-1.5"
          >
            <EyeOff className="size-3.5" />
            {isAnonymous ? "Commenting anonymously" : "Comment anonymously"}
          </Button>
        ) : null}

        <span className="ml-auto text-xs tabular-nums text-muted-foreground">
          {COMMENT_MAX_LENGTH - body.length} left
        </span>

        <Button type="submit" size="sm" loading={isPending} loadingLabel="Posting…" disabled={body.trim().length === 0}>
          <Send /> Comment
        </Button>
      </div>
    </form>
  );
}

export function CommentSkeleton() {
  return (
    <div className="flex gap-2.5">
      <Skeleton className="size-8 rounded-full" />
      <div className="flex-1 space-y-2">
        <Skeleton className="h-3 w-40" />
        <Skeleton className="h-14 w-full rounded-xl" />
      </div>
    </div>
  );
}
