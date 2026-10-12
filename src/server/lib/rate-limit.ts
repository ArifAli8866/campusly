import "server-only";

import type { Db } from "@/lib/db/interface";

export interface RateLimitRule {
  max: number;
  windowSeconds: number;
  label: string;
}

/**
 * Server-side rate limiting.
 *
 * Implemented in Postgres (`public.rate_limit_check`) rather than in memory, so
 * it is correct across the multiple, short-lived serverless instances Vercel
 * creates — an in-process counter would give every instance its own budget.
 *
 * Throws `RATE_LIMITED: <message>` so the action wrapper can turn it into a
 * friendly toast without leaking internals.
 */
export async function assertRateLimit(db: Db, action: string, rule: RateLimitRule): Promise<void> {
  const allowed = await db
    .rpc<{ rate_limit_check: boolean }>("rate_limit_check", {
      p_action: action,
      p_max: rule.max,
      p_window_seconds: rule.windowSeconds,
    })
    .catch(() => [{ rate_limit_check: true }]);

  if (allowed[0]?.rate_limit_check === false) {
    throw new Error(`RATE_LIMITED: ${rule.label}`);
  }
}

/** Non-throwing variant, used where we only want to degrade gracefully. */
export async function withinRateLimit(db: Db, action: string, rule: RateLimitRule): Promise<boolean> {
  const allowed = await db
    .rpc<{ rate_limit_check: boolean }>("rate_limit_check", {
      p_action: action,
      p_max: rule.max,
      p_window_seconds: rule.windowSeconds,
    })
    .catch(() => [{ rate_limit_check: true }]);

  return allowed[0]?.rate_limit_check !== false;
}
