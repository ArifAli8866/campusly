import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";
import { ArrowLeft, Building2, MapPin, MessageSquare, Users } from "lucide-react";

import { BRAND } from "@/components/brand";
import { FeedView } from "@/components/content/feed-view";
import { JoinButton } from "@/components/content/join-button";
import { Badge, Card, EmptyState } from "@/components/ui/primitives";
import { Button } from "@/components/ui/button";
import { compactNumber, pluralize } from "@/lib/utils";
import { getSessionUser } from "@/server/auth/session";
import { getFeed, getMentionMaps, getUniversityCards, viewerScope } from "@/server/services/queries";

export const dynamic = "force-dynamic";

export async function generateMetadata({
  params,
}: {
  params: Promise<{ slug: string }>;
}): Promise<Metadata> {
  const { slug } = await params;
  const scope = await viewerScope();
  const unis = await getUniversityCards(scope, { query: slug, limit: 1 });
  const uni = unis.find((u) => u.slug === slug) ?? unis[0];

  if (!uni) {
    return { title: `University Not Found — ${BRAND.name}` };
  }

  return {
    title: `${uni.name} (${uni.abbreviation || "Campus"}) — ${BRAND.name}`,
    description: uni.description || `Join the student community for ${uni.name} on ${BRAND.name}.`,
  };
}

export default async function UniversityDetailPage({
  params,
}: {
  params: Promise<{ slug: string }>;
}) {
  const { slug } = await params;
  const scope = await viewerScope();
  const session = await getSessionUser();

  const unis = await getUniversityCards(scope, { query: slug, limit: 5 });
  const uni = unis.find((u) => u.slug === slug || u.abbreviation?.toLowerCase() === slug.toLowerCase()) ?? unis[0];

  if (!uni) {
    notFound();
  }

  // Get first page of posts for this university
  const posts = await getFeed(scope, { search: uni.name, limit: 10 });
  const mentionMaps = await getMentionMaps(scope, { postIds: posts.map((p) => p.id) });

  const monogram = (uni.abbreviation ?? uni.name)
    .replace(/[^A-Za-z]/g, "")
    .slice(0, 3)
    .toUpperCase();

  return (
    <div className="mx-auto w-full max-w-5xl px-4 py-6 sm:py-10">
      {/* Back button */}
      <Button asChild variant="ghost" size="sm" className="mb-6 -ml-2">
        <Link href="/universities">
          <ArrowLeft className="size-4" />
          Back to all universities
        </Link>
      </Button>

      {/* University Hero Card */}
      <div className="surface overflow-hidden">
        {/* Banner */}
        <div className="relative h-44 sm:h-56 w-full bg-ink-950">
          {uni.banner_url ? (
            // eslint-disable-next-line @next/next/no-img-element
            <img src={uni.banner_url} alt="" className="size-full object-cover" />
          ) : (
            <div className="grid-canvas absolute inset-0 opacity-25" />
          )}
          <div className="absolute inset-0 bg-gradient-to-t from-ink-950/80 via-ink-950/20 to-transparent" />
        </div>

        {/* Info header */}
        <div className="p-6 sm:p-8">
          <div className="-mt-16 sm:-mt-20 mb-4 flex flex-wrap items-end justify-between gap-4">
            <div className="flex size-20 sm:size-24 items-center justify-center overflow-hidden rounded-3xl border-4 border-card bg-card shadow-[var(--shadow-lift)]">
              {uni.logo_url ? (
                // eslint-disable-next-line @next/next/no-img-element
                <img src={uni.logo_url} alt={`${uni.name} logo`} className="size-full object-contain p-2" />
              ) : (
                <span className="flex size-full items-center justify-center bg-muted text-xl font-bold text-foreground">
                  {monogram}
                </span>
              )}
            </div>

            {uni.campuses.length === 1 ? (
              <JoinButton
                channelId={uni.campuses[0].id}
                channelSlug={uni.campuses[0].slug}
                isMember={uni.viewer_is_member}
                signedIn={Boolean(session)}
                size="md"
              />
            ) : null}
          </div>

          <div>
            <div className="flex flex-wrap items-center gap-2">
              <h1 className="text-2xl sm:text-3xl font-bold tracking-tight text-foreground">{uni.name}</h1>
              {uni.abbreviation ? (
                <Badge variant="subtle" size="md">
                  {uni.abbreviation}
                </Badge>
              ) : null}
              {uni.is_featured ? (
                <Badge variant="accent" size="md">
                  Featured
                </Badge>
              ) : null}
            </div>

            <div className="mt-2 flex flex-wrap items-center gap-3 text-sm text-muted-foreground">
              {uni.city ? (
                <span className="flex items-center gap-1">
                  <MapPin className="size-4" /> {uni.city}, {uni.province}
                </span>
              ) : null}
              <span className="flex items-center gap-1">
                <Building2 className="size-4" /> {uni.campus_count} {pluralize(uni.campus_count, "campus")}
              </span>
              <span className="flex items-center gap-1">
                <Users className="size-4" /> {compactNumber(uni.member_count)} students
              </span>
              <span className="flex items-center gap-1">
                <MessageSquare className="size-4" /> {compactNumber(uni.post_count)} confessions
              </span>
            </div>

            {uni.description ? (
              <p className="mt-4 max-w-3xl text-sm leading-relaxed text-muted-foreground">{uni.description}</p>
            ) : null}
          </div>
        </div>
      </div>

      {/* Campuses section */}
      <div className="mt-10">
        <div className="mb-4 flex items-center justify-between">
          <div>
            <h2 className="text-xl font-bold tracking-tight">Campuses & Communities</h2>
            <p className="text-xs sm:text-sm text-muted-foreground">
              Each campus has its own private student feed, confessions, and channel discussions.
            </p>
          </div>
        </div>

        <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
          {uni.campuses.map((campus) => (
            <Card key={campus.id} className="flex flex-col p-5 hover:border-border-strong">
              <div className="flex items-start justify-between gap-3">
                <div>
                  <h3 className="font-semibold text-foreground">
                    <Link href={`/channels/${campus.slug}`} className="hover:underline">
                      {campus.name}
                    </Link>
                  </h3>
                  {campus.city ? (
                    <p className="mt-0.5 flex items-center gap-1 text-xs text-muted-foreground">
                      <MapPin className="size-3" /> {campus.city}
                    </p>
                  ) : null}
                </div>
                <Badge variant="outline" size="sm">
                  {compactNumber(campus.member_count)} members
                </Badge>
              </div>

              <div className="mt-auto pt-4">
                <Button asChild size="sm" variant="outline" className="w-full">
                  <Link href={`/channels/${campus.slug}`}>Enter Community →</Link>
                </Button>
              </div>
            </Card>
          ))}
        </div>
      </div>

      {/* Recent Activity Feed */}
      <div className="mt-12">
        <h2 className="text-xl font-bold tracking-tight mb-4">Latest from {uni.abbreviation ?? uni.name}</h2>
        {posts.length > 0 ? (
          <FeedView
            query={{ q: uni.name, sort: "latest" }}
            initialPosts={posts}
            initialHasMore={posts.length === 10}
            mentions={mentionMaps.flat}
          />
        ) : (
          <Card className="p-8 text-center">
            <EmptyState
              icon={MessageSquare}
              title="No confessions yet"
              description={`Be the first to share a confession or story in the ${uni.name} community.`}
              action={
                <Button asChild>
                  <Link href="/compose">Write a Confession</Link>
                </Button>
              }
            />
          </Card>
        )}
      </div>
    </div>
  );
}
