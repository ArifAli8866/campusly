import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";
import { ArrowLeft, MessageSquare, ShieldCheck, Users } from "lucide-react";

import { BRAND } from "@/components/brand";
import { PostCard } from "@/components/content/post-card";
import { PostComments } from "@/components/content/post-comments";
import { JoinButton } from "@/components/content/join-button";
import { Card } from "@/components/ui/primitives";
import { Button } from "@/components/ui/button";
import { compactNumber } from "@/lib/utils";
import { getCurrentContext } from "@/server/auth/context";
import {
  getChannelOverview,
  getComments,
  getMentionMaps,
  getPost,
  getReplies,
  viewerScope,
} from "@/server/services/queries";
import type { CommentView } from "@/lib/db/types";

export const dynamic = "force-dynamic";

export async function generateMetadata({
  params,
}: {
  params: Promise<{ id: string }>;
}): Promise<Metadata> {
  const { id } = await params;
  const scope = await viewerScope();
  const post = await getPost(scope, id);

  if (!post || post.deleted_at) {
    return { title: `Post Not Found — ${BRAND.name}` };
  }

  const snippet = post.body.slice(0, 120);
  const title = post.is_anonymous
    ? `Anonymous Confession: "${snippet}..."`
    : `${post.author_display_name ?? "Student"}: "${snippet}..."`;

  return {
    title: `${title} — ${BRAND.name}`,
    description: post.body.slice(0, 200),
  };
}

export default async function SinglePostPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;
  const scope = await viewerScope();
  const context = await getCurrentContext();

  const post = await getPost(scope, id);
  if (!post || post.deleted_at) {
    notFound();
  }

  const [channel, rootComments, mentionMaps] = await Promise.all([
    getChannelOverview(scope, post.channel_slug),
    getComments(scope, post.id, { limit: 20 }),
    getMentionMaps(scope, { postIds: [post.id] }),
  ]);

  // Fetch replies for roots that have reply_count > 0
  const replyPromises = rootComments
    .filter((c) => c.reply_count > 0)
    .map(async (c) => {
      const replies = await getReplies(scope, c.id, 50);
      return [c.id, replies] as const;
    });

  const replyEntries = await Promise.all(replyPromises);
  const initialReplies: Record<string, CommentView[]> = Object.fromEntries(replyEntries);

  return (
    <div className="mx-auto w-full max-w-5xl px-4 py-6 sm:py-8">
      {/* Back button */}
      <Button asChild variant="ghost" size="sm" className="mb-4 -ml-2">
        <Link href={`/channels/${post.channel_slug}`}>
          <ArrowLeft className="size-4" />
          Back to {post.university_abbreviation ?? post.university_name} ({post.campus_name})
        </Link>
      </Button>

      <div className="grid gap-8 lg:grid-cols-[minmax(0,1fr)_19rem]">
        {/* Main Column */}
        <div className="min-w-0 space-y-6">
          <PostCard post={post} mentions={mentionMaps.flat} />

          <section id="comments" className="surface p-5 sm:p-6">
            <h2 className="mb-4 flex items-center gap-2 text-base font-semibold text-foreground">
              <MessageSquare className="size-4 text-accent" />
              Comments & Replies
              <span className="text-xs text-muted-foreground font-normal">
                ({compactNumber(post.comment_count)})
              </span>
            </h2>

            <PostComments
              postId={post.id}
              channelSlug={post.channel_slug}
              signedIn={Boolean(context)}
              initialComments={rootComments}
              initialReplies={initialReplies}
              mentions={mentionMaps.flat}
              hasMoreInitially={rootComments.length === 20}
            />
          </section>
        </div>

        {/* Sidebar */}
        <aside className="space-y-5">
          {channel ? (
            <Card className="p-5">
              <p className="text-[0.6875rem] font-semibold uppercase tracking-wider text-muted-foreground">
                Posted In
              </p>
              <h3 className="mt-2 text-base font-bold text-foreground">
                <Link href={`/channels/${channel.slug}`} className="hover:underline">
                  {channel.campus_name}
                </Link>
              </h3>
              <p className="text-xs text-accent font-medium mt-0.5">
                {channel.university_abbreviation ?? channel.university_name}
              </p>

              <div className="mt-3 flex items-center gap-3 text-xs text-muted-foreground">
                <span className="flex items-center gap-1">
                  <Users className="size-3.5" /> {compactNumber(channel.member_count)}
                </span>
                <span className="flex items-center gap-1">
                  <MessageSquare className="size-3.5" /> {compactNumber(channel.post_count)}
                </span>
              </div>

              <div className="mt-4 pt-3 border-t border-border">
                <JoinButton
                  channelId={channel.id}
                  channelSlug={channel.slug}
                  isMember={channel.is_member}
                  signedIn={Boolean(context)}
                  size="sm"
                  className="w-full"
                />
              </div>
            </Card>
          ) : null}

          <Card className="p-4 bg-muted/30">
            <h3 className="flex items-center gap-1.5 text-xs font-semibold uppercase tracking-wider text-muted-foreground">
              <ShieldCheck className="size-4 text-success" />
              Privacy Assurance
            </h3>
            <p className="mt-2 text-xs leading-relaxed text-muted-foreground">
              {post.is_anonymous
                ? "This post was shared anonymously. The author's name, profile, and email are completely omitted from responses."
                : "This post was published openly with the author's public student profile."}
            </p>
          </Card>
        </aside>
      </div>
    </div>
  );
}
