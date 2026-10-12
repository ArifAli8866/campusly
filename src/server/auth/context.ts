import "server-only";

import { cache } from "react";
import { redirect } from "next/navigation";

import { dbAs } from "@/lib/db";
import type { AppRole, ProfileRow } from "@/lib/db/types";
import { getSessionUser } from "./session";

export interface SessionProfile {
  id: string;
  username: string;
  displayName: string;
  avatarUrl: string | null;
  bannerUrl: string | null;
  bio: string | null;
  universityId: string | null;
  campusId: string | null;
  interests: string[];
  profileVisibility: ProfileRow["profile_visibility"];
  onboardingCompleted: boolean;
  onboardingStep: number;
  isSuspended: boolean;
}

export interface UserContext {
  id: string;
  email: string | null;
  role: AppRole;
  profile: SessionProfile;
  unreadCount: number;
  db: Awaited<ReturnType<typeof dbAs>>;
}

function toProfile(row: ProfileRow): SessionProfile {
  return {
    id: row.id,
    username: row.username,
    displayName: row.display_name,
    avatarUrl: row.avatar_url,
    bannerUrl: row.banner_url,
    bio: row.bio,
    universityId: row.university_id,
    campusId: row.campus_id,
    interests: row.interests ?? [],
    profileVisibility: row.profile_visibility,
    onboardingCompleted: row.onboarding_completed,
    onboardingStep: row.onboarding_step,
    isSuspended: row.is_suspended,
  };
}

/**
 * The signed-in user, their role, their profile and a DB handle scoped to them.
 *
 * Roles are always read from the database (`user_roles`), never from a cookie,
 * a header or anything the client can influence. Wrapped in React `cache` so a
 * page and its children share one lookup per request.
 */
export const getUserContext = cache(async (userId: string): Promise<UserContext | null> => {
  const session = await getSessionUser();
  if (!session || session.id !== userId) return null;

  const db = await dbAs(userId);

  const [profiles, roleRows, unread] = await Promise.all([
    db.select<ProfileRow>("profiles", { where: { id: userId }, limit: 1 }),
    db.select<{ role: AppRole }>("user_roles", { columns: "role", where: { user_id: userId }, limit: 1 }),
    db.rpc<{ unread_notification_count: number }>("unread_notification_count"),
  ]);

  const profile = profiles[0];
  // The on_auth_user_created trigger provisions this row; if it is missing the
  // account is mid-provisioning and we treat the session as unusable.
  if (!profile) return null;

  return {
    id: userId,
    email: session.email,
    role: roleRows[0]?.role ?? "user",
    profile: toProfile(profile),
    unreadCount: unread[0]?.unread_notification_count ?? 0,
    db,
  };
});

export const getCurrentContext = cache(async (): Promise<UserContext | null> => {
  const session = await getSessionUser();
  if (!session) return null;
  return getUserContext(session.id);
});

/* ------------------------------------------------------------------- guards */

export async function requireUser(nextPath?: string): Promise<UserContext> {
  const context = await getCurrentContext();
  if (!context) {
    redirect(nextPath ? `/login?next=${encodeURIComponent(nextPath)}` : "/login");
  }
  return context;
}

/** Signed in AND finished onboarding. */
export async function requireOnboarded(nextPath?: string): Promise<UserContext> {
  const context = await requireUser(nextPath);
  if (!context.profile.onboardingCompleted) {
    redirect("/onboarding");
  }
  return context;
}

export async function requireModerator(): Promise<UserContext> {
  const context = await requireOnboarded("/moderation");
  if (context.role !== "moderator" && context.role !== "admin") {
    redirect("/home?denied=moderation");
  }
  return context;
}

export async function requireAdmin(): Promise<UserContext> {
  const context = await requireOnboarded("/admin");
  if (context.role !== "admin") {
    redirect("/home?denied=admin");
  }
  return context;
}

/** True when the viewer may act on a piece of content (own it or moderate it). */
export function canModerate(context: UserContext | null): boolean {
  return context?.role === "moderator" || context?.role === "admin";
}
