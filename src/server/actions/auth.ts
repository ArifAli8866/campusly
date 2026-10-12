"use server";

import { redirect } from "next/navigation";

import { forgotPasswordSchema, signInSchema, signUpSchema } from "@/lib/validation/schemas";
import {
  requestPasswordReset,
  signInWithPassword,
  signOutCurrentUser,
  signUpWithPassword,
  startGoogleOAuth,
} from "@/server/auth/session";
import { fail, ok, runAction, type ActionResult } from "@/server/lib/results";

export async function signUpAction(formData: FormData): Promise<ActionResult<{ next: string }>> {
  return runAction(async () => {
    const input = signUpSchema.parse({
      displayName: formData.get("displayName"),
      email: formData.get("email"),
      password: formData.get("password"),
      acceptGuidelines: formData.get("acceptGuidelines") === "true",
    });

    const result = await signUpWithPassword(input);
    if (!result.ok) return fail(result.error ?? "We could not create your account.");

    return {
      ok: true,
      data: { next: result.needsEmailConfirmation ? "/login?check-email=1" : "/onboarding" },
      message: result.message,
    };
  });
}

export async function signInAction(formData: FormData): Promise<ActionResult<{ next: string }>> {
  return runAction(async () => {
    const input = signInSchema.parse({
      email: formData.get("email"),
      password: formData.get("password"),
    });

    const result = await signInWithPassword(input);
    if (!result.ok) return fail(result.error ?? "Incorrect email or password.");

    // `next` is user-supplied: only ever follow a same-origin absolute path.
    const requested = String(formData.get("next") ?? "");
    const next = requested.startsWith("/") && !requested.startsWith("//") ? requested : "/home";

    return { ok: true, data: { next } };
  });
}

export async function signOutAction(): Promise<ActionResult> {
  return runAction(async () => {
    await signOutCurrentUser();
    return ok();
  });
}

export async function forgotPasswordAction(formData: FormData): Promise<ActionResult> {
  return runAction(async () => {
    const { email } = forgotPasswordSchema.parse({ email: formData.get("email") });
    const result = await requestPasswordReset(email);
    return ok(result.message ?? "If that address has an account, a reset link is on its way.");
  });
}

export async function googleOAuthAction(formData: FormData): Promise<ActionResult<{ url: string }>> {
  return runAction(async () => {
    const requested = String(formData.get("next") ?? "/home");
    const next = requested.startsWith("/") && !requested.startsWith("//") ? requested : "/home";

    const result = await startGoogleOAuth(next);
    if (!result.ok || !result.url) return fail(result.error ?? "Google sign-in is unavailable.");

    return { ok: true, data: { url: result.url } };
  });
}

/** Used by the OAuth callback route once a session cookie exists. */
export async function redirectAfterAuth(next: string): Promise<never> {
  const safe = next.startsWith("/") && !next.startsWith("//") ? next : "/home";
  redirect(safe);
}
