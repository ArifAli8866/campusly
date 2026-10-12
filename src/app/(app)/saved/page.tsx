import type { Metadata } from "next";
import Link from "next/link";
import { Bookmark, Compass } from "lucide-react";

import { BRAND } from "@/components/brand";
import { PostCard } from "@/components/content/post-card";
import { Card, EmptyState } from "@/components/ui/primitives";
import { Button } from "@/components/ui/button";
import { PageHeader } from "@/components/layout/page-header";
import { requireOnboarded } from "@/server/auth/context";
import { getMentionMaps, getSavedPosts } from "@/server/services/queries";

export const metadata: Metadata = {
  title: `Saved Posts — ${BRAND.name}`,
  robots: { index: false, follow: false },
};

export const dynamic = "force-dynamic";

export default async function SavedPostsPage() {
  const context = await requireOnboarded("/saved");
  const scope = { db: context.db, userId: context.id };

  const savedPosts = await getSavedPosts(scope, 40);
  const mentionMaps = await getMentionMaps(scope, { postIds: savedPosts.map((p) => p.id) });

  return (
    <div className="mx-auto w-full max-w-3xl px-4 py-6 sm:py-8">
      <PageHeader
        title="Saved Posts"
        description="Confessions and discussions you have bookmarked. Saved privately to your account — no one else can see your saved list."
      />

      <div className="mt-6 space-y-4">
        {savedPosts.length > 0 ? (
          savedPosts.map((post) => (
            <PostCard key={post.id} post={post} mentions={mentionMaps.flat} />
          ))
        ) : (
          <Card className="p-10 text-center">
            <EmptyState
              icon={Bookmark}
              title="No saved confessions yet"
              description="Tap the bookmark icon on any post or confession across your feeds to save it here for later."
              action={
                <Button asChild>
                  <Link href="/home">
                    <Compass className="size-4" /> Go to Feed
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
