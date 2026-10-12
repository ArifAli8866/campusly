/**
 * Session handling, unified across both backends.
 *
 * LOCAL mode mirrors Supabase Auth's shape using the `auth.users` /
 * `auth.sessions` tables created by supabase/local/0000_bootstrap.sql, with
 * scrypt password hashing from node:crypto. It exists so that the whole product
 * — sign up, sign in, protected routes, password reset — can be developed and
 * tested end to end without a network dependency.
 *
 * SUPABASE mode is the production path: @supabase/ssr keeps the session in
 * httpOnly cookies and refreshes it in middleware.
 */
import "server-only";

import { cookies } from "next/headers";
import { createHash, randomBytes, randomUUID, scrypt as scryptCb, timingSafeEqual } from "node:crypto";
import { promisify } from "node:util";

import { createServerClient } from "@supabase/ssr";
import type { SupabaseClient } from "@supabase/supabase-js";

import { dataBackend, env } from "@/lib/env";
import { createLocalDb } from "@/lib/db/local-db";

const scrypt = promisify(scryptCb) as (
  password: string | Buffer,
  salt: string | Buffer,
  keylen: number,
) => Promise<Buffer>;

export const SESSION_COOKIE = "campusly_session";
const SESSION_TTL_DAYS = 30;

export interface SessionUser {
  id: string;
  email: string | null;
  emailVerified: boolean;
}

/* ------------------------------------------------------------------ helpers */

async function hashPassword(password: string): Promise<string> {
  const salt = randomBytes(16);
  const derived = await scrypt(password, salt, 64);
  return `scrypt$${salt.toString("hex")}$${derived.toString("hex")}`;
}

async function verifyPassword(password: string, stored: string): Promise<boolean> {
  const [scheme, saltHex, hashHex] = stored.split("$");
  if (scheme !== "scrypt" || !saltHex || !hashHex) return false;
  const derived = await scrypt(password, Buffer.from(saltHex, "hex"), 64);
  const expected = Buffer.from(hashHex, "hex");
  return derived.length === expected.length && timingSafeEqual(derived, expected);
}

export function hashToken(token: string): string {
  return createHash("sha256").update(token).digest("hex");
}

/* ------------------------------------------------------------ supabase client */

export async function supabaseServerClient(): Promise<SupabaseClient | null> {
  if (dataBackend() !== "supabase") return null;

  const cookieStore = await cookies();

  return createServerClient(env.supabaseUrl!, env.supabaseAnonKey!, {
    cookies: {
      getAll() {
        return cookieStore.getAll();
      },
      setAll(cookiesToSet) {
        try {
          for (const { name, value, options } of cookiesToSet) {
            cookieStore.set(name, value, options);
          }
        } catch {
          // Called from a Server Component render: middleware refreshes instead.
        }
      },
    },
  }) as unknown as SupabaseClient;
}

/* ---------------------------------------------------------------- read session */

export async function getSessionUser(): Promise<SessionUser | null> {
  if (dataBackend() === "supabase") {
    const client = await supabaseServerClient();
    if (!client) return null;
    const { data, error } = await client.auth.getUser();
    if (error || !data.user) return null;
    return {
      id: data.user.id,
      email: data.user.email ?? null,
      emailVerified: Boolean(data.user.email_confirmed_at),
    };
  }

  // ---------------------------------------------------------------- local mode
  const cookieStore = await cookies();
  const raw = cookieStore.get(SESSION_COOKIE)?.value;
  if (!raw) return null;

  const db = createLocalDb({ actorId: null, serviceRole: true });
  const sessions = await db.select<{ user_id: string; expires_at: string }>("auth.sessions", {
    columns: "user_id, expires_at",
    where: { token_hash: hashToken(raw) },
    limit: 1,
  });

  const session = sessions[0];
  if (!session) return null;

  if (new Date(session.expires_at).getTime() < Date.now()) {
    await db.delete("auth.sessions", { token_hash: hashToken(raw) });
    return null;
  }

  const users = await db.select<{ id: string; email: string | null; email_confirmed_at: string | null }>(
    "auth.users",
    { columns: "id, email, email_confirmed_at", where: { id: session.user_id }, limit: 1 },
  );

  const user = users[0];
  if (!user) return null;

  return { id: user.id, email: user.email, emailVerified: Boolean(user.email_confirmed_at) };
}

/* ------------------------------------------------------------------ mutations */

export interface AuthResult {
  ok: boolean;
  error?: string;
  message?: string;
  userId?: string;
  needsEmailConfirmation?: boolean;
}

export async function signUpWithPassword(input: {
  email: string;
  password: string;
  displayName: string;
}): Promise<AuthResult> {
  const email = input.email.trim().toLowerCase();

  if (dataBackend() === "supabase") {
    const client = await supabaseServerClient();
    if (!client) return { ok: false, error: "Authentication is not configured." };

    const { data, error } = await client.auth.signUp({
      email,
      password: input.password,
      options: {
        data: { full_name: input.displayName },
        emailRedirectTo: `${env.siteUrl}/auth/callback?next=/onboarding`,
      },
    });

    if (error) return { ok: false, error: error.message };

    return {
      ok: true,
      userId: data.user?.id,
      needsEmailConfirmation: !data.session,
      message: data.session
        ? undefined
        : "Check your inbox — we sent a link to confirm your email address.",
    };
  }

  // ---------------------------------------------------------------- local mode
  const db = createLocalDb({ actorId: null, serviceRole: true });

  const existing = await db.select("auth.users", { columns: "id", where: { email }, limit: 1 });
  if (existing.length) return { ok: false, error: "An account with that email already exists." };

  const id = randomUUID();
  const passwordHash = await hashPassword(input.password);

  // Inserting into auth.users fires on_auth_user_created, which provisions the
  // profile, the default role and the notification preferences.
  await db.insert(
    "auth.users",
    {
      id,
      email,
      encrypted_password: passwordHash,
      email_confirmed_at: new Date().toISOString(),
      raw_user_meta_data: { full_name: input.displayName },
    },
    { returning: false },
  );

  // Local mode auto-confirms so the flow is usable offline; document that.
  await createLocalSession(id);
  return { ok: true, userId: id };
}

export async function signInWithPassword(input: { email: string; password: string }): Promise<AuthResult> {
  const email = input.email.trim().toLowerCase();

  if (dataBackend() === "supabase") {
    const client = await supabaseServerClient();
    if (!client) return { ok: false, error: "Authentication is not configured." };

    const { data, error } = await client.auth.signInWithPassword({ email, password: input.password });
    if (error) {
      // Do not reveal whether the address exists.
      return { ok: false, error: "Incorrect email or password." };
    }
    return { ok: true, userId: data.user?.id };
  }

  const db = createLocalDb({ actorId: null, serviceRole: true });
  const rows = await db.select<{ id: string; encrypted_password: string | null }>("auth.users", {
    columns: "id, encrypted_password",
    where: { email },
    limit: 1,
  });

  const user = rows[0];
  if (!user?.encrypted_password || !(await verifyPassword(input.password, user.encrypted_password))) {
    return { ok: false, error: "Incorrect email or password." };
  }

  await createLocalSession(user.id);
  return { ok: true, userId: user.id };
}

async function createLocalSession(userId: string): Promise<void> {
  const token = randomBytes(32).toString("base64url");
  const expiresAt = new Date(Date.now() + SESSION_TTL_DAYS * 24 * 60 * 60 * 1000);

  const db = createLocalDb({ actorId: null, serviceRole: true });
  await db.insert(
    "auth.sessions",
    {
      user_id: userId,
      token_hash: hashToken(token),
      expires_at: expiresAt.toISOString(),
    },
    { returning: false },
  );

  const cookieStore = await cookies();
  cookieStore.set(SESSION_COOKIE, token, {
    httpOnly: true,
    sameSite: "lax",
    secure: process.env.NODE_ENV === "production",
    path: "/",
    expires: expiresAt,
  });
}

export async function signOutCurrentUser(): Promise<void> {
  if (dataBackend() === "supabase") {
    const client = await supabaseServerClient();
    await client?.auth.signOut();
    return;
  }

  const cookieStore = await cookies();
  const raw = cookieStore.get(SESSION_COOKIE)?.value;
  if (raw) {
    const db = createLocalDb({ actorId: null, serviceRole: true });
    await db.delete("auth.sessions", { token_hash: hashToken(raw) });
  }
  cookieStore.delete(SESSION_COOKIE);
}

/**
 * Google OAuth. On Supabase this returns a provider URL for the browser to
 * navigate to. In local mode there is no OAuth provider, so the caller is told
 * exactly what to configure instead of being shown a dead button.
 */
export async function startGoogleOAuth(next = "/home"): Promise<{ ok: boolean; url?: string; error?: string }> {
  if (dataBackend() !== "supabase") {
    return {
      ok: false,
      error:
        "Google sign-in needs a Supabase project. Add NEXT_PUBLIC_SUPABASE_URL and NEXT_PUBLIC_SUPABASE_ANON_KEY " +
        "to .env.local, enable the Google provider in Supabase → Authentication → Providers, then reload. " +
        "See README.md → 'Configuring Google OAuth'.",
    };
  }

  const client = await supabaseServerClient();
  if (!client) return { ok: false, error: "Authentication is not configured." };

  const { data, error } = await client.auth.signInWithOAuth({
    provider: "google",
    options: {
      redirectTo: `${env.siteUrl}/auth/callback?next=${encodeURIComponent(next)}`,
      queryParams: { access_type: "offline", prompt: "consent" },
    },
  });

  if (error) return { ok: false, error: error.message };
  return { ok: true, url: data.url };
}

export async function requestPasswordReset(email: string): Promise<AuthResult> {
  const address = email.trim().toLowerCase();

  if (dataBackend() === "supabase") {
    const client = await supabaseServerClient();
    if (!client) return { ok: false, error: "Authentication is not configured." };

    // Always report the same thing, so the endpoint cannot enumerate accounts.
    // Supabase rate-limits this endpoint independently.
    await client.auth.resetPasswordForEmail(address, {
      redirectTo: `${env.siteUrl}/auth/callback?next=/reset-password`,
    });
    return { ok: true, message: "If that address has an account, a reset link is on its way." };
  }

  const db = createLocalDb({ actorId: null, serviceRole: true });
  const rows = await db.select<{ id: string }>("auth.users", { columns: "id", where: { email: address }, limit: 1 });

  if (rows[0]) {
    const token = randomBytes(32).toString("base64url");
    await db.insert(
      "password_resets",
      { user_id: rows[0].id, token_hash: hashToken(token), expires_at: new Date(Date.now() + 3600_000).toISOString() },
      { returning: false },
    );
    // In local development there is no mail transport; surface the link instead.
    if (process.env.NODE_ENV !== "production") {
      console.info(`[campusly] password reset link: ${env.siteUrl}/reset-password?token=${token}`);
    }
  }

  return { ok: true, message: "If that address has an account, a reset link is on its way." };
}
