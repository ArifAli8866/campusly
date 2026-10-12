"use server";

import { revalidatePath } from "next/cache";

import { notificationPrefsSchema, privacyUpdateSchema, profileUpdateSchema } from "@/lib/validation/schemas";
import { requireUser } from "@/server/auth/context";
import { fail, ok, okWith, runAction, type ActionResult } from "@/server/lib/results";

const USERNAME_CHANGE_COOLDOWN_DAYS = 14;

export async function updateProfileAction(formData: FormData): Promise<ActionResult> {
  return runAction(async () => {
    const context = await requireUser();

    const payload = profileUpdateSchema.parse({
      displayName: formData.get("displayName"),
      username: formData.get("username"),
      bio: (formData.get("bio") as string) || "",
      universityId: (formData.get("universityId") as string) || null,
      campusId: (formData.get("campusId") as string) || null,
      degreeProgram: (formData.get("degreeProgram") as string) || "",
      department: (formData.get("department") as string) || "",
      semester: (formData.get("semester") as string) || "",
      graduationYear: (formData.get("graduationYear") as string) || null,
      country: (formData.get("country") as string) || "Pakistan",
      avatarUrl: (formData.get("avatarUrl") as string) || null,
      bannerUrl: (formData.get("bannerUrl") as string) || null,
    });

    const changesUsername = payload.username !== context.profile.username;

    if (changesUsername) {
      const taken = await context.db.select<{ id: string }>("profiles", {
        columns: "id",
        where: { username: payload.username },
        limit: 1,
      });
      if (taken.length > 0 && taken[0]!.id !== context.id) {
        return fail("That username is taken.", { username: ["Try another username."] });
      }

      // Usernames appear in mention links and share URLs, so they cannot be
      // churned freely. The cooldown is advisory-soft: an admin can clear it.
      const row = await context.db.select<{ username_changed_at: string | null }>("profiles", {
        columns: "username_changed_at",
        where: { id: context.id },
        limit: 1,
      });
      const lastChanged = row[0]?.username_changed_at;
      if (lastChanged) {
        const days = (Date.now() - new Date(lastChanged).getTime()) / 86_400_000;
        if (days < USERNAME_CHANGE_COOLDOWN_DAYS) {
          const remaining = Math.ceil(USERNAME_CHANGE_COOLDOWN_DAYS - days);
          return fail(`You changed your username recently. Try again in ${remaining} day(s).`, {
            username: [`Available again in ${remaining} day(s).`],
          });
        }
      }
    }

    if (payload.campusId && payload.universityId) {
      const campuses = await context.db.select<{ university_id: string }>("campuses", {
        columns: "university_id",
        where: { id: payload.campusId },
        limit: 1,
      });
      if (campuses[0]?.university_id !== payload.universityId) {
        return fail("That campus does not belong to the selected university.", {
          campusId: ["Campus does not match the university."],
        });
      }
    }

    await context.db.update(
      "profiles",
      {
        display_name: payload.displayName,
        username: payload.username,
        bio: payload.bio || null,
        university_id: payload.universityId,
        campus_id: payload.campusId,
        degree_program: payload.degreeProgram || null,
        department: payload.department || null,
        semester: payload.semester || null,
        graduation_year: payload.graduationYear ?? null,
        country: payload.country,
        avatar_url: payload.avatarUrl,
        banner_url: payload.bannerUrl,
        ...(changesUsername ? { username_changed_at: new Date().toISOString() } : {}),
      },
      { id: context.id },
      { returning: false },
    );

    revalidatePath("/settings/profile");
    revalidatePath(`/u/${payload.username}`);
    revalidatePath("/home");
    return ok("Profile updated.");
  });
}

export async function updatePrivacyAction(formData: FormData): Promise<ActionResult> {
  return runAction(async () => {
    const context = await requireUser();

    const payload = privacyUpdateSchema.parse({
      profileVisibility: formData.get("profileVisibility"),
      interests: JSON.parse(String(formData.get("interests") ?? "[]")),
    });

    await context.db.update(
      "profiles",
      { profile_visibility: payload.profileVisibility, interests: payload.interests },
      { id: context.id },
      { returning: false },
    );

    revalidatePath("/settings/privacy");
    return ok("Privacy settings saved.");
  });
}

export async function updateNotificationPrefsAction(formData: FormData): Promise<ActionResult> {
  return runAction(async () => {
    const context = await requireUser();

    const payload = notificationPrefsSchema.parse({
      mentions: formData.get("mentions") === "true",
      comments: formData.get("comments") === "true",
      replies: formData.get("replies") === "true",
      likes: formData.get("likes") === "true",
      channelActivity: formData.get("channelActivity") === "true",
      productUpdates: formData.get("productUpdates") === "true",
    });

    const updated = await context.db.update(
      "notification_preferences",
      {
        mentions: payload.mentions,
        comments: payload.comments,
        replies: payload.replies,
        likes: payload.likes,
        channel_activity: payload.channelActivity,
        product_updates: payload.productUpdates,
      },
      { user_id: context.id },
      { returning: false },
    );

    // First save may race the provisioning trigger; upsert if nothing matched.
    if (updated.length === 0) {
      await context.db.insert("notification_preferences", {
        user_id: context.id,
        mentions: payload.mentions,
        comments: payload.comments,
        replies: payload.replies,
        likes: payload.likes,
        channel_activity: payload.channelActivity,
        product_updates: payload.productUpdates,
      }, { returning: false });
    }

    revalidatePath("/settings/notifications");
    return ok("Notification preferences saved.");
  });
}

/** Server-side username availability probe used by the signup/onboarding form. */
export async function checkUsernameAction(username: string): Promise<ActionResult<{ available: boolean }>> {
  return runAction(async () => {
    const context = await requireUser();
    const normalised = username.trim().toLowerCase();

    if (!/^[a-z0-9_]{3,24}$/.test(normalised)) {
      return okWith({ available: false });
    }

    const rows = await context.db.select<{ id: string }>("profiles", {
      columns: "id",
      where: { username: normalised },
      limit: 1,
    });

    return okWith({ available: rows.length === 0 || rows[0]!.id === context.id });
  });
}

export async function searchUsersForMentionAction(query: string): Promise<ActionResult<{ id: string; username: string; displayName: string; avatarUrl: string | null }[]>> {
  return runAction(async () => {
    const context = await requireUser();
    const term = query.trim().toLowerCase().replace(/[^a-z0-9_]/g, "");
    if (term.length < 1) return okWith([]);

    // Mention autocomplete respects blocks and never surfaces suspended users.
    const rows = await context.db.rpc<{
      id: string;
      username: string;
      display_name: string;
      avatar_url: string | null;
    }>("discover_users", { p_query: term, p_limit: 8 });

    return okWith(
      rows
        .filter((row) => row.id !== context.id)
        .map((row) => ({
          id: row.id,
          username: row.username,
          displayName: row.display_name,
          avatarUrl: row.avatar_url,
        })),
    );
  });
}
