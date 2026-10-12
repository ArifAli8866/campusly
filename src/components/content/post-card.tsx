"use client";

import Link from "next/link";
import { useOptimistic, useState, useTransition } from "react";
import {
  BarChart3,
  Bookmark,
  Building2,
  EyeOff,
  Flag,
  Link2,
  MessageCircle,
  MoreHorizontal,
  Pencil,
  Share2,
  ShieldAlert,
  Trash2,
  UserRoundX,
} from "lucide-react";
import { toast } from "sonner";

import { PostBody } from "@/components/content/post-body";
import { PollCard } from "@/components/content/poll-card";
import { ReportDialog } from "@/components/content/report-dialog";
import { Avatar, Badge } from "@/components/ui/primitives";
import { Button } from "@/components/ui/button";
import {
  ConfirmDialog,
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/overlays";
import { CATEGORY_LABEL } from "@/lib/constants";
import type { PostView } from "@/lib/db/types";
import { cn, compactNumber, relativeTime } from "@/lib/utils";
import { deletePostAction } from "@/server/actions/posts";
import { recordShareAction, togglePostLikeAction, toggleSavePostAction, toggleBlockUserAction } from "@/server/actions/social";

export interface PostCardProps {
  post: PostView;
  /** Handle -> username map for mentions that resolved when the post was made. */
  mentions?: Record<string, string>;
  /** Hide the channel line when the card already sits inside that channel. */
  hideChannel?: boolean;
  /** Compact density for sidebars and previews. */
  variant?: "default" | "compact";
  onDeleted?: (postId: string) => void;
  /** Shown to moderators and to the author. */
  onModerate?: (postId: string) => void;
  className?: string;
}

export function PostCard({
  post,
  mentions,
  hideChannel = false,
  variant = "default",
  onDeleted,
  onModerate,
  className,
}: PostCardProps) {
  const [isPending, startTransition] = useTransition();
  const [saved, setSaved] = useState(post.viewer_has_saved);
  const [hidden, setHidden] = useState(false);

  /**
   * Optimistic likes are safe here because the server response is authoritative
   * and cheap: the unique index means the only two outcomes are "liked" or
   * "not liked", and the returned value overwrites our guess.
   */
  const [liked, setLiked] = useOptimistic(post.viewer_has_liked, (_state, next: boolean) => next);
  const [likeCount, setLikeCount] = useOptimistic(post.like_count, (state, delta: number) => Math.max(state + delta, 0));

  const isAnonymous = post.is_anonymous;
  // `author_id` is null for other people's anonymous posts — by construction,
  // not by a CSS trick. There is nothing to accidentally reveal.
  const authorName = isAnonymous ? "Anonymous" : (post.author_display_name ?? "Student");
  const authorUsername = isAnonymous ? null : post.author_username;

  function handleLike() {
    const next = !liked;
    startTransition(async () => {
      setLiked(next);
      setLikeCount(next ? 1 : -1);

      const result = await togglePostLikeAction(post.id);
      if (!result.ok) {
        toast.error(result.error);
        return;
      }
      // Reconcile with the server's answer.
      if (result.data && result.data.liked !== next) setLiked(result.data.liked);
    });
  }

  function handleSave() {
    startTransition(async () => {
      const result = await toggleSavePostAction(post.id);
      if (!result.ok) {
        toast.error(result.error);
        return;
      }
      setSaved(Boolean(result.data?.saved));
      toast.success(result.message ?? "Saved.");
    });
  }

  async function handleShare() {
    const url = `${window.location.origin}/p/${post.id}`;
    try {
      if (typeof navigator !== "undefined" && navigator.share) {
        await navigator.share({ title: "Campusly confession", url });
        await recordShareAction(post.id, "native");
        return;
      }
      await navigator.clipboard.writeText(url);
      await recordShareAction(post.id, "copy_link");
      toast.success("Link copied. Anonymous posts stay anonymous in the preview.");
    } catch {
      toast.error("Could not copy the link.");
    }
  }

  function handleDelete() {
    startTransition(async () => {
      const result = await deletePostAction(post.id);
      if (!result.ok) {
        toast.error(result.error);
        return;
      }
      setHidden(true);
      onDeleted?.(post.id);
      toast.success(result.message ?? "Post deleted.");
    });
  }

  function handleBlock() {
    if (!post.author_id) return;
    startTransition(async () => {
      const result = await toggleBlockUserAction(post.author_id!);
      if (!result.ok) {
        toast.error(result.error);
        return;
      }
      setHidden(true);
      toast.success(result.message ?? "Blocked.");
    });
  }

  if (hidden) return null;

  const removed = post.moderation_status !== "published";

  return (
    <article
      className={cn(
        "surface animate-rise",
        variant === "compact" ? "p-4" : "p-5",
        removed && "border-dashed",
        className,
      )}
    >
      {/* ---------------------------------------------------- header */}
      <header className="flex items-start gap-3">
        <Avatar
          src={authorAvatar(post)}
          name={authorName}
          anonymous={isAnonymous}
          seed={post.id}
          size="md"
        />

        <div className="min-w-0 flex-1">
          <div className="flex flex-wrap items-center gap-x-1.5 gap-y-0.5 text-[0.8125rem]">
            {authorUsername ? (
              <Link href={`/u/${authorUsername}`} className="font-semibold hover:underline">
                {authorName}
              </Link>
            ) : (
              <span className="font-semibold text-muted-foreground">Anonymous</span>
            )}

            {authorUsername ? (
              <span className="text-muted-foreground">@{authorUsername}</span>
            ) : (
              <Badge variant="neutral" size="sm" className="gap-1">
                <EyeOff className="size-2.5" aria-hidden />
                Anonymous
              </Badge>
            )}

            {isAnonymous && post.viewer_can_manage ? (
              <Badge variant="subtle" size="sm">
                You
              </Badge>
            ) : null}

            <span aria-hidden className="text-muted-foreground">
              ·
            </span>
            <time dateTime={post.created_at} className="text-muted-foreground">
              {relativeTime(post.created_at)}
            </time>
            {post.edited_at ? <span className="text-muted-foreground">(edited)</span> : null}
          </div>

          {!hideChannel ? (
            <div className="mt-0.5 flex flex-wrap items-center gap-1.5 text-xs text-muted-foreground">
              <Building2 className="size-3" aria-hidden />
              <Link href={`/channels/${post.channel_slug}`} className="hover:text-foreground hover:underline">
                {post.university_abbreviation ?? post.university_name}
              </Link>
              {post.campus_name ? <span>· {post.campus_name.replace(/ Campus$/, "")}</span> : null}
            </div>
          ) : null}
        </div>

        <div className="flex items-center gap-1">
          {post.category ? (
            <Badge variant="outline" size="sm" className="hidden sm:inline-flex">
              {CATEGORY_LABEL[post.category]}
            </Badge>
          ) : null}

          <DropdownMenu>
            <DropdownMenuTrigger asChild>
              <Button variant="ghost" size="icon-sm" aria-label="Post options">
                <MoreHorizontal />
              </Button>
            </DropdownMenuTrigger>
            <DropdownMenuContent>
              {post.viewer_can_manage ? (
                <>
                  <DropdownMenuItem asChild>
                    <Link href={`/p/${post.id}/edit`}>
                      <Pencil /> Edit post
                    </Link>
                  </DropdownMenuItem>
                  <ConfirmDialog
                    trigger={
                      <DropdownMenuItem destructive onSelect={(event) => event.preventDefault()}>
                        <Trash2 /> Delete post
                      </DropdownMenuItem>
                    }
                    title="Delete this post?"
                    description="It will be removed from every feed. Moderation history is retained for safety."
                    confirmLabel="Delete"
                    loading={isPending}
                    onConfirm={handleDelete}
                  />
                  <DropdownMenuSeparator />
                </>
              ) : null}

              {!isAnonymous && post.author_id && !post.viewer_can_manage ? (
                <ConfirmDialog
                  trigger={
                    <DropdownMenuItem destructive onSelect={(event) => event.preventDefault()}>
                      <UserRoundX /> Block @{post.author_username}
                    </DropdownMenuItem>
                  }
                  title={`Block @${post.author_username}?`}
                  description="You will no longer see each other's posts or comments."
                  confirmLabel="Block"
                  onConfirm={handleBlock}
                />
              ) : null}

              <ReportDialog
                targetType="post"
                targetId={post.id}
                trigger={
                  <DropdownMenuItem onSelect={(event) => event.preventDefault()}>
                    <Flag /> Report post
                  </DropdownMenuItem>
                }
              />

              {onModerate && post.viewer_can_manage ? (
                <DropdownMenuItem onSelect={() => onModerate(post.id)}>
                  <ShieldAlert /> Moderation details
                </DropdownMenuItem>
              ) : null}
            </DropdownMenuContent>
          </DropdownMenu>
        </div>
      </header>

      {/* ---------------------------------------------------- body */}
      {removed ? (
        <div className="mt-3 rounded-lg border border-dashed border-border bg-muted/40 px-3 py-2 text-xs text-muted-foreground">
          This post is {post.moderation_status === "hidden" ? "hidden pending review" : "no longer visible"}.
          {post.viewer_can_manage ? " Only you and moderators can see it." : ""}
        </div>
      ) : null}

      <div className="mt-3">
        <PostBody body={post.body} resolved={mentions} />
      </div>

      {post.media_path ? (
        <div className="mt-3 overflow-hidden rounded-lg border border-border bg-muted">
          {/* eslint-disable-next-line @next/next/no-img-element */}
          <img
            src={post.media_path}
            alt="Attached image"
            width={post.media_width ?? undefined}
            height={post.media_height ?? undefined}
            loading="lazy"
            decoding="async"
            className="max-h-[28rem] w-full object-cover"
          />
        </div>
      ) : null}

      {post.poll ? <PollCard postId={post.id} poll={post.poll} /> : null}

      {/* ---------------------------------------------------- actions */}
      <footer className="mt-4 flex items-center gap-1 border-t border-border pt-3">
        <Button
          variant="ghost"
          size="sm"
          onClick={handleLike}
          aria-pressed={liked}
          aria-label={liked ? `Unlike. ${likeCount} likes` : `Like. ${likeCount} likes`}
          className={cn("gap-1.5", liked && "text-danger hover:text-danger")}
        >
          <HeartIcon filled={liked} />
          <span className="tabular-nums">{compactNumber(likeCount)}</span>
        </Button>

        <Button asChild variant="ghost" size="sm" className="gap-1.5">
          <Link href={`/p/${post.id}#comments`} aria-label={`${post.comment_count} comments`}>
            <MessageCircle />
            <span className="tabular-nums">{compactNumber(post.comment_count)}</span>
          </Link>
        </Button>

        <Button variant="ghost" size="sm" onClick={handleShare} className="gap-1.5" aria-label="Share this post">
          <Share2 />
          <span className="hidden sm:inline">Share</span>
        </Button>

        {post.poll ? (
          <span className="ml-1 hidden items-center gap-1 text-xs text-muted-foreground sm:inline-flex">
            <BarChart3 className="size-3" aria-hidden />
            Poll
          </span>
        ) : null}

        <div className="ml-auto flex items-center gap-1">
          <Button
            variant="ghost"
            size="sm"
            onClick={handleSave}
            aria-pressed={saved}
            aria-label={saved ? "Remove from saved" : "Save privately"}
            className={cn("gap-1.5", saved && "text-accent")}
          >
            <Bookmark className={cn(saved && "fill-current")} />
            <span className="hidden sm:inline">{saved ? "Saved" : "Save"}</span>
          </Button>

          <Button
            variant="ghost"
            size="icon-sm"
            onClick={handleShare}
            aria-label="Copy link to this post"
            className="hidden sm:inline-flex"
          >
            <Link2 />
          </Button>
        </div>
      </footer>
    </article>
  );
}

/**
 * Anonymous posts must not even hint at an avatar. `author_avatar_url` arrives
 * null from the database, and we pass `anonymous` so the fallback renders the
 * neutral mark regardless.
 */
function authorAvatar(post: PostView): string | null {
  return post.is_anonymous ? null : post.author_avatar_url;
}

function HeartIcon({ filled }: { filled: boolean }) {
  return (
    <svg
      viewBox="0 0 24 24"
      className="size-4"
      fill={filled ? "currentColor" : "none"}
      stroke="currentColor"
      strokeWidth={filled ? 0 : 1.9}
      strokeLinecap="round"
      strokeLinejoin="round"
      aria-hidden
    >
      <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l8.84 8.84 8.84-8.84a5.5 5.5 0 0 0 0-7.78Z" />
    </svg>
  );
}
