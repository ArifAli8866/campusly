import "server-only";

import { ZodError } from "zod";

import { DatabaseError, friendlyDbMessage } from "@/lib/db/interface";

export type Failure = { ok: false; error: string; fieldErrors?: Record<string, string[]> };

/**
 * Discriminated on `ok`. `data` is optional rather than conditional-on-T: the
 * conditional form distributes to `never` when T is unresolved, which produced
 * unusable types at every call site.
 */
export type ActionResult<T = undefined> =
  | { ok: true; message?: string; data?: T }
  | Failure;

/**
 * Normalises anything a Server Action can throw into a shape the UI can render.
 *
 * Deliberate choices:
 *  • Zod errors become per-field messages so forms can highlight the input.
 *  • Database permission errors (42501) surface as plain "not allowed" text —
 *    never the raw policy name, which would leak schema detail.
 *  • Unexpected errors are logged server-side and reported generically.
 */
export function toActionResult(error: unknown): Extract<ActionResult, { ok: false }> {
  if (error instanceof ZodError) {
    const fieldErrors: Record<string, string[]> = {};
    for (const issue of error.issues) {
      const key = issue.path.join(".") || "form";
      fieldErrors[key] = [...(fieldErrors[key] ?? []), issue.message];
    }
    const first = error.issues[0]?.message ?? "Please check the form and try again.";
    return { ok: false, error: first, fieldErrors };
  }

  if (error instanceof DatabaseError) {
    if (error.code === "42501") {
      console.warn("[campusly] authorisation failure:", error.message);
    }
    return { ok: false, error: friendlyDbMessage(error) };
  }

  if (error instanceof Error) {
    if (error.message.startsWith("RATE_LIMITED:")) {
      return { ok: false, error: error.message.replace("RATE_LIMITED: ", "") };
    }
    console.error("[campusly] unexpected action error:", error);
    return { ok: false, error: error.message || "Something went wrong. Please try again." };
  }

  console.error("[campusly] unknown action error:", error);
  return { ok: false, error: "Something went wrong. Please try again." };
}

/** Wraps a server action so it can never reject into the client runtime. */
export async function runAction<T>(fn: () => Promise<ActionResult<T>>): Promise<ActionResult<T>> {
  try {
    return await fn();
  } catch (error) {
    return toActionResult(error);
  }
}

export function ok(message?: string): ActionResult<undefined> {
  return message ? { ok: true, message } : { ok: true };
}

export function okWith<T>(data: T, message?: string): ActionResult<T> {
  return message ? { ok: true, data, message } : { ok: true, data };
}

export function fail(error: string, fieldErrors?: Record<string, string[]>): Failure {
  return fieldErrors ? { ok: false, error, fieldErrors } : { ok: false, error };
}
