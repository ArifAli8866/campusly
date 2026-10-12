/**
 * Local development adapter: embedded Postgres (PGlite) with the app's real
 * migrations, real RLS policies and real column grants.
 *
 * Every statement is executed inside a transaction that first does:
 *
 *     set local role authenticated;
 *     select set_config('request.jwt.claims', '{"sub":"<uuid>"}', true);
 *
 * so that `auth.uid()`, every `create policy`, and every `revoke … (author_id)`
 * behave exactly as they will on Supabase. A mistake in a policy shows up on a
 * developer's laptop, not in production.
 *
 * Server-only. Never import this from a Client Component.
 */
import "server-only";

import { PGlite } from "@electric-sql/pglite";
import { existsSync, mkdirSync } from "node:fs";
import { join } from "node:path";

import { DatabaseError, mapStatus, type Db, type SelectOptions, type Where, type WriteOptions } from "./interface";

/* ------------------------------------------------------------------ singleton */

interface LocalDbGlobal {
  __campuslyPg?: Promise<PGlite>;
  __campuslyMutex?: Promise<unknown>;
}

const globalRef = globalThis as unknown as LocalDbGlobal;

function dataDir(): string {
  return process.env.LOCAL_PG_DIR ?? join(process.cwd(), ".data", "pg");
}

async function getPg(): Promise<PGlite> {
  if (!globalRef.__campuslyPg) {
    const dir = dataDir();
    if (!existsSync(dir)) mkdirSync(dir, { recursive: true });
    globalRef.__campuslyPg = PGlite.create({ dataDir: dir });
  }
  return globalRef.__campuslyPg;
}

/**
 * PGlite is a single connection. Interleaving two transactions on it would
 * corrupt both, so every operation is serialised through this promise chain.
 */
function withLock<T>(fn: () => Promise<T>): Promise<T> {
  const previous = globalRef.__campuslyMutex ?? Promise.resolve();
  const next = previous.then(fn, fn);
  globalRef.__campuslyMutex = next.catch(() => undefined);
  return next;
}

/* ---------------------------------------------------------------- SQL building */

const IDENT = /^[a-z_][a-z0-9_]*$/;
const COLUMN_LIST = /^[a-zA-Z0-9_,\s()*.:]+$/;

function ident(name: string): string {
  if (!IDENT.test(name)) throw new Error(`Unsafe SQL identifier rejected: ${name}`);
  return `"${name}"`;
}

function qualify(table: string): string {
  if (!IDENT.test(table)) throw new Error(`Unsafe table name rejected: ${table}`);
  return `public.${ident(table)}`;
}

function columnsClause(columns?: string): string {
  if (!columns || columns.trim() === "" || columns.trim() === "*") return "*";
  const cleaned = columns
    .split(",")
    .map((c) => c.trim())
    .filter(Boolean);
  for (const c of cleaned) {
    if (!COLUMN_LIST.test(c)) throw new Error(`Unsafe column expression rejected: ${c}`);
  }
  return cleaned.map((c) => (c === "*" ? "*" : c.split(".").map(ident).join("."))).join(", ");
}

function buildWhere(where: Where | undefined, params: unknown[]): string {
  if (!where) return "";
  const clauses: string[] = [];

  for (const [column, value] of Object.entries(where)) {
    if (!IDENT.test(column)) throw new Error(`Unsafe filter column rejected: ${column}`);
    if (value === undefined) continue;

    if (value === null) {
      clauses.push(`${ident(column)} is null`);
    } else if (Array.isArray(value)) {
      params.push(value);
      clauses.push(`${ident(column)} = any($${params.length})`);
    } else {
      params.push(value);
      clauses.push(`${ident(column)} = $${params.length}`);
    }
  }

  return clauses.length ? ` where ${clauses.join(" and ")}` : "";
}

function translateError(error: unknown): never {
  const e = error as { message?: string; code?: string; detail?: string; hint?: string };
  throw new DatabaseError(e?.message ?? "Database error", {
    code: e?.code,
    details: e?.detail ?? null,
    hint: e?.hint ?? null,
    status: mapStatus(e?.code),
  });
}

/* ------------------------------------------------------------------- adapter */

interface Claims {
  sub?: string;
  role: string;
  email?: string;
}

export interface LocalDbOptions {
  /** `null` = anonymous visitor. */
  actorId: string | null;
  /** Bypasses RLS, mirroring the Supabase service-role key. */
  serviceRole?: boolean;
  email?: string;
}

class LocalDb implements Db {
  readonly actorId: string | null;
  readonly isServiceRole: boolean;

  private readonly claims: Claims;

  constructor(options: LocalDbOptions) {
    this.actorId = options.actorId;
    this.isServiceRole = Boolean(options.serviceRole);
    this.claims = this.isServiceRole
      ? { role: "service_role" }
      : options.actorId
        ? { sub: options.actorId, role: "authenticated", email: options.email }
        : { role: "anon" };
  }

  private get role(): string {
    if (this.isServiceRole) return "service_role";
    return this.actorId ? "authenticated" : "anon";
  }

  /** Run `fn` inside a transaction with the caller's identity applied. */
  private async governed<T>(fn: (query: PGlite["query"]) => Promise<T>): Promise<T> {
    const pg = await getPg();
    return withLock(async () => {
      const query = pg.query.bind(pg);
      try {
        await query("begin");
        await query(`set local role ${this.role}`);
        await query("select set_config('request.jwt.claims', $1, true)", [JSON.stringify(this.claims)]);
        const result = await fn(query as PGlite["query"]);
        await query("commit");
        return result;
      } catch (error) {
        try {
          await query("rollback");
        } catch {
          /* the transaction may already be gone */
        }
        translateError(error);
      }
    });
  }

  async rpc<T = unknown>(fn: string, args: Record<string, unknown> = {}): Promise<T[]> {
    if (!IDENT.test(fn)) throw new Error(`Unsafe function name rejected: ${fn}`);

    const names = Object.keys(args).filter((k) => args[k] !== undefined);
    for (const name of names) {
      if (!IDENT.test(name)) throw new Error(`Unsafe argument name rejected: ${name}`);
    }

    const params: unknown[] = [];
    const placeholders = names.map((name) => {
      params.push(args[name]);
      return `${ident(name)} => $${params.length}`;
    });

    const sql = `select * from public.${ident(fn)}(${placeholders.join(", ")})`;
    const result = await this.governed((query) => query(sql, params));
    return (result.rows ?? []) as T[];
  }

  async select<T = Record<string, unknown>>(table: string, options: SelectOptions = {}): Promise<T[]> {
    const params: unknown[] = [];
    let sql = `select ${columnsClause(options.columns)} from ${qualify(table)}`;
    sql += buildWhere(options.where, params);

    if (options.order) {
      const parts = Object.entries(options.order).map(([column, direction]) => {
        if (!IDENT.test(column)) throw new Error(`Unsafe order column rejected: ${column}`);
        return `${ident(column)} ${direction === "desc" ? "desc" : "asc"}`;
      });
      if (parts.length) sql += ` order by ${parts.join(", ")}`;
    }

    if (options.limit !== undefined) {
      params.push(Math.max(0, Math.trunc(options.limit)));
      sql += ` limit $${params.length}`;
    }
    if (options.offset !== undefined) {
      params.push(Math.max(0, Math.trunc(options.offset)));
      sql += ` offset $${params.length}`;
    }

    const result = await this.governed((query) => query(sql, params));
    const rows = (result.rows ?? []) as T[];

    if (options.single && rows.length !== 1) {
      throw new DatabaseError(
        rows.length === 0 ? "No rows found" : "Multiple rows returned",
        { code: "PGRST116", status: 406 },
      );
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
    const rows = Array.isArray(values) ? values : [values];
    if (rows.length === 0) return [];

    const allColumns = Array.from(new Set(rows.flatMap((row) => Object.keys(row))));
    for (const column of allColumns) {
      if (!IDENT.test(column)) throw new Error(`Unsafe column name rejected: ${column}`);
    }

    const params: unknown[] = [];
    const valueGroups = rows.map((row) => {
      const placeholders = allColumns.map((column) => {
        const value = row[column];
        params.push(value === undefined ? null : value);
        return `$${params.length}`;
      });
      return `(${placeholders.join(", ")})`;
    });

    let sql = `insert into ${qualify(table)} (${allColumns.map(ident).join(", ")}) values ${valueGroups.join(", ")}`;
    if (options.returning !== false) sql += ` returning ${columnsClause(options.columns)}`;

    const result = await this.governed((query) => query(sql, params));
    const inserted = (result.rows ?? []) as T[];

    if (options.single && inserted.length !== 1) {
      throw new DatabaseError("Insert did not return exactly one row", { code: "PGRST116", status: 406 });
    }
    return inserted;
  }

  async update<T = Record<string, unknown>>(
    table: string,
    values: Record<string, unknown>,
    where: Where,
    options: WriteOptions = {},
  ): Promise<T[]> {
    const entries = Object.entries(values).filter(([, value]) => value !== undefined);
    if (entries.length === 0) return [];

    const params: unknown[] = [];
    const assignments = entries.map(([column, value]) => {
      if (!IDENT.test(column)) throw new Error(`Unsafe column name rejected: ${column}`);
      params.push(value);
      return `${ident(column)} = $${params.length}`;
    });

    let sql = `update ${qualify(table)} set ${assignments.join(", ")}`;
    sql += buildWhere(where, params);
    if (options.returning !== false) sql += ` returning ${columnsClause(options.columns)}`;

    const result = await this.governed((query) => query(sql, params));
    return (result.rows ?? []) as T[];
  }

  async delete(table: string, where: Where): Promise<number> {
    const params: unknown[] = [];
    let sql = `delete from ${qualify(table)}`;
    sql += buildWhere(where, params);

    const result = await this.governed((query) => query(sql, params));
    return result.affectedRows ?? 0;
  }
}

export function createLocalDb(options: LocalDbOptions): Db {
  return new LocalDb(options);
}

/** Service-role handle for privileged server work (seeding, admin jobs). */
export function createLocalServiceDb(): Db {
  return new LocalDb({ actorId: null, serviceRole: true });
}

export async function closeLocalDb(): Promise<void> {
  const pg = await globalRef.__campuslyPg;
  await pg?.close();
  globalRef.__campuslyPg = undefined;
}
