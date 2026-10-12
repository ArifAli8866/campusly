import type { Metadata } from "next";
import Link from "next/link";
import { Compass, Flame, Hash, Sparkles, TrendingUp, Users } from "lucide-react";

import { BRAND } from "@/components/brand";
import { FeedView } from "@/components/content/feed-view";
import { JoinButton } from "@/components/content/join-button";
import { Badge, Card } from "@/components/ui/primitives";
import { Button } from "@/components/ui/button";
import { FEED_PAGE_SIZE, POST_CATEGORIES } from "@/lib/constants";
import { compactNumber } from "@/lib/utils";
import { getCurrentContext } from "@/server/auth/context";
import {
  getFeed,
  getMentionMaps,
  getRecommendedChannels,
  getTrendingTopics,
  getWeeklyHighlights,
  viewerScope,
} from "@/server/services/queries";

export const metadata: Metadata = {
  title: `Explore — ${BRAND.name}`,
  description: "Explore trending campus confessions and active university communities across Pakistan.",
};

export const dynamic = "force-dynamic";

export default async function ExplorePage({
  searchParams,
}: {
  searchParams: Promise<{ sort?: "trending" | "most_liked" | "latest"; category?: string }>;
}) {
  const params = await searchParams;
  const scope = await viewerScope();
  const context = await getCurrentContext();

  const activeSort = params.sort || "trending";
  const activeCategory = params.category || undefined;

  const [posts, trending, recommended, highlights] = await Promise.all([
    getFeed(scope, {
      sort: activeSort,
      category: activeCategory,
      limit: FEED_PAGE_SIZE,
    }),
    getTrendingTopics(scope, { limit: 8, days: 30 }),
    scope.userId ? getRecommendedChannels(scope, 5) : [],
    getWeeklyHighlights(scope, 3),
  ]);

  const mentionMaps = await getMentionMaps(scope, { postIds: posts.map((p) => p.id) });

  return (
    <div className="mx-auto w-full max-w-6xl px-4 py-6 sm:py-8">
      {/* Page Header */}
      <div className="mb-6">
        <Badge variant="outline" size="sm" className="mb-2 shadow-2xs gap-1.5">
          <TrendingUp className="size-3 text-accent" />
          <span>Across All Campuses</span>
        </Badge>
        <h1 className="text-2xl sm:text-3xl font-bold tracking-tight text-foreground">
          Explore Discussions
        </h1>
        <p className="mt-1 text-sm text-muted-foreground">
          Discover what students across Pakistan are talking about right now.
        </p>
      </div>

      {/* Main Grid: Feed + Right Sidebar */}
      <div className="grid gap-8 lg:grid-cols-[minmax(0,1fr)_20rem]">
        {/* Main Column */}
        <div className="min-w-0 space-y-6">
          {/* Filter Pills */}
          <div className="flex flex-wrap items-center justify-between gap-3 border-b border-border/70 pb-3">
            {/* Sort options */}
            <div className="flex items-center rounded-full border border-border/80 bg-card p-0.5 shadow-2xs text-xs">
              <Link
                href={`/explore?${new URLSearchParams({
                  ...(activeCategory ? { category: activeCategory } : {}),
                  sort: "trending",
                }).toString()}`}
                className={`flex items-center gap-1 rounded-full px-3 py-1 font-medium transition-all ${
                  activeSort === "trending"
                    ? "bg-primary text-primary-foreground"
                    : "text-muted-foreground hover:text-foreground"
                }`}
              >
                <Flame className="size-3" />
                Trending
              </Link>
              <Link
                href={`/explore?${new URLSearchParams({
                  ...(activeCategory ? { category: activeCategory } : {}),
                  sort: "most_liked",
                }).toString()}`}
                className={`flex items-center gap-1 rounded-full px-3 py-1 font-medium transition-all ${
                  activeSort === "most_liked"
                    ? "bg-primary text-primary-foreground"
                    : "text-muted-foreground hover:text-foreground"
                }`}
              >
                Top Liked
              </Link>
              <Link
                href={`/explore?${new URLSearchParams({
                  ...(activeCategory ? { category: activeCategory } : {}),
                  sort: "latest",
                }).toString()}`}
                className={`flex items-center gap-1 rounded-full px-3 py-1 font-medium transition-all ${
                  activeSort === "latest"
                    ? "bg-primary text-primary-foreground"
                    : "text-muted-foreground hover:text-foreground"
                }`}
              >
                Latest
              </Link>
            </div>

            {/* Category tabs */}
            <div className="flex flex-wrap items-center gap-1 overflow-x-auto no-scrollbar py-0.5">
              <Link
                href={`/explore?sort=${activeSort}`}
                className={`rounded-full px-2.5 py-1 text-xs font-medium transition-all ${
                  !activeCategory
                    ? "bg-muted text-foreground font-semibold"
                    : "text-muted-foreground hover:text-foreground"
                }`}
              >
                All
              </Link>
              {POST_CATEGORIES.map((cat) => (
                <Link
                  key={cat.value}
                  href={`/explore?sort=${activeSort}&category=${cat.value}`}
                  className={`rounded-full px-2.5 py-1 text-xs font-medium transition-all ${
                    activeCategory === cat.value
                      ? "bg-muted text-foreground font-semibold"
                      : "text-muted-foreground hover:text-foreground"
                  }`}
                >
                  {cat.label}
                </Link>
              ))}
            </div>
          </div>

          {/* Feed */}
          <FeedView
            query={{ sort: activeSort, category: activeCategory }}
            initialPosts={posts}
            initialHasMore={posts.length === FEED_PAGE_SIZE}
            mentions={mentionMaps.flat}
            emptyTitle="Quiet across campuses right now"
            emptyDescription="No confessions match this filter. Be the first to share something."
          />
        </div>

        {/* Sidebar */}
        <aside className="space-y-5">
          {/* Trending hashtags */}
          {trending.length > 0 ? (
            <Card className="p-4">
              <h2 className="flex items-center gap-1.5 text-xs font-semibold uppercase tracking-wider text-muted-foreground">
                <Hash className="size-4 text-accent" />
                Trending Topics
              </h2>
              <ul className="mt-3 space-y-2.5">
                {trending.map((t) => (
                  <li key={t.topic} className="flex items-center justify-between text-xs">
                    <Link
                      href={`/search?q=%23${t.topic}&scope=posts`}
                      className="font-medium text-accent hover:underline"
                    >
                      #{t.topic}
                    </Link>
                    <span className="text-muted-foreground tabular-nums">
                      {compactNumber(t.post_count)} posts
                    </span>
                  </li>
                ))}
              </ul>
            </Card>
          ) : null}

          {/* Recommended Communities */}
          {recommended.length > 0 ? (
            <Card className="p-4">
              <h2 className="flex items-center gap-1.5 text-xs font-semibold uppercase tracking-wider text-muted-foreground">
                <Users className="size-4 text-accent" />
                Recommended For You
              </h2>
              <ul className="mt-3 space-y-3">
                {recommended.map((channel) => (
                  <li key={channel.channel_id} className="flex items-center justify-between gap-2">
                    <div className="min-w-0">
                      <Link
                        href={`/channels/${channel.channel_slug}`}
                        className="block truncate text-xs font-semibold hover:underline"
                      >
                        {channel.campus_name}
                      </Link>
                      <p className="truncate text-[0.6875rem] text-muted-foreground">
                        {channel.university_abbreviation ?? channel.university_name}
                      </p>
                    </div>
                    <JoinButton
                      channelId={channel.channel_id}
                      channelSlug={channel.channel_slug}
                      isMember={false}
                      signedIn={Boolean(context)}
                      size="sm"
                    />
                  </li>
                ))}
              </ul>
            </Card>
          ) : null}

          {/* Highlights this week */}
          {highlights.length > 0 ? (
            <Card className="p-4">
              <h2 className="flex items-center gap-1.5 text-xs font-semibold uppercase tracking-wider text-muted-foreground">
                <Sparkles className="size-4 text-accent" />
                Weekly Highlights
              </h2>
              <ul className="mt-3 space-y-3">
                {highlights.map((post) => (
                  <li key={post.id} className="border-b border-border/50 pb-2.5 last:border-0 last:pb-0">
                    <Link href={`/p/${post.id}`} className="group block">
                      <p className="line-clamp-2 text-xs text-foreground group-hover:text-accent">
                        {post.body}
                      </p>
                      <span className="mt-1 block text-[0.6875rem] text-muted-foreground">
                        {compactNumber(post.like_count)} likes · {compactNumber(post.comment_count)} comments
                      </span>
                    </Link>
                  </li>
                ))}
              </ul>
            </Card>
          ) : null}

          {/* Universities directory link card */}
          <Card className="p-4 bg-muted/40 text-center">
            <h3 className="text-xs font-semibold text-foreground">Looking for your university?</h3>
            <p className="mt-1 text-xs text-muted-foreground">
              Browse the complete list of 200+ Pakistani institutions.
            </p>
            <Button asChild size="sm" variant="outline" className="mt-3 w-full">
              <Link href="/universities">
                <Compass className="size-3.5" /> Browse Universities
              </Link>
            </Button>
          </Card>
        </aside>
      </div>
    </div>
  );
}
