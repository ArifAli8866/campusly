import type { Metadata } from "next";
import Link from "next/link";
import {
  Building2,
  Hash,
  Search as SearchIcon,
  Sparkles,
} from "lucide-react";

import { BRAND } from "@/components/brand";
import { PostCard } from "@/components/content/post-card";
import { Avatar, Card, EmptyState } from "@/components/ui/primitives";
import { Button } from "@/components/ui/button";
import { compactNumber } from "@/lib/utils";
import { getMentionMaps, getTrendingTopics, runSearch, viewerScope } from "@/server/services/queries";
import type { PostView } from "@/lib/db/types";

export const metadata: Metadata = {
  title: `Search — ${BRAND.name}`,
  description: "Search confessions, discussions, universities, campuses, and students across Pakistan.",
};

export const dynamic = "force-dynamic";

export default async function SearchPage({
  searchParams,
}: {
  searchParams: Promise<{ q?: string; scope?: "all" | "posts" | "universities" | "campuses" | "users" }>;
}) {
  const params = await searchParams;
  const viewer = await viewerScope();

  const query = (params.q || "").trim();
  const activeScope = params.scope || "all";

  const [results, trending] = await Promise.all([
    query ? runSearch(viewer, query, activeScope, 20) : null,
    getTrendingTopics(viewer, { limit: 8, days: 30 }),
  ]);

  // If there are post results, fetch their mention maps
  const postIds = results?.posts?.map((p) => p.id) ?? [];
  const mentionMaps = postIds.length > 0 ? await getMentionMaps(viewer, { postIds }) : { flat: {} };

  const hasAnyResults = Boolean(
    results &&
      (results.posts.length > 0 ||
        results.universities.length > 0 ||
        results.campuses.length > 0 ||
        results.users.length > 0),
  );

  return (
    <div className="mx-auto w-full max-w-5xl px-4 py-8 sm:py-12">
      {/* Header */}
      <div className="mx-auto max-w-2xl text-center">
        <h1 className="text-2xl sm:text-3xl font-bold tracking-tight text-foreground">
          Search {BRAND.name}
        </h1>
        <p className="mt-2 text-sm text-muted-foreground">
          Find confessions, discussion topics, universities, campuses, and fellow students.
        </p>

        {/* Big Search Input */}
        <form action="/search" method="GET" className="mt-6 flex items-center gap-2">
          <div className="relative flex-1">
            <SearchIcon className="pointer-events-none absolute left-4 top-1/2 size-4 -translate-y-1/2 text-muted-foreground" />
            <input
              type="search"
              name="q"
              defaultValue={query}
              placeholder="Search posts, #topics, universities, campuses or students…"
              autoFocus
              className="h-12 w-full rounded-full border border-border bg-card pl-11 pr-4 text-sm shadow-xs transition-colors placeholder:text-muted-foreground focus:border-ring focus:outline-none focus:ring-2 focus:ring-ring"
            />
            {activeScope !== "all" ? <input type="hidden" name="scope" value={activeScope} /> : null}
          </div>
          <Button type="submit" size="lg">
            Search
          </Button>
        </form>
      </div>

      {/* Scope Filter Tabs */}
      {query ? (
        <div className="mt-8 flex items-center justify-center gap-1.5 overflow-x-auto no-scrollbar border-b border-border/70 pb-3">
          {[
            { id: "all", label: "All Results" },
            { id: "posts", label: "Confessions & Posts" },
            { id: "universities", label: "Universities" },
            { id: "campuses", label: "Campuses" },
            { id: "users", label: "Students" },
          ].map((tab) => {
            const isSelected = activeScope === tab.id;
            return (
              <Link
                key={tab.id}
                href={`/search?q=${encodeURIComponent(query)}&scope=${tab.id}`}
                className={`rounded-full px-3.5 py-1.5 text-xs font-medium transition-all ${
                  isSelected
                    ? "bg-primary text-primary-foreground shadow-2xs"
                    : "border border-border/80 bg-card text-muted-foreground hover:bg-muted hover:text-foreground"
                }`}
              >
                {tab.label}
              </Link>
            );
          })}
        </div>
      ) : null}

      {/* Results Content */}
      <div className="mt-8">
        {!query ? (
          /* Initial Empty State with Trending */
          <div className="space-y-8">
            <Card className="p-6 text-center">
              <h2 className="text-sm font-semibold text-foreground">Popular Topics Across Campuses</h2>
              <p className="mt-1 text-xs text-muted-foreground">
                Click any topic below to jump into recent discussions.
              </p>
              <div className="mt-4 flex flex-wrap justify-center gap-2">
                {trending.map((t) => (
                  <Link
                    key={t.topic}
                    href={`/search?q=%23${t.topic}&scope=posts`}
                    className="flex items-center gap-1 rounded-full border border-border/80 bg-card px-3 py-1.5 text-xs font-medium text-foreground transition-colors hover:border-accent hover:text-accent"
                  >
                    <Hash className="size-3 text-accent" />
                    <span>#{t.topic}</span>
                    <span className="text-[0.6875rem] text-muted-foreground tabular-nums">
                      ({compactNumber(t.post_count)})
                    </span>
                  </Link>
                ))}
              </div>
            </Card>

            <div className="grid gap-4 sm:grid-cols-2">
              <Card className="p-5">
                <div className="flex items-center gap-2.5">
                  <div className="flex size-9 items-center justify-center rounded-xl bg-accent-subtle text-accent">
                    <Building2 className="size-4" />
                  </div>
                  <div>
                    <h3 className="text-sm font-semibold text-foreground">Explore Universities</h3>
                    <p className="text-xs text-muted-foreground">Browse all 200+ Pakistani institutions</p>
                  </div>
                </div>
                <Button asChild variant="outline" size="sm" className="mt-4 w-full">
                  <Link href="/universities">Open Directory →</Link>
                </Button>
              </Card>

              <Card className="p-5">
                <div className="flex items-center gap-2.5">
                  <div className="flex size-9 items-center justify-center rounded-xl bg-accent-subtle text-accent">
                    <Sparkles className="size-4" />
                  </div>
                  <div>
                    <h3 className="text-sm font-semibold text-foreground">Trending Confessions</h3>
                    <p className="text-xs text-muted-foreground">Check out the most viral stories this week</p>
                  </div>
                </div>
                <Button asChild variant="outline" size="sm" className="mt-4 w-full">
                  <Link href="/explore">Explore Feeds →</Link>
                </Button>
              </Card>
            </div>
          </div>
        ) : !hasAnyResults ? (
          /* No Results Found */
          <Card className="p-10 text-center">
            <EmptyState
              icon={SearchIcon}
              title="No results found"
              description={`We couldn't find anything matching "${query}". Try searching with different keywords or checking for spelling.`}
              action={
                <Button asChild variant="outline">
                  <Link href="/search">Clear search</Link>
                </Button>
              }
            />
          </Card>
        ) : (
          /* Search Results */
          <div className="space-y-8">
            {/* Universities */}
            {results && results.universities.length > 0 ? (
              <section>
                <h2 className="mb-3 text-sm font-semibold uppercase tracking-wider text-muted-foreground">
                  Universities ({results.universities.length})
                </h2>
                <div className="grid gap-3 sm:grid-cols-2 lg:grid-cols-3">
                  {results.universities.map((uni) => (
                    <Card key={uni.id} className="p-4 hover:border-border-strong">
                      <div className="flex items-center gap-3">
                        <div className="flex size-11 shrink-0 items-center justify-center rounded-xl bg-muted text-xs font-bold text-foreground">
                          {uni.abbreviation || uni.name.slice(0, 3).toUpperCase()}
                        </div>
                        <div className="min-w-0">
                          <h3 className="truncate font-semibold text-foreground text-sm">
                            <Link href={`/universities/${uni.slug}`} className="hover:underline">
                              {uni.name}
                            </Link>
                          </h3>
                          <p className="truncate text-xs text-muted-foreground">
                            {uni.city ? `${uni.city} · ` : ""}{uni.campus_count} campuses
                          </p>
                        </div>
                      </div>
                    </Card>
                  ))}
                </div>
              </section>
            ) : null}

            {/* Campuses */}
            {results && results.campuses.length > 0 ? (
              <section>
                <h2 className="mb-3 text-sm font-semibold uppercase tracking-wider text-muted-foreground">
                  Campuses ({results.campuses.length})
                </h2>
                <div className="grid gap-3 sm:grid-cols-2 lg:grid-cols-3">
                  {results.campuses.map((campus) => (
                    <Card key={campus.id} className="p-4 hover:border-border-strong">
                      <h3 className="font-semibold text-foreground text-sm">
                        <Link href={`/channels/${campus.channel_slug || campus.slug}`} className="hover:underline">
                          {campus.name}
                        </Link>
                      </h3>
                      <p className="mt-0.5 text-xs text-accent font-medium">
                        {campus.university_abbreviation ?? campus.university_name}
                      </p>
                      <div className="mt-2 flex items-center justify-between text-xs text-muted-foreground">
                        <span>{campus.city || "Pakistan"}</span>
                        <span>{compactNumber(campus.member_count)} members</span>
                      </div>
                    </Card>
                  ))}
                </div>
              </section>
            ) : null}

            {/* Students */}
            {results && results.users.length > 0 ? (
              <section>
                <h2 className="mb-3 text-sm font-semibold uppercase tracking-wider text-muted-foreground">
                  Students ({results.users.length})
                </h2>
                <div className="grid gap-3 sm:grid-cols-2 lg:grid-cols-3">
                  {results.users.map((u) => (
                    <Card key={u.id} className="p-4">
                      <div className="flex items-center gap-3">
                        <Avatar src={u.avatar_url} name={u.display_name} size="md" />
                        <div className="min-w-0 flex-1">
                          <Link href={`/u/${u.username}`} className="block truncate font-semibold text-sm hover:underline">
                            {u.display_name}
                          </Link>
                          <p className="truncate text-xs text-muted-foreground">@{u.username}</p>
                          {u.university_name ? (
                            <p className="truncate text-[0.6875rem] text-accent mt-0.5 font-medium">
                              {u.university_abbreviation ?? u.university_name}
                            </p>
                          ) : null}
                        </div>
                      </div>
                    </Card>
                  ))}
                </div>
              </section>
            ) : null}

            {/* Posts / Confessions */}
            {results && results.posts.length > 0 ? (
              <section>
                <h2 className="mb-3 text-sm font-semibold uppercase tracking-wider text-muted-foreground">
                  Confessions & Discussions ({results.posts.length})
                </h2>
                <div className="space-y-4">
                  {results.posts.map((post) => (
                    <PostCard
                      key={post.id}
                      post={post as unknown as PostView}
                      mentions={mentionMaps.flat}
                    />
                  ))}
                </div>
              </section>
            ) : null}
          </div>
        )}
      </div>
    </div>
  );
}
