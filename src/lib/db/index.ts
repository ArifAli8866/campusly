/**
 * Backend selection. Everything server-side obtains its handle from here, so
 * there is exactly one place that decides whether we are talking to Supabase
 * or to the embedded local Postgres.
 */
import "server-only";

import { createClient } from "@supabase/supabase-js";

import { dataBackend, env } from "@/lib/env";
import { createLocalDb, createLocalServiceDb } from "./local-db";
import { createSupabaseDb } from "./supabase-db";
import type { Db } from "./interface";

export type { Db } from "./interface";
export { DatabaseError, friendlyDbMessage } from "./interface";

/**
 * A handle that acts **as the signed-in user**, so RLS applies.
 * Pass `actorId = null` for the anonymous (signed-out) view.
 */
export async function dbAs(actorId: string | null): Promise<Db> {
  if (dataBackend() === "supabase") {
    if (actorId) {
      // Cookie-bound client: @supabase/ssr already carries the signed-in
      // session, so PostgREST sees the correct JWT and RLS applies normally.
      const { supabaseServerClient } = await import("@/server/auth/session");
      const client = await supabaseServerClient();
      if (!client) throw new Error("Supabase client unavailable");
      return createSupabaseDb(client, { actorId });
    }

    const anon = createClient(env.supabaseUrl!, env.supabaseAnonKey!, {
      auth: { persistSession: false, autoRefreshToken: false },
    });
    return createSupabaseDb(anon, { actorId: null });
  }

  return createLocalDb({ actorId });
}

/**
 * Privileged handle. Used only for operations that genuinely cannot be
 * expressed as a user (seeding, moderation queues that span users, metrics).
 * It is never exposed to the browser and never used to read post authorship.
 */
export async function dbService(): Promise<Db> {
  if (dataBackend() === "supabase") {
    if (!env.supabaseServiceRoleKey) {
      throw new Error(
        "SUPABASE_SERVICE_ROLE_KEY is required for privileged server operations. " +
          "Add it to .env.local (server-only) — never to a NEXT_PUBLIC_ variable.",
      );
    }
    const client = createClient(env.supabaseUrl!, env.supabaseServiceRoleKey, {
      auth: { persistSession: false, autoRefreshToken: false },
    });
    return createSupabaseDb(client, { actorId: null, serviceRole: true });
  }

  return createLocalServiceDb();
}

export async function backendName(): Promise<"supabase" | "local"> {
  return dataBackend();
}
