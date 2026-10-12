"use server";

import { revalidatePath } from "next/cache";

import {
  onboardingBasicsSchema,
  onboardingPreferencesSchema,
  onboardingUniversitySchema,
} from "@/lib/validation/schemas";
import { requireUser } from "@/server/auth/context";
import { fail, okWith, runAction, type ActionResult } from "@/server/lib/results";

/**
 * Onboarding is resumable: every step persists `onboarding_step`, so a student
 * who closes the tab mid-flow returns to where they stopped rather than
 * starting over. `onboarding_completed` is only ever flipped by the final step.
 */

export async function saveBasicsAction(formData: FormData): Promise<ActionResult> {
  return runAction(async () => {
    const context = await requireUser();

    const payload = onboardingBasicsSchema.parse({
      displayName: formData.get("displayName"),
      username: formData.get("username"),
      bio: (formData.get("bio") as string) || "",
      avatarPath: (formData.get("avatarPath") as string) || null,
    });

    // Username uniqueness is enforced by a unique index; check first so we can
    // return a friendly field error instead of a 409.
    const taken = await context.db.select<{ id: string }>("profiles", {
      columns: "id",
      where: { username: payload.username },
      limit: 1,
    });
    if (taken.length > 0 && taken[0]!.id !== context.id) {
      return fail("That username is taken.", { username: ["Try another username."] });
    }

    await context.db.update(
      "profiles",
      {
        display_name: payload.displayName,
        username: payload.username,
        bio: payload.bio || null,
        onboarding_step: Math.max(context.profile.onboardingStep, 1),
      },
      { id: context.id },
      { returning: false },
    );

    revalidatePath("/onboarding");
    return okWith(undefined, "Saved.");
  });
}

export async function saveUniversityAction(formData: FormData): Promise<ActionResult> {
  return runAction(async () => {
    const context = await requireUser();

    const payload = onboardingUniversitySchema.parse({
      universityId: formData.get("universityId"),
      campusId: (formData.get("campusId") as string) || null,
      country: (formData.get("country") as string) || "Pakistan",
      degreeProgram: (formData.get("degreeProgram") as string) || "",
      department: (formData.get("department") as string) || "",
      semester: (formData.get("semester") as string) || "",
      graduationYear: (formData.get("graduationYear") as string) || null,
    });

    // The campus must actually belong to the chosen university — otherwise a
    // crafted request could attach a student to a campus that is not theirs.
    if (payload.campusId) {
      const campuses = await context.db.select<{ university_id: string }>("campuses", {
        columns: "university_id",
        where: { id: payload.campusId },
        limit: 1,
      });
      if (campuses[0]?.university_id !== payload.universityId) {
        return fail("Pick a campus that belongs to the selected university.", {
          campusId: ["Campus does not match the university."],
        });
      }
    }

    await context.db.update(
      "profiles",
      {
        university_id: payload.universityId,
        campus_id: payload.campusId,
        country: payload.country,
        degree_program: payload.degreeProgram || null,
        department: payload.department || null,
        semester: payload.semester || null,
        graduation_year: payload.graduationYear ?? null,
        onboarding_step: Math.max(context.profile.onboardingStep, 2),
      },
      { id: context.id },
      { returning: false },
    );

    revalidatePath("/onboarding");
    return okWith(undefined, "Saved.");
  });
}

export async function savePreferencesAction(formData: FormData): Promise<ActionResult> {
  return runAction(async () => {
    const context = await requireUser();

    const payload = onboardingPreferencesSchema.parse({
      bio: (formData.get("bio") as string) || "",
      profileVisibility: formData.get("profileVisibility"),
      interests: JSON.parse(String(formData.get("interests") ?? "[]")),
      notifications: JSON.parse(String(formData.get("notifications") ?? "{}")),
    });

    await context.db.update(
      "profiles",
      {
        bio: payload.bio || null,
        profile_visibility: payload.profileVisibility,
        interests: payload.interests,
        onboarding_step: Math.max(context.profile.onboardingStep, 3),
      },
      { id: context.id },
      { returning: false },
    );

    await context.db.update(
      "notification_preferences",
      {
        mentions: payload.notifications.mentions,
        comments: payload.notifications.comments,
        replies: payload.notifications.replies,
        likes: payload.notifications.likes,
        channel_activity: payload.notifications.channelActivity,
        product_updates: payload.notifications.productUpdates,
      },
      { user_id: context.id },
      { returning: false },
    );

    revalidatePath("/onboarding");
    return okWith(undefined, "Saved.");
  });
}

export async function completeOnboardingAction(): Promise<ActionResult<{ joinedAny: boolean }>> {
  return runAction(async () => {
    const context = await requireUser();

    // Guard the invariant that matters: no half-configured accounts.
    if (!context.profile.universityId) {
      return fail("Choose your university before finishing setup.");
    }

    const memberships = await context.db.select("channel_members", {
      columns: "id",
      where: { user_id: context.id },
      limit: 1,
    });

    await context.db.update(
      "profiles",
      { onboarding_completed: true, onboarding_step: 4 },
      { id: context.id },
      { returning: false },
    );

    revalidatePath("/home");
    return okWith(
      { joinedAny: memberships.length > 0 },
      memberships.length > 0 ? "You are all set." : "You are set up — join a community to fill your feed.",
    );
  });
}
