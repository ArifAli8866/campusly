import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";
import {
  ArrowLeft,
  Building2,
  Flame,
  Hash,
  MapPin,
  MessageSquare,
  ShieldCheck,
  Users,
} from "lucide-react";

import { BRAND } from "@/components/brand";
import { Composer } from "@/components/content/composer";
import { FeedView } from "@/components/content/feed-view";
import { JoinButton } from "@/components/content/join-button";
import { Badge, Card } from "@/components/ui/primitives";
import { Button } from "@/components/ui/button";
import { FEED_PAGE_SIZE, POST_CATEGORIES } from "@/lib/constants";
import { compactNumber } from "@/lib/utils";
import { getCurrentContext } from "@/server/auth/context";
import {
  getChannelOverview,
  getFeed,
  getMentionMaps,
  getTrendingTopics,
  viewerScope,
} from "@/server/services/queries";

export const dynamic = "force-dynamic";

export async function generateMetadata({
  params,
}: {
  params: Promise<{ slug: string }>;
}): Promise<Metadata> {
  const { slug } = await params;
  const scope = await viewerScope();
  const channel = await getChannelOverview(scope, slug);

  if (!channel) {
    return { title: `Community Not Found — ${BRAND.name}` };
  }

  const title = `${channel.university_abbreviation ?? channel.university_name} · ${channel.campus_name} — ${BRAND.name}`;
  return {
    title,
    description: `Join the official campus confessions and community forum for ${channel.university_name} (${channel.campus_name}).`,
  };
}

export default async function ChannelPage({
  params,
  searchParams,
}: {
  params: Promise<{ slug: string }>;
  searchParams: Promise<{ category?: string; sort?: "latest" | "trending" | "most_liked" }>;
}) {
  const { slug } = await params;
  const filterParams = await searchParams;
  const scope = await viewerScope();
  const context = await getCurrentContext();

  const channel = await getChannelOverview(scope, slug);
  if (!channel) {
    notFound();
  }

  const activeCategory = filterParams.category || undefined;
  const activeSort = filterParams.sort || "latest";

  const [posts, trending] = await Promise.all([
    getFeed(scope, {
      channelId: channel.id,
      category: activeCategory,
      sort: activeSort,
      limit: FEED_PAGE_SIZE,
    }),
    getTrendingTopics(scope, { channelId: channel.id, limit: 6 }),
  ]);

  const mentionMaps = await getMentionMaps(scope, { postIds: posts.map((p) => p.id) });

  const monogram = (channel.university_abbreviation ?? channel.university_name)
    .replace(/[^A-Za-z]/g, "")
    .slice(0, 3)
    .toUpperCase();

  const composerChannels = [
    {
      id: channel.id,
      slug: channel.slug,
      name: channel.university_abbreviation ?? channel.university_name,
      label: `${channel.university_abbreviation ?? channel.university_name} · ${channel.campus_name.replace(/ Campus$/, "")}`,
    },
  ];

  return (
    <div className="mx-auto w-full max-w-6xl px-4 py-6 sm:py-8">
      {/* Back button */}
      <Button asChild variant="ghost" size="sm" className="mb-4 -ml-2">
        <Link href={`/universities/${channel.university_slug}`}>
          <ArrowLeft className="size-4" />
          {channel.university_name}
        </Link>
      </Button>

      {/* Community Banner */}
      <div className="surface overflow-hidden">
        <div className="relative h-36 sm:h-48 w-full bg-ink-950">
          {channel.banner_url || channel.university_banner_url ? (
            // eslint-disable-next-line @next/next/no-img-element
            <img
              src={channel.banner_url || channel.university_banner_url || ""}
              alt=""
              className="size-full object-cover"
            />
          ) : (
            <div className="grid-canvas absolute inset-0 opacity-25" />
          )}
          <div className="absolute inset-0 bg-gradient-to-t from-ink-950/85 via-ink-950/25 to-transparent" />
        </div>

        <div className="p-5 sm:p-6">
          <div className="-mt-14 sm:-mt-16 mb-4 flex flex-wrap items-end justify-between gap-3">
            <div className="flex size-18 sm:size-20 items-center justify-center overflow-hidden rounded-2xl border-4 border-card bg-card shadow-[var(--shadow-lift)]">
              {channel.university_logo_url ? (
                // eslint-disable-next-line @next/next/no-img-element
                <img
                  src={channel.university_logo_url}
                  alt={`${channel.university_name} logo`}
                  className="size-full object-contain p-1.5"
                />
              ) : (
                <span className="flex size-full items-center justify-center bg-muted text-lg font-bold text-foreground">
                  {monogram}
                </span>
              )}
            </div>

            <JoinButton
              channelId={channel.id}
              channelSlug={channel.slug}
              isMember={channel.is_member}
              signedIn={Boolean(context)}
              size="md"
            />
          </div>

          <div className="flex flex-wrap items-baseline gap-2">
            <h1 className="text-xl sm:text-2xl font-bold tracking-tight text-foreground">
              {channel.campus_name}
            </h1>
            <span className="text-base font-semibold text-accent">
              {channel.university_abbreviation ?? channel.university_name}
            </span>
          </div>

          <div className="mt-2 flex flex-wrap items-center gap-3 text-xs text-muted-foreground">
            {channel.campus_city ? (
              <span className="flex items-center gap-1">
                <MapPin className="size-3.5" /> {channel.campus_city}
                {channel.campus_province ? `, ${channel.campus_province}` : ""}
              </span>
            ) : null}
            <span className="flex items-center gap-1">
              <Users className="size-3.5" /> {compactNumber(channel.member_count)} members
            </span>
            <span className="flex items-center gap-1">
              <MessageSquare className="size-3.5" /> {compactNumber(channel.post_count)} confessions
            </span>
            {channel.today_post_count > 0 ? (
              <Badge variant="subtle" size="sm">
                <Flame className="size-3 text-orange-500" />
                {compactNumber(channel.today_post_count)} active today
              </Badge>
            ) : null}
          </div>

          {channel.description ? (
            <p className="mt-3 text-sm text-muted-foreground">{channel.description}</p>
          ) : null}
        </div>
      </div>

      {/* Main Grid: Feed + Right Sidebar */}
      <div className="mt-8 grid gap-8 lg:grid-cols-[minmax(0,1fr)_20rem]">
        {/* Main Column */}
        <div className="min-w-0 space-y-6">
          {/* In-Channel Composer (if signed in & member) */}
          {context && channel.is_member ? (
            <Composer
              channels={composerChannels}
              defaultChannelId={channel.id}
              currentUser={{
                displayName: context.profile.displayName,
                username: context.profile.username,
                avatarUrl: context.profile.avatarUrl,
              }}
            />
          ) : !context ? (
            <Card className="p-4 bg-accent-subtle/50 border-accent/20">
              <div className="flex items-center justify-between gap-4">
                <p className="text-xs sm:text-sm text-foreground">
                  Sign in to join the <span className="font-semibold">{channel.campus_name}</span> community and post confessions.
                </p>
                <Button asChild size="sm">
                  <Link href={`/login?next=/channels/${channel.slug}`}>Sign in</Link>
                </Button>
              </div>
            </Card>
          ) : null}

          {/* Filters & Tabs */}
          <div className="flex flex-wrap items-center justify-between gap-3 border-b border-border/70 pb-3">
            {/* Category pills */}
            <div className="flex flex-wrap items-center gap-1.5 overflow-x-auto no-scrollbar py-1">
              <Link
                href={`/channels/${channel.slug}?${new URLSearchParams({
                  sort: activeSort,
                }).toString()}`}
                className={`rounded-full px-3 py-1 text-xs font-medium transition-all ${
                  !activeCategory
                    ? "bg-primary text-primary-foreground shadow-2xs"
                    : "border border-border/80 bg-card text-muted-foreground hover:bg-muted hover:text-foreground"
                }`}
              >
                All
              </Link>
              {POST_CATEGORIES.map((cat) => {
                const isSelected = activeCategory === cat.value;
                return (
                  <Link
                    key={cat.value}
                    href={`/channels/${channel.slug}?${new URLSearchParams({
                      category: cat.value,
                      sort: activeSort,
                    }).toString()}`}
                    className={`rounded-full px-3 py-1 text-xs font-medium transition-all ${
                      isSelected
                        ? "bg-primary text-primary-foreground shadow-2xs"
                        : "border border-border/80 bg-card text-muted-foreground hover:bg-muted hover:text-foreground"
                    }`}
                  >
                    {cat.label}
                  </Link>
                );
              })}
            </div>

            {/* Sort toggles */}
            <div className="flex items-center rounded-full border border-border/80 bg-card p-0.5 shadow-2xs text-xs">
              <Link
                href={`/channels/${channel.slug}?${new URLSearchParams({
                  ...(activeCategory ? { category: activeCategory } : {}),
                  sort: "latest",
                }).toString()}`}
                className={`rounded-full px-2.5 py-1 font-medium transition-all ${
                  activeSort === "latest"
                    ? "bg-primary text-primary-foreground"
                    : "text-muted-foreground hover:text-foreground"
                }`}
              >
                Latest
              </Link>
              <Link
                href={`/channels/${channel.slug}?${new URLSearchParams({
                  ...(activeCategory ? { category: activeCategory } : {}),
                  sort: "trending",
                }).toString()}`}
                className={`rounded-full px-2.5 py-1 font-medium transition-all ${
                  activeSort === "trending"
                    ? "bg-primary text-primary-foreground"
                    : "text-muted-foreground hover:text-foreground"
                }`}
              >
                Trending
              </Link>
              <Link
                href={`/channels/${channel.slug}?${new URLSearchParams({
                  ...(activeCategory ? { category: activeCategory } : {}),
                  sort: "most_liked",
                }).toString()}`}
                className={`rounded-full px-2.5 py-1 font-medium transition-all ${
                  activeSort === "most_liked"
                    ? "bg-primary text-primary-foreground"
                    : "text-muted-foreground hover:text-foreground"
                }`}
              >
                Top
              </Link>
            </div>
          </div>

          {/* Feed View */}
          <FeedView
            query={{ channelId: channel.id, category: activeCategory, sort: activeSort }}
            initialPosts={posts}
            initialHasMore={posts.length === FEED_PAGE_SIZE}
            mentions={mentionMaps.flat}
            emptyTitle="No confessions in this community yet"
            emptyDescription="Be the first to share an anonymous story, ask an academic question, or start a discussion."
          />
        </div>

        {/* Right Sidebar */}
        <aside className="space-y-5">
          {/* Community Guidelines */}
          <Card className="p-4">
            <h2 className="flex items-center gap-1.5 text-xs font-semibold uppercase tracking-wider text-muted-foreground">
              <ShieldCheck className="size-4 text-success" />
              Community Guidelines
            </h2>
            <ul className="mt-3 space-y-2 text-xs text-muted-foreground">
              <li className="flex items-start gap-1.5">
                <span className="font-semibold text-foreground">•</span>
                <span>Respect all classmates and faculty members.</span>
              </li>
              <li className="flex items-start gap-1.5">
                <span className="font-semibold text-foreground">•</span>
                <span>Zero tolerance for doxxing, phone numbers, or harassment.</span>
              </li>
              <li className="flex items-start gap-1.5">
                <span className="font-semibold text-foreground">•</span>
                <span>Anonymous posts are scrubbed of author data before delivery.</span>
              </li>
            </ul>
          </Card>

          {/* Trending in channel */}
          {trending.length > 0 ? (
            <Card className="p-4">
              <h2 className="flex items-center gap-1.5 text-xs font-semibold uppercase tracking-wider text-muted-foreground">
                <Hash className="size-4 text-accent" />
                Trending on this campus
              </h2>
              <ul className="mt-3 space-y-2">
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

          {/* Other campuses */}
          {channel.other_campuses && channel.other_campuses.length > 0 ? (
            <Card className="p-4">
              <h2 className="flex items-center gap-1.5 text-xs font-semibold uppercase tracking-wider text-muted-foreground">
                <Building2 className="size-4 text-accent" />
                Other Campuses
              </h2>
              <ul className="mt-3 space-y-2">
                {channel.other_campuses.map((c) => (
                  <li key={c.id}>
                    <Link
                      href={`/channels/${c.slug}`}
                      className="flex items-center justify-between rounded-lg p-1.5 text-xs transition-colors hover:bg-muted"
                    >
                      <span className="font-medium text-foreground">{c.campus_name}</span>
                      {c.member_count > 0 ? (
                        <span className="text-muted-foreground tabular-nums">
                          {compactNumber(c.member_count)}
                        </span>
                      ) : null}
                    </Link>
                  </li>
                ))}
              </ul>
            </Card>
          ) : null}
        </aside>
      </div>
    </div>
  );
}
