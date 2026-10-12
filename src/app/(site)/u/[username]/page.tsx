import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";
import {
  Calendar,
  EyeOff,
  GraduationCap,
  Lock,
  MessageSquare,
} from "lucide-react";

import { BRAND } from "@/components/brand";
import { PostCard } from "@/components/content/post-card";
import { Avatar, Badge, Card, EmptyState } from "@/components/ui/primitives";
import { Button } from "@/components/ui/button";
import { compactNumber } from "@/lib/utils";
import {
  getMentionMaps,
  getMyConfessions,
  getProfilePosts,
  getPublicProfile,
  viewerScope,
} from "@/server/services/queries";

export const dynamic = "force-dynamic";

export async function generateMetadata({
  params,
}: {
  params: Promise<{ username: string }>;
}): Promise<Metadata> {
  const { username } = await params;
  const scope = await viewerScope();
  const profile = await getPublicProfile(scope, username);

  if (!profile) {
    return { title: `Student Not Found — ${BRAND.name}` };
  }

  return {
    title: `${profile.display_name} (@${profile.username}) — ${BRAND.name}`,
    description: profile.bio || `Student at ${profile.university_name ?? "Campusly"}.`,
  };
}

export default async function UserProfilePage({
  params,
  searchParams,
}: {
  params: Promise<{ username: string }>;
  searchParams: Promise<{ tab?: "posts" | "confessions" }>;
}) {
  const { username } = await params;
  const { tab = "posts" } = await searchParams;
  const scope = await viewerScope();

  const profile = await getPublicProfile(scope, username);
  if (!profile || profile.is_suspended) {
    notFound();
  }

  const isOwner = profile.viewer_is_owner;
  const activeTab = isOwner && tab === "confessions" ? "confessions" : "posts";

  const [posts, confessions] = await Promise.all([
    activeTab === "posts" ? getProfilePosts(scope, profile.id, { limit: 20 }) : [],
    isOwner && activeTab === "confessions" ? getMyConfessions(scope, { limit: 20 }) : [],
  ]);

  const displayedPosts = activeTab === "confessions" ? confessions : posts;
  const mentionMaps = await getMentionMaps(scope, { postIds: displayedPosts.map((p) => p.id) });

  return (
    <div className="mx-auto w-full max-w-4xl px-4 py-6 sm:py-10">
      {/* Profile Header Surface */}
      <div className="surface overflow-hidden">
        {/* Banner */}
        <div className="relative h-32 sm:h-44 w-full bg-ink-950">
          {profile.banner_url ? (
            // eslint-disable-next-line @next/next/no-img-element
            <img src={profile.banner_url} alt="" className="size-full object-cover" />
          ) : (
            <div className="grid-canvas absolute inset-0 opacity-25" />
          )}
          <div className="absolute inset-0 bg-gradient-to-t from-ink-950/80 to-transparent" />
        </div>

        {/* Profile Card Body */}
        <div className="p-5 sm:p-6">
          <div className="-mt-14 sm:-mt-16 mb-4 flex flex-wrap items-end justify-between gap-3">
            <Avatar
              src={profile.avatar_url}
              name={profile.display_name}
              size="xl"
              className="size-20 sm:size-24 border-4 border-card bg-card shadow-[var(--shadow-lift)]"
            />

            {isOwner ? (
              <Button asChild size="sm" variant="outline">
                <Link href="/onboarding">Edit Profile</Link>
              </Button>
            ) : null}
          </div>

          <div>
            <div className="flex flex-wrap items-center gap-2">
              <h1 className="text-xl sm:text-2xl font-bold tracking-tight text-foreground">
                {profile.display_name}
              </h1>
              <span className="text-sm text-muted-foreground">@{profile.username}</span>
            </div>

            {/* University & Degree info */}
            <div className="mt-2 flex flex-wrap items-center gap-2 sm:gap-3 text-xs sm:text-sm text-muted-foreground">
              {profile.university_name ? (
                <span className="flex items-center gap-1 font-medium text-foreground">
                  <GraduationCap className="size-4 text-accent" />
                  {profile.university_slug ? (
                    <Link href={`/universities/${profile.university_slug}`} className="hover:underline">
                      {profile.university_abbreviation ?? profile.university_name}
                    </Link>
                  ) : (
                    profile.university_abbreviation ?? profile.university_name
                  )}
                  {profile.campus_name ? ` · ${profile.campus_name.replace(/ Campus$/, "")}` : ""}
                </span>
              ) : null}

              {profile.department || profile.degree_program ? (
                <span className="flex items-center gap-1 text-muted-foreground">
                  • {profile.degree_program || profile.department}
                </span>
              ) : null}

              {profile.graduation_year ? (
                <span className="flex items-center gap-1 text-muted-foreground">
                  <Calendar className="size-3.5" /> Class of {profile.graduation_year}
                </span>
              ) : null}
            </div>

            {/* Bio */}
            {profile.bio ? (
              <p className="mt-3 text-sm leading-relaxed text-foreground max-w-2xl">{profile.bio}</p>
            ) : null}

            {/* Interests badges */}
            {profile.interests && profile.interests.length > 0 ? (
              <div className="mt-3 flex flex-wrap gap-1.5">
                {profile.interests.map((interest) => (
                  <Badge key={interest} variant="neutral" size="sm">
                    #{interest}
                  </Badge>
                ))}
              </div>
            ) : null}

            {/* Stats row */}
            <div className="mt-5 flex items-center gap-5 border-t border-border pt-4 text-xs sm:text-sm">
              <span className="text-muted-foreground">
                <strong className="text-foreground font-semibold">{compactNumber(profile.public_post_count)}</strong>{" "}
                public posts
              </span>
              <span className="text-muted-foreground">
                <strong className="text-foreground font-semibold">{compactNumber(profile.channels_joined)}</strong>{" "}
                communities
              </span>
            </div>
          </div>
        </div>
      </div>

      {/* Tabs: Public Posts vs (if owner) My Confessions */}
      <div className="mt-8">
        <div className="flex items-center gap-2 border-b border-border/70 pb-3">
          <Link
            href={`/u/${profile.username}?tab=posts`}
            className={`flex items-center gap-1.5 rounded-full px-4 py-1.5 text-xs sm:text-sm font-medium transition-all ${
              activeTab === "posts"
                ? "bg-primary text-primary-foreground shadow-2xs"
                : "text-muted-foreground hover:text-foreground"
            }`}
          >
            <MessageSquare className="size-3.5" />
            Public Posts ({compactNumber(profile.public_post_count)})
          </Link>

          {isOwner ? (
            <Link
              href={`/u/${profile.username}?tab=confessions`}
              className={`flex items-center gap-1.5 rounded-full px-4 py-1.5 text-xs sm:text-sm font-medium transition-all ${
                activeTab === "confessions"
                  ? "bg-primary text-primary-foreground shadow-2xs"
                  : "text-muted-foreground hover:text-foreground"
              }`}
            >
              <EyeOff className="size-3.5 text-accent" />
              My Anonymous Confessions
              <Badge variant="subtle" size="sm" className="ml-1">
                Only you
              </Badge>
            </Link>
          ) : null}
        </div>

        {/* Tab Description note */}
        {activeTab === "confessions" ? (
          <div className="mt-3 flex items-center gap-2 rounded-xl bg-accent-subtle/60 p-3 text-xs text-accent">
            <Lock className="size-4 shrink-0" />
            <span>
              This list is private to you. Other students cannot see this tab or trace these confessions to your profile.
            </span>
          </div>
        ) : null}

        {/* Feed */}
        <div className="mt-6 space-y-4">
          {displayedPosts.length > 0 ? (
            displayedPosts.map((post) => (
              <PostCard key={post.id} post={post} mentions={mentionMaps.flat} />
            ))
          ) : (
            <Card className="p-8 text-center">
              <EmptyState
                icon={activeTab === "confessions" ? EyeOff : MessageSquare}
                title={activeTab === "confessions" ? "No anonymous confessions" : "No public posts yet"}
                description={
                  activeTab === "confessions"
                    ? "Confessions you share anonymously will be listed here privately for your reference."
                    : `${profile.display_name} hasn't posted anything publicly yet.`
                }
                action={
                  isOwner ? (
                    <Button asChild size="sm">
                      <Link href="/compose">Share a post</Link>
                    </Button>
                  ) : undefined
                }
              />
            </Card>
          )}
        </div>
      </div>
    </div>
  );
}
