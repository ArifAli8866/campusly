import type { Metadata } from "next";
import Link from "next/link";
import { Search, Users } from "lucide-react";

import { BRAND } from "@/components/brand";
import { Avatar, Badge, Card, EmptyState } from "@/components/ui/primitives";
import { Button } from "@/components/ui/button";
import { getDiscoverableUsers, getUniversityChoices, viewerScope } from "@/server/services/queries";

export const metadata: Metadata = {
  title: `Discover Students — ${BRAND.name}`,
  description: "Find and connect with fellow students across universities in Pakistan.",
};

export const dynamic = "force-dynamic";

export default async function DiscoverStudentsPage({
  searchParams,
}: {
  searchParams: Promise<{ q?: string; universityId?: string }>;
}) {
  const params = await searchParams;
  const scope = await viewerScope();

  const [students, universities] = await Promise.all([
    getDiscoverableUsers(scope, {
      query: params.q || null,
      universityId: params.universityId || null,
      limit: 30,
    }),
    getUniversityChoices(scope, undefined, 20),
  ]);

  const activeUni = params.universityId || "";

  return (
    <div className="mx-auto w-full max-w-5xl px-4 py-8 sm:py-12">
      {/* Header */}
      <div className="mx-auto max-w-2xl text-center">
        <Badge variant="outline" size="sm" className="mb-2 shadow-2xs gap-1.5">
          <Users className="size-3 text-accent" />
          <span>Student Directory</span>
        </Badge>
        <h1 className="text-2xl sm:text-3xl font-bold tracking-tight text-foreground">
          Discover Students
        </h1>
        <p className="mt-1 text-sm text-muted-foreground">
          Find classmates, departmental peers, and students from universities across Pakistan.
        </p>

        {/* Search */}
        <form action="/discover" method="GET" className="mt-6 flex items-center gap-2">
          <div className="relative flex-1">
            <Search className="pointer-events-none absolute left-3.5 top-1/2 size-4 -translate-y-1/2 text-muted-foreground" />
            <input
              type="search"
              name="q"
              defaultValue={params.q || ""}
              placeholder="Search by student name, @username, or field of study…"
              className="h-11 w-full rounded-full border border-border bg-card pl-10 pr-4 text-sm shadow-xs transition-colors placeholder:text-muted-foreground focus:border-ring focus:outline-none focus:ring-2 focus:ring-ring"
            />
            {activeUni ? <input type="hidden" name="universityId" value={activeUni} /> : null}
          </div>
          <Button type="submit" size="md">
            Search
          </Button>
        </form>
      </div>

      {/* University filter bar */}
      <div className="mt-8 flex items-center gap-1.5 overflow-x-auto no-scrollbar border-b border-border/70 pb-3">
        <Link
          href={`/discover?${new URLSearchParams(params.q ? { q: params.q } : {}).toString()}`}
          className={`rounded-full px-3 py-1 text-xs font-medium transition-all ${
            !activeUni
              ? "bg-primary text-primary-foreground shadow-2xs"
              : "border border-border/80 bg-card text-muted-foreground hover:bg-muted hover:text-foreground"
          }`}
        >
          All Universities
        </Link>
        {universities.map((uni) => (
          <Link
            key={uni.id}
            href={`/discover?${new URLSearchParams({
              ...(params.q ? { q: params.q } : {}),
              universityId: uni.id,
            }).toString()}`}
            className={`rounded-full px-3 py-1 text-xs font-medium transition-all shrink-0 ${
              activeUni === uni.id
                ? "bg-primary text-primary-foreground shadow-2xs"
                : "border border-border/80 bg-card text-muted-foreground hover:bg-muted hover:text-foreground"
            }`}
          >
            {uni.abbreviation ?? uni.name}
          </Link>
        ))}
      </div>

      {/* Grid */}
      <div className="mt-8">
        {students.length > 0 ? (
          <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
            {students.map((student) => (
              <Card key={student.id} className="flex flex-col p-5 hover:border-border-strong transition-all">
                <div className="flex items-start gap-3">
                  <Avatar src={student.avatar_url} name={student.display_name} size="lg" />
                  <div className="min-w-0 flex-1">
                    <h2 className="truncate font-semibold text-sm text-foreground">
                      <Link href={`/u/${student.username}`} className="hover:underline">
                        {student.display_name}
                      </Link>
                    </h2>
                    <p className="truncate text-xs text-muted-foreground">@{student.username}</p>

                    {student.university_name ? (
                      <p className="mt-1 truncate text-xs font-medium text-accent">
                        {student.university_abbreviation ?? student.university_name}
                        {student.campus_name ? ` · ${student.campus_name.replace(/ Campus$/, "")}` : ""}
                      </p>
                    ) : null}
                  </div>
                </div>

                {student.channels_joined > 0 ? (
                  <p className="mt-3 text-xs text-muted-foreground flex items-center gap-1.5">
                    <Users className="size-3.5 text-accent" />
                    Member of {student.channels_joined} {student.channels_joined === 1 ? "community" : "communities"}
                  </p>
                ) : null}

                {student.bio ? (
                  <p className="mt-2 line-clamp-2 text-xs leading-relaxed text-muted-foreground">
                    {student.bio}
                  </p>
                ) : null}

                <div className="mt-auto pt-4 border-t border-border mt-4">
                  <Button asChild size="sm" variant="outline" className="w-full">
                    <Link href={`/u/${student.username}`}>View Profile →</Link>
                  </Button>
                </div>
              </Card>
            ))}
          </div>
        ) : (
          <Card className="p-10 text-center">
            <EmptyState
              icon={Users}
              title="No students found"
              description={
                params.q
                  ? `No students matching "${params.q}". Try a different name or clear the university filter.`
                  : "No students currently match this filter."
              }
              action={
                <Button asChild variant="outline">
                  <Link href="/discover">Clear filters</Link>
                </Button>
              }
            />
          </Card>
        )}
      </div>
    </div>
  );
}
