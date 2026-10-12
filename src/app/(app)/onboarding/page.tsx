import type { Metadata } from "next";
import { redirect } from "next/navigation";

import { OnboardingWizard } from "@/components/onboarding/wizard";
import { requireUser } from "@/server/auth/context";
import { getCatalogueCounts, getRecommendedChannels, getUniversityChoices } from "@/server/services/queries";

export const metadata: Metadata = {
  title: "Set up your profile",
  robots: { index: false, follow: false },
};

export default async function OnboardingPage() {
  const context = await requireUser("/onboarding");
  if (context.profile.onboardingCompleted) redirect("/home");

  const scope = { db: context.db, userId: context.id };

  const [universities, prefs, recommended] = await Promise.all([
    getUniversityChoices(scope, undefined, 20),
    context.db.select<{
      mentions: boolean;
      comments: boolean;
      replies: boolean;
      likes: boolean;
      channel_activity: boolean;
      product_updates: boolean;
    }>("notification_preferences", {
      columns: "mentions, comments, replies, likes, channel_activity, product_updates",
      where: { user_id: context.id },
      limit: 1,
    }),
    getRecommendedChannels(scope, 8),
  ]);

  const catalogue = await getCatalogueCounts(scope);

  const profileRow = await context.db.select<{
    degree_program: string | null;
    department: string | null;
    semester: string | null;
    graduation_year: number | null;
    country: string;
  }>("profiles", {
    columns: "degree_program, department, semester, graduation_year, country",
    where: { id: context.id },
    limit: 1,
  });

  const row = profileRow[0];

  return (
    <OnboardingWizard
      userId={context.id}
      initialStep={context.profile.onboardingStep}
      profile={{
        displayName: context.profile.displayName,
        username: context.profile.username,
        bio: context.profile.bio ?? "",
        avatarUrl: context.profile.avatarUrl,
        universityId: context.profile.universityId,
        campusId: context.profile.campusId,
        country: row?.country ?? "Pakistan",
        degreeProgram: row?.degree_program ?? "",
        department: row?.department ?? "",
        semester: row?.semester ?? "",
        graduationYear: row?.graduation_year ? String(row.graduation_year) : "",
        profileVisibility: context.profile.profileVisibility,
        interests: context.profile.interests,
      }}
      notifications={{
        mentions: prefs[0]?.mentions ?? true,
        comments: prefs[0]?.comments ?? true,
        replies: prefs[0]?.replies ?? true,
        likes: prefs[0]?.likes ?? true,
        channelActivity: prefs[0]?.channel_activity ?? false,
        productUpdates: prefs[0]?.product_updates ?? true,
      }}
      universities={universities}
      recommended={recommended}
      totalUniversities={catalogue.universities}
    />
  );
}
