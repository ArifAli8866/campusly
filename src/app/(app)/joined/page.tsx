import type { Metadata } from "next";
import Link from "next/link";
import { Building2, Compass, Layers, MessageSquare, PenLine, Users } from "lucide-react";

import { BRAND } from "@/components/brand";
import { JoinButton } from "@/components/content/join-button";
import { Badge, Card, EmptyState } from "@/components/ui/primitives";
import { Button } from "@/components/ui/button";
import { PageHeader } from "@/components/layout/page-header";
import { compactNumber } from "@/lib/utils";
import { requireOnboarded } from "@/server/auth/context";
import { getMyChannels } from "@/server/services/queries";

export const metadata: Metadata = {
  title: `My Communities — ${BRAND.name}`,
  robots: { index: false, follow: false },
};

export const dynamic = "force-dynamic";

export default async function JoinedCommunitiesPage() {
  const context = await requireOnboarded("/joined");
  const scope = { db: context.db, userId: context.id };

  const myChannels = await getMyChannels(scope, 100);

  return (
    <div className="mx-auto w-full max-w-5xl px-4 py-6 sm:py-8">
      <PageHeader
        title="My Communities"
        description="Campuses and discussion forums you have joined. Posts from these channels appear on your home feed."
        actions={
          <Button asChild size="sm" variant="outline">
            <Link href="/universities">
              <Compass className="size-4" /> Discover More
            </Link>
          </Button>
        }
      />

      <div className="mt-8">
        {myChannels.length > 0 ? (
          <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
            {myChannels.map((channel) => (
              <Card key={channel.channel_id} className="flex flex-col p-5 hover:border-border-strong">
                <div className="flex items-start justify-between gap-3">
                  <div className="min-w-0">
                    <h2 className="truncate font-semibold text-foreground">
                      <Link href={`/channels/${channel.channel_slug}`} className="hover:underline">
                        {channel.campus_name}
                      </Link>
                    </h2>
                    <p className="mt-0.5 truncate text-xs font-medium text-accent">
                      {channel.university_abbreviation ?? channel.university_name}
                    </p>
                    {channel.city ? (
                      <p className="mt-0.5 text-xs text-muted-foreground">{channel.city}</p>
                    ) : null}
                  </div>

                  <Badge variant="subtle" size="sm">
                    Member
                  </Badge>
                </div>

                <dl className="mt-5 grid grid-cols-2 gap-2 border-t border-border pt-3 text-xs">
                  <div>
                    <dt className="text-muted-foreground flex items-center gap-1">
                      <Users className="size-3" /> Members
                    </dt>
                    <dd className="mt-0.5 font-semibold text-foreground tabular-nums">
                      {compactNumber(channel.member_count)}
                    </dd>
                  </div>
                  <div>
                    <dt className="text-muted-foreground flex items-center gap-1">
                      <MessageSquare className="size-3" /> Posts
                    </dt>
                    <dd className="mt-0.5 font-semibold text-foreground tabular-nums">
                      {compactNumber(channel.post_count)}
                    </dd>
                  </div>
                </dl>

                <div className="mt-auto flex items-center gap-2 pt-4">
                  <Button asChild size="sm" className="flex-1">
                    <Link href={`/channels/${channel.channel_slug}`}>View Feed</Link>
                  </Button>
                  <Button asChild variant="outline" size="sm">
                    <Link href={`/compose`}>
                      <PenLine className="size-3.5" />
                    </Link>
                  </Button>
                  <JoinButton
                    channelId={channel.channel_id}
                    channelSlug={channel.channel_slug}
                    isMember={true}
                    signedIn={true}
                    size="sm"
                  />
                </div>
              </Card>
            ))}
          </div>
        ) : (
          <Card className="p-10 text-center">
            <EmptyState
              icon={Layers}
              title="No joined communities yet"
              description="You have not joined any campus communities. Explore universities across Pakistan and find your local campus forum."
              action={
                <Button asChild>
                  <Link href="/universities">
                    <Building2 className="size-4" /> Browse Universities
                  </Link>
                </Button>
              }
            />
          </Card>
        )}
      </div>
    </div>
  );
}
