import type { Metadata } from "next";
import Link from "next/link";
import { Compass, Flame, Layers, PenLine, Sparkles } from "lucide-react";

import { Composer, type ComposerChannel } from "@/components/content/composer";
import { FeedView } from "@/components/content/feed-view";
import { Badge, EmptyState } from "@/components/ui/primitives";
import { Button } from "@/components/ui/button";
import { PageHeader } from "@/components/layout/page-header";
import { FEED_PAGE_SIZE } from "@/lib/constants";
import { compactNumber } from "@/lib/utils";
import { requireOnboarded } from "@/server/auth/context";
import {
  getFeed,
  getMentionMaps,
  getMyChannels,
  getRecommendedChannels,
  getTrendingTopics,
  getWeeklyHighlights,
} from "@/server/services/queries";

export const metadata: Metadata = {
  title: "Home",
  robots: { index: false, follow: false },
};

export const dynamic = "force-dynamic";

export default async function HomePage() {
  const context = await requireOnboarded("/home");
  const scope = { db: context.db, userId: context.id };

  const [myChannels, firstPage, highlights, topics, recommended] = await Promise.all([
    getMyChannels(scope, 60),
    getFeed(scope, { sort: "latest", limit: FEED_PAGE_SIZE, followingOnly: true }),
    getWeeklyHighlights(scope, 3),
    getTrendingTopics(scope, { limit: 8, days: 30 }),
    getRecommendedChannels(scope, 4),
  ]);

  const mentionMaps = await getMentionMaps(scope, { postIds: firstPage.map((post) => post.id) });

  const composerChannels: ComposerChannel[] = myChannels.map((channel) => ({
    id: channel.channel_id,
    slug: channel.channel_slug,
    name: channel.university_abbreviation ?? channel.university_name,
    label: `${channel.university_abbreviation ?? channel.university_name} · ${channel.campus_name.replace(/ Campus$/, "")}`,
  }));

  const joinedAny = composerChannels.length > 0;

  return (
    <div className="mx-auto w-full max-w-6xl px-4 py-6 sm:py-8">
      <div className="grid gap-8 lg:grid-cols-[minmax(0,1fr)_20rem]">
        {/* ---------------------------------------------------------- main column */}
        <div className="min-w-0 space-y-5">
          <PageHeader
            title={`Hello, ${context.profile.displayName.split(" ")[0]}`}
            description="Everything from the communities you have joined, newest first."
            actions={
              joinedAny ? (
                <Button asChild size="sm" className="hidden sm:inline-flex">
                  <Link href="/compose">
                    <PenLine /> Confess
                  </Link>
                </Button>
              ) : null
            }
          />

          {joinedAny ? (
            <Composer
              channels={composerChannels}
              defaultChannelId={composerChannels[0]!.id}
              currentUser={{
                displayName: context.profile.displayName,
                username: context.profile.username,
                avatarUrl: context.profile.avatarUrl,
              }}
            />
          ) : (
            <EmptyState
              icon={Layers}
              title="You have not joined a community yet"
              description="Join your campus community to see its posts here and to publish your first confession."
              action={
                <Button asChild>
                  <Link href="/explore">
                    <Compass /> Find my campus
                  </Link>
                </Button>
              }
            />
          )}

          {joinedAny ? (
            <FeedView
              query={{ sort: "following", channelId: undefined }}
              initialPosts={firstPage}
              initialHasMore={firstPage.length === FEED_PAGE_SIZE}
              mentions={mentionMaps.flat}
              emptyTitle="Your communities are quiet right now"
              emptyDescription="No posts in the communities you have joined yet. Be the first to write something."
            />
          ) : null}
        </div>

        {/* -------------------------------------------------------------- sidebar */}
        <aside className="hidden space-y-4 lg:block">
          {highlights.length > 0 ? (
            <section className="surface p-4">
              <h2 className="flex items-center gap-1.5 text-[0.8125rem] font-semibold">
                <Sparkles className="size-3.5 text-accent" aria-hidden />
                Highlights this week
              </h2>
              <ul className="mt-3 space-y-3">
                {highlights.map((post) => (
                  <li key={post.id} className="border-b border-border pb-3 last:border-0 last:pb-0">
                    <Link href={`/p/${post.id}`} className="line-clamp-2 text-[0.8125rem] leading-snug hover:text-accent">
                      {post.body}
                    </Link>
                    <p className="mt-1 text-xs text-muted-foreground">
                      {compactNumber(post.like_count)} likes · {compactNumber(post.comment_count)} comments
                    </p>
                  </li>
                ))}
              </ul>
            </section>
          ) : null}

          {topics.length > 0 ? (
            <section className="surface p-4">
              <h2 className="flex items-center gap-1.5 text-[0.8125rem] font-semibold">
                <Flame className="size-3.5 text-accent" aria-hidden />
                Trending topics
              </h2>
              <div className="mt-3 flex flex-wrap gap-1.5">
                {topics.map((topic) => (
                  <Link key={topic.topic} href={`/search?q=${encodeURIComponent(topic.topic)}&scope=posts`}>
                    <Badge variant="outline" className="hover:border-border-strong">
                      {topic.topic}
                      <span className="text-muted-foreground">{topic.post_count}</span>
                    </Badge>
                  </Link>
                ))}
              </div>
            </section>
          ) : null}

          {recommended.length > 0 ? (
            <section className="surface p-4">
              <h2 className="text-[0.8125rem] font-semibold">Communities you might like</h2>
              <ul className="mt-3 space-y-3">
                {recommended.map((channel) => (
                  <li key={channel.channel_id}>
                    <Link href={`/channels/${channel.channel_slug}`} className="block hover:text-accent">
                      <span className="block truncate text-[0.8125rem] font-medium">{channel.university_name}</span>
                      <span className="block text-xs text-muted-foreground">
                        {channel.campus_name} · {compactNumber(channel.member_count)} members
                      </span>
                    </Link>
                  </li>
                ))}
              </ul>
              <Button asChild variant="ghost" size="sm" className="mt-3 w-full">
                <Link href="/explore">Browse all communities</Link>
              </Button>
            </section>
          ) : null}
        </aside>
      </div>
    </div>
  );
}
