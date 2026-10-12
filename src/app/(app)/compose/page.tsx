import type { Metadata } from "next";
import Link from "next/link";
import { ArrowLeft, Compass, ShieldCheck } from "lucide-react";

import { Composer, type ComposerChannel } from "@/components/content/composer";
import { InlineAlert } from "@/components/ui/fields";
import { Button } from "@/components/ui/button";
import { EmptyState } from "@/components/ui/primitives";
import { PageHeader } from "@/components/layout/page-header";
import { requireOnboarded } from "@/server/auth/context";
import { getMyChannels } from "@/server/services/queries";

export const metadata: Metadata = {
  title: "Write a confession",
  robots: { index: false, follow: false },
};

export const dynamic = "force-dynamic";

export default async function ComposePage() {
  const context = await requireOnboarded("/compose");
  const channels = await getMyChannels({ db: context.db, userId: context.id }, 60);

  const composerChannels: ComposerChannel[] = channels.map((channel) => ({
    id: channel.channel_id,
    slug: channel.channel_slug,
    name: channel.university_abbreviation ?? channel.university_name,
    label: `${channel.university_abbreviation ?? channel.university_name} · ${channel.campus_name.replace(/ Campus$/, "")}`,
  }));

  return (
    <div className="mx-auto w-full max-w-2xl px-4 py-6 sm:py-8">
      <Button asChild variant="ghost" size="sm" className="mb-4">
        <Link href="/home">
          <ArrowLeft /> Back to home
        </Link>
      </Button>

      <PageHeader
        title="Write a confession"
        description="Pick who can see it, then choose whether your name is attached. You can change the anonymity choice on every post."
      />

      <div className="mt-5">
        {composerChannels.length === 0 ? (
          <EmptyState
            icon={Compass}
            title="Join a community first"
            description="Confessions belong to a campus community, so you need to join at least one before you can publish. It takes one tap."
            action={
              <Button asChild>
                <Link href="/explore">
                  <Compass /> Find my campus
                </Link>
              </Button>
            }
          />
        ) : (
          <Composer
            channels={composerChannels}
            defaultChannelId={composerChannels[0]!.id}
            currentUser={{
              displayName: context.profile.displayName,
              username: context.profile.username,
              avatarUrl: context.profile.avatarUrl,
            }}
          />
        )}
      </div>

      <InlineAlert tone="info" title="Before you post" className="mt-5">
        <ul className="list-disc space-y-1 pl-4">
          <li>Do not name or describe an identifiable person. It is the fastest way to get a post removed.</li>
          <li>Never post phone numbers, addresses, CNIC numbers or screenshots of private chats.</li>
          <li>
            Anonymous posts hide your name and photo. They do not hide your post from moderators if it is reported —
            see the{" "}
            <Link href="/community-guidelines" className="underline underline-offset-2">
              community guidelines
            </Link>
            .
          </li>
        </ul>
      </InlineAlert>

      <p className="mt-4 flex items-start gap-1.5 text-xs text-muted-foreground">
        <ShieldCheck className="mt-0.5 size-3 shrink-0" aria-hidden />
        Your name is stored with your post so you can edit or delete it later, but the database never returns it to
        anyone who is not authorised to see it.
      </p>
    </div>
  );
}
