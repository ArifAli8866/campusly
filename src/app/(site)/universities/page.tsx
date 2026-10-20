import type { Metadata } from "next";
import Link from "next/link";
import { Building2, GraduationCap, Search } from "lucide-react";

import { BRAND } from "@/components/brand";
import { UniversityCard } from "@/components/content/university-card";
import { Badge, Card, EmptyState } from "@/components/ui/primitives";
import { Button } from "@/components/ui/button";
import { PROVINCES } from "@/lib/constants";
import { compactNumber } from "@/lib/utils";
import { getSessionUser } from "@/server/auth/session";
import { getCatalogueCounts, getUniversityCards, viewerScope } from "@/server/services/queries";

export const metadata: Metadata = {
  title: `Universities Directory — ${BRAND.name}`,
  description:
    "Explore higher education institutions and campus communities across Pakistan. Connect with classmates, join confessions, and stay informed.",
};

export const dynamic = "force-dynamic";

export default async function UniversitiesPage({
  searchParams,
}: {
  searchParams: Promise<{
    q?: string;
    province?: string;
    type?: string;
    sort?: "name" | "most_joined" | "recently_active" | "campuses";
  }>;
}) {
  const params = await searchParams;
  const scope = await viewerScope();
  const session = await getSessionUser();

  const [universities, catalogue] = await Promise.all([
    getUniversityCards(scope, {
      query: params.q || null,
      province: params.province || null,
      type: params.type || null,
      sort: params.sort || "most_joined",
      limit: 300,
    }),
    getCatalogueCounts(scope),
  ]);

  const activeProvince = params.province || "";
  const activeSort = params.sort || "most_joined";

  return (
    <div className="mx-auto w-full max-w-6xl px-4 py-8 sm:py-12">
      {/* Header */}
      <div className="mx-auto max-w-3xl text-center">
        <Badge variant="outline" size="lg" className="mx-auto shadow-xs border-border/80 bg-card/80 backdrop-blur-sm gap-2">
          <GraduationCap className="size-3.5 text-accent" aria-hidden />
          <span>Higher Education in Pakistan</span>
        </Badge>

        <h1 className="text-display mt-4 text-foreground">
          Find your <span className="text-accent">campus</span>
        </h1>
        <p className="mx-auto mt-3 max-w-xl text-base text-muted-foreground">
          {catalogue.universities > 0
            ? `Browse ${compactNumber(catalogue.universities)} universities and ${compactNumber(catalogue.campuses)} campuses. Join your local community to start reading and sharing.`
            : "Browse universities and campuses across Pakistan. Join your community to connect with fellow students."}
        </p>

        {/* Search Bar */}
        <form action="/universities" method="GET" className="mx-auto mt-7 flex max-w-lg items-center gap-2">
          <div className="relative flex-1">
            <Search className="pointer-events-none absolute left-3.5 top-1/2 size-4 -translate-y-1/2 text-muted-foreground" />
            <input
              type="search"
              name="q"
              defaultValue={params.q || ""}
              placeholder="Search by name, acronym (e.g. NUST, FAST), or city…"
              className="h-11 w-full rounded-full border border-border bg-card pl-10 pr-4 text-sm shadow-xs transition-colors placeholder:text-muted-foreground focus:border-ring focus:outline-none focus:ring-2 focus:ring-ring"
            />
            {activeProvince ? <input type="hidden" name="province" value={activeProvince} /> : null}
            {activeSort !== "most_joined" ? <input type="hidden" name="sort" value={activeSort} /> : null}
          </div>
          <Button type="submit" size="md">
            Search
          </Button>
        </form>
      </div>

      {/* Filter Chips */}
      <div className="mt-10 flex flex-wrap items-center justify-between gap-3 border-b border-border/70 pb-4">
        {/* Province Pills */}
        <div className="flex flex-wrap items-center gap-1.5 overflow-x-auto no-scrollbar py-1">
          <Link
            href={`/universities?${new URLSearchParams({
              ...(params.q ? { q: params.q } : {}),
              sort: activeSort,
            }).toString()}`}
            className={`rounded-full px-3 py-1 text-xs font-medium transition-all ${
              !activeProvince
                ? "bg-primary text-primary-foreground shadow-xs"
                : "border border-border/80 bg-card text-muted-foreground hover:bg-muted hover:text-foreground"
            }`}
          >
            All Regions
          </Link>
          {PROVINCES.map((p) => {
            const isSelected = activeProvince === p;
            const queryParams = new URLSearchParams({
              ...(params.q ? { q: params.q } : {}),
              province: p,
              sort: activeSort,
            });
            return (
              <Link
                key={p}
                href={`/universities?${queryParams.toString()}`}
                className={`rounded-full px-3 py-1 text-xs font-medium transition-all ${
                  isSelected
                    ? "bg-primary text-primary-foreground shadow-xs"
                    : "border border-border/80 bg-card text-muted-foreground hover:bg-muted hover:text-foreground"
                }`}
              >
                {p}
              </Link>
            );
          })}
        </div>

        {/* Sort Selector */}
        <div className="flex items-center gap-2">
          <span className="text-xs text-muted-foreground">Sort:</span>
          <div className="flex items-center rounded-full border border-border/80 bg-card p-0.5 shadow-2xs">
            <Link
              href={`/universities?${new URLSearchParams({
                ...(params.q ? { q: params.q } : {}),
                ...(activeProvince ? { province: activeProvince } : {}),
                sort: "most_joined",
              }).toString()}`}
              className={`rounded-full px-2.5 py-1 text-xs font-medium transition-all ${
                activeSort === "most_joined"
                  ? "bg-primary text-primary-foreground"
                  : "text-muted-foreground hover:text-foreground"
              }`}
            >
              Popular
            </Link>
            <Link
              href={`/universities?${new URLSearchParams({
                ...(params.q ? { q: params.q } : {}),
                ...(activeProvince ? { province: activeProvince } : {}),
                sort: "name",
              }).toString()}`}
              className={`rounded-full px-2.5 py-1 text-xs font-medium transition-all ${
                activeSort === "name"
                  ? "bg-primary text-primary-foreground"
                  : "text-muted-foreground hover:text-foreground"
              }`}
            >
              A-Z
            </Link>
            <Link
              href={`/universities?${new URLSearchParams({
                ...(params.q ? { q: params.q } : {}),
                ...(activeProvince ? { province: activeProvince } : {}),
                sort: "campuses",
              }).toString()}`}
              className={`rounded-full px-2.5 py-1 text-xs font-medium transition-all ${
                activeSort === "campuses"
                  ? "bg-primary text-primary-foreground"
                  : "text-muted-foreground hover:text-foreground"
              }`}
            >
              Campuses
            </Link>
          </div>
        </div>
      </div>

      {/* Grid */}
      <div className="mt-8">
        {universities.length > 0 ? (
          <div className="grid gap-5 sm:grid-cols-2 lg:grid-cols-3">
            {universities.map((uni, idx) => (
              <UniversityCard
                key={uni.id}
                university={uni}
                signedIn={Boolean(session)}
                priority={idx < 6}
              />
            ))}
          </div>
        ) : (
          <Card className="p-10 text-center">
            <EmptyState
              icon={Building2}
              title="No universities found"
              description={
                params.q
                  ? `No universities matching "${params.q}" in ${activeProvince || "any region"}. Try a different search query.`
                  : "No universities match the selected filters."
              }
              action={
                <Button asChild variant="outline">
                  <Link href="/universities">Clear filters</Link>
                </Button>
              }
            />
          </Card>
        )}
      </div>
    </div>
  );
}
