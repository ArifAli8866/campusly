/**
 * The single data-access contract used by the whole app.
 *
 * Two implementations satisfy it:
 *   • ./supabase-db.ts  — PostgREST + Supabase Auth (production / Vercel)
 *   • ./local-db.ts     — embedded Postgres (PGlite) for local dev, which runs
 *                         the real RLS policies under `set local role`
 *
 * Keeping the surface this small is deliberate: it is much harder to leak a
 * private column through a 6-method interface than through a fluent query
 * builder, and both adapters stay small enough to audit.
 */

export type FilterValue = string | number | boolean | null | undefined | string[] | number[];

export interface Where {
  [column: string]: FilterValue;
}

export interface SelectOptions {
  columns?: string;
  where?: Where;
  /** `{ column: 'asc' | 'desc' }` */
  order?: Record<string, "asc" | "desc">;
  limit?: number;
  offset?: number;
  /** Throw if the result set is not exactly one row. */
  single?: boolean;
  /** Return the first row or null instead of an array. */
  maybeSingle?: boolean;
}

export interface WriteOptions {
  columns?: string;
  single?: boolean;
  returning?: boolean;
}

export interface DbError extends Error {
  code?: string;
  details?: string | null;
  hint?: string | null;
  /** HTTP-ish status so callers can branch on 401 / 403 / 409 / 429. */
  status?: number;
}

export interface Db {
  /** Call a Postgres function (the sanctioned read/mutation API). */
  rpc<T = unknown>(fn: string, args?: Record<string, unknown>): Promise<T[]>;

  select<T = Record<string, unknown>>(table: string, options?: SelectOptions): Promise<T[]>;
  selectOne<T = Record<string, unknown>>(table: string, options?: SelectOptions): Promise<T | null>;

  insert<T = Record<string, unknown>>(
    table: string,
    values: Record<string, unknown> | Record<string, unknown>[],
    options?: WriteOptions,
  ): Promise<T[]>;

  update<T = Record<string, unknown>>(
    table: string,
    values: Record<string, unknown>,
    where: Where,
    options?: WriteOptions,
  ): Promise<T[]>;

  delete(table: string, where: Where): Promise<number>;

  /** Identity this handle is acting as. */
  readonly actorId: string | null;
  readonly isServiceRole: boolean;
}

export class DatabaseError extends Error {
  code?: string;
  details?: string | null;
  hint?: string | null;
  status: number;

  constructor(message: string, opts: { code?: string; details?: string | null; hint?: string | null; status?: number } = {}) {
    super(message);
    this.name = "DatabaseError";
    this.code = opts.code;
    this.details = opts.details ?? null;
    this.hint = opts.hint ?? null;
    this.status = opts.status ?? mapStatus(opts.code);
  }
}

export function mapStatus(code?: string): number {
  switch (code) {
    case "42501":
      return 403; // insufficient_privilege — RLS or a revoked column
    case "23505":
      return 409; // unique_violation
    case "23503":
      return 409; // foreign_key_violation
    case "23514":
      return 422; // check_violation
    case "P0002":
      return 404; // no_data_found
    case "22023":
      return 422; // invalid_parameter_value
    case "53400":
    case "429":
      return 429; // rate limited
    default:
      return 400;
  }
}

/** Human-readable message for the most common database rejections. */
export function friendlyDbMessage(error: unknown): string {
  const e = error as DbError;
  if (!e?.code) return e?.message ?? "Something went wrong. Please try again.";

  switch (e.code) {
    case "42501":
      return e.message.includes("permission denied for column")
        ? "That information is not available."
        : "You do not have permission to do that.";
    case "23505":
      return "That already exists.";
    case "23503":
      return "That content is no longer available.";
    case "23514":
      return "Some of those details are not valid.";
    case "P0002":
      return "We could not find that.";
    case "53400":
      return e.message;
    default:
      return e.message;
  }
}
