"use server";

import { revalidatePath } from "next/cache";

import { dataBackend } from "@/lib/env";
import { passwordSchema } from "@/lib/validation/schemas";
import { requireUser } from "@/server/auth/context";
import { supabaseServerClient } from "@/server/auth/session";
import { fail, ok, runAction, type ActionResult } from "@/server/lib/results";

/**
 * Password change.
 *
 * On Supabase the credential lives in `auth.users` and only the Auth service
 * may write it, so we delegate. Locally the same operation is performed by the
 * local auth provider. The app never stores or hashes passwords itself in
 * production — the requirement to keep authentication secrets inside the
 * provider is enforced by this being the only code path.
 */
export async function updatePasswordAction(password: string): Promise<ActionResult> {
  return runAction(async () => {
    const context = await requireUser();
    const parsed = passwordSchema.parse(password);

    if (dataBackend() === "supabase") {
      const client = await supabaseServerClient();
      if (!client) return fail("Authentication is not configured.");

      const { error } = await client.auth.updateUser({ password: parsed });
      if (error) return fail(error.message);

      return ok("Password updated.");
    }

    const { updateLocalPassword } = await import("@/server/auth/local-provider");
    await updateLocalPassword(context.id, parsed);
    return ok("Password updated.");
  });
}

export async function deleteAccountAction(confirmation: string): Promise<ActionResult> {
  return runAction(async () => {
    const context = await requireUser();

    if (confirmation.trim().toLowerCase() !== context.profile.username) {
      return fail("Type your username exactly to confirm.");
    }

    // Soft-deactivate rather than hard-delete: content that other students have
    // replied to stays coherent, and the moderation record survives. The
    // profile is anonymised and can no longer sign in or post.
    await context.db.update(
      "profiles",
      {
        is_suspended: true,
        suspended_reason: "Account closed by the owner",
        display_name: "Closed account",
        bio: null,
        avatar_url: null,
        banner_url: null,
        university_id: null,
        campus_id: null,
        profile_visibility: "private",
      },
      { id: context.id },
      { returning: false },
    );

    const { signOutCurrentUser } = await import("@/server/auth/session");
    await signOutCurrentUser();

    revalidatePath("/");
    return ok("Your account has been closed.");
  });
}
