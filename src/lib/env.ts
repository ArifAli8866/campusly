/**
 * Environment configuration.
 *
 * Campusly has two first-class data backends:
 *   1. Supabase  — set NEXT_PUBLIC_SUPABASE_URL + NEXT_PUBLIC_SUPABASE_ANON_KEY
 *   2. Local     — embedded Postgres, used automatically when (1) is absent.
 *
 * Nothing here ever reads a secret into a client bundle: only the two
 * NEXT_PUBLIC_* values are safe to expose, and they are the public anon key,
 * which is protected by RLS rather than by secrecy.
 */

function read(name: string): string | undefined {
  const value = process.env[name];
  return value && value.trim() !== "" ? value.trim() : undefined;
}

export const env = {
  supabaseUrl: read("NEXT_PUBLIC_SUPABASE_URL"),
  supabaseAnonKey: read("NEXT_PUBLIC_SUPABASE_ANON_KEY"),
  supabaseServiceRoleKey: read("SUPABASE_SERVICE_ROLE_KEY"),

  siteUrl:
    read("NEXT_PUBLIC_SITE_URL") ??
    (read("VERCEL_URL") ? `https://${read("VERCEL_URL")}` : "http://localhost:3000"),

  localPgDir: read("LOCAL_PG_DIR"),

  /** Feature flag: show the seeded demo accounts on the sign-in screen. */
  demoMode:
    read("NEXT_PUBLIC_DEMO_MODE") === "true" ||
    (read("NEXT_PUBLIC_DEMO_MODE") === undefined && !read("NEXT_PUBLIC_SUPABASE_URL")),
} as const;

export type DataBackend = "supabase" | "local";

export function dataBackend(): DataBackend {
  return env.supabaseUrl && env.supabaseAnonKey ? "supabase" : "local";
}

export function isSupabaseConfigured(): boolean {
  return dataBackend() === "supabase";
}

/**
 * Fail fast in production if the backend is misconfigured — silently falling
 * back to a local database on Vercel would be far worse than a build error.
 */
export function assertBackendUsable(): void {
  if (process.env.NODE_ENV === "production" && dataBackend() === "local" && process.env.VERCEL) {
    throw new Error(
      "NEXT_PUBLIC_SUPABASE_URL and NEXT_PUBLIC_SUPABASE_ANON_KEY must be set in production. " +
        "See README.md → 'Deploying to Vercel'.",
    );
  }
}
