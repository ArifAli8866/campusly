/**
 * Supabase adapter — used whenever NEXT_PUBLIC_SUPABASE_URL is configured.
 *
 * Wraps PostgREST with the same narrow contract as the local adapter. The
 * publication of `author_id` is decided by the database (RPC + column grants),
 * never here, so switching adapters cannot change the privacy behaviour.
 */
import "server-only";

import type { SupabaseClient } from "@supabase/supabase-js";

import { DatabaseError, mapStatus, type Db, type SelectOptions, type Where, type WriteOptions } from "./interface";

/** Loosely typed builder handle: the public Db interface is the typed surface. */
type Builder = {
  select(columns?: string, options?: Record<string, unknown>): Builder;
  insert(values: unknown): Builder;
  update(values: unknown): Builder;
  delete(): Builder;
  eq(column: string, value: unknown): Builder;
  is(column: string, value: null): Builder;
  in(column: string, values: unknown[]): Builder;
  order(column: string, options?: { ascending?: boolean }): Builder;
  range(from: number, to: number): Builder;
  then<T>(onfulfilled?: (value: unknown) => T): Promise<T>;
};

function translate(error: { message: string; code?: string; details?: string; hint?: string } | null): never {
  if (!error) throw new DatabaseError("Unknown database error", { status: 500 });
  throw new DatabaseError(error.message, {
    code: error.code,
    details: error.details ?? null,
    hint: error.hint ?? null,
    status: error.code === "42501" ? 403 : mapStatus(error.code),
  });
}

class SupabaseDb implements Db {
  readonly actorId: string | null;
  readonly isServiceRole: boolean;

  constructor(
    private readonly client: SupabaseClient,
    options: { actorId: string | null; serviceRole?: boolean },
  ) {
    this.actorId = options.actorId;
    this.isServiceRole = Boolean(options.serviceRole);
  }

  async rpc<T = unknown>(fn: string, args: Record<string, unknown> = {}): Promise<T[]> {
    const { data, error } = await this.client.rpc(fn, args);
    if (error) translate(error);
    if (data === null || data === undefined) return [];
    return (Array.isArray(data) ? data : [data]) as T[];
  }

  async select<T = Record<string, unknown>>(table: string, options: SelectOptions = {}): Promise<T[]> {
    let query = this.client.from(table).select(options.columns ?? "*") as unknown as Builder;

    for (const [column, value] of Object.entries(options.where ?? {})) {
      if (value === undefined) continue;
      if (value === null) query = query.is(column, null);
      else if (Array.isArray(value)) query = query.in(column, value as (string | number)[]);
      else query = query.eq(column, value as string | number | boolean);
    }

    for (const [column, direction] of Object.entries(options.order ?? {})) {
      query = query.order(column, { ascending: direction !== "desc" });
    }

    if (options.limit !== undefined) {
      const from = options.offset ?? 0;
      query = query.range(from, from + Math.max(0, options.limit) - 1);
    } else if (options.offset !== undefined) {
      query = query.range(options.offset, options.offset + 999);
    }

    const response = (await query) as { data: unknown; error: { message: string; code?: string; details?: string; hint?: string } | null };
    if (response.error) translate(response.error);
    const rows = ((response.data as unknown[] | null) ?? []) as T[];

    if (options.single && rows.length !== 1) {
      throw new DatabaseError(rows.length === 0 ? "No rows found" : "Multiple rows returned", {
        code: "PGRST116",
        status: 406,
      });
    }

    return rows;
  }

  async selectOne<T = Record<string, unknown>>(table: string, options: SelectOptions = {}): Promise<T | null> {
    const rows = await this.select<T>(table, { ...options, limit: 1 });
    return rows[0] ?? null;
  }

  async insert<T = Record<string, unknown>>(
    table: string,
    values: Record<string, unknown> | Record<string, unknown>[],
    options: WriteOptions = {},
  ): Promise<T[]> {
    const payload = Array.isArray(values) ? values : [values];
    if (payload.length === 0) return [];

    let query = this.client.from(table).insert(payload) as unknown as Builder;
    if (options.returning !== false) query = query.select(options.columns ?? "*");

    const response = (await query) as { data: unknown; error: { message: string; code?: string; details?: string; hint?: string } | null };
    if (response.error) translate(response.error);
    return ((response.data as unknown[] | null) ?? []) as T[];
  }

  async update<T = Record<string, unknown>>(
    table: string,
    values: Record<string, unknown>,
    where: Where,
    options: WriteOptions = {},
  ): Promise<T[]> {
    let query = this.client.from(table).update(values) as unknown as Builder;
    for (const [column, value] of Object.entries(where)) {
      if (value === undefined) continue;
      if (value === null) query = query.is(column, null);
      else if (Array.isArray(value)) query = query.in(column, value as (string | number)[]);
      else query = query.eq(column, value as string | number | boolean);
    }
    if (options.returning !== false) query = query.select(options.columns ?? "*");

    const response = (await query) as { data: unknown; error: { message: string; code?: string; details?: string; hint?: string } | null };
    if (response.error) translate(response.error);
    return ((response.data as unknown[] | null) ?? []) as T[];
  }

  async delete(table: string, where: Where): Promise<number> {
    let query = this.client.from(table).delete() as unknown as Builder;
    for (const [column, value] of Object.entries(where)) {
      if (value === undefined) continue;
      if (value === null) query = query.is(column, null);
      else if (Array.isArray(value)) query = query.in(column, value as (string | number)[]);
      else query = query.eq(column, value as string | number | boolean);
    }

    const response = (await query.select("*", { count: "exact", head: true })) as {
      error: { message: string; code?: string } | null;
      count: number | null;
    };
    if (response.error) translate(response.error);
    return response.count ?? 0;
  }
}

export function createSupabaseDb(
  client: SupabaseClient,
  options: { actorId: string | null; serviceRole?: boolean },
): Db {
  return new SupabaseDb(client, options);
}
