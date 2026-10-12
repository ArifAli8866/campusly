#!/usr/bin/env node
/**
 * Local Postgres workspace for Campusly.
 *
 * Boots an embedded Postgres (PGlite) in a persistent directory, creates the
 * Supabase-shaped roles + auth schema, then applies every migration in order.
 *
 * Used by:
 *   npm run db:local:reset   -> drop everything, re-apply bootstrap + migrations
 *   npm run db:local:migrate -> apply pending migrations only
 *   npm run db:local:seed    -> load supabase/seed/*
 *   npm run dev              -> the app connects to this database server-side
 *
 * The point of running the *real* migrations here (rather than a mock) is that
 * RLS policies and column grants are exercised identically to Supabase.
 */
import { PGlite } from "@electric-sql/pglite";
import { readFileSync, readdirSync, existsSync, mkdirSync, rmSync } from "node:fs";
import { join, dirname } from "node:path";
import { fileURLToPath } from "node:url";

const __dirname = dirname(fileURLToPath(import.meta.url));
const ROOT = join(__dirname, "..");
const DATA_DIR = join(ROOT, ".data", "pg");
const MIGRATIONS_DIR = join(ROOT, "supabase", "migrations");
const LOCAL_BOOTSTRAP = join(ROOT, "supabase", "local", "0000_bootstrap.sql");

const args = new Set(process.argv.slice(2));
const RESET = args.has("--reset");
const SEED = args.has("--seed");

export async function openDatabase() {
  if (!existsSync(DATA_DIR)) mkdirSync(DATA_DIR, { recursive: true });
  return PGlite.create({ dataDir: DATA_DIR });
}

async function applyFile(db, label, sql) {
  try {
    await db.exec(sql);
    console.log(`  ok   ${label}`);
  } catch (error) {
    console.error(`  FAIL ${label}`);
    console.error(`       ${String(error.message).split("\n")[0]}`);
    if (error.query) {
      const lines = String(error.query).split("\n").slice(0, 3);
      console.error("       --- first lines of the failing statement ---");
      console.error(lines.map((l) => "       " + l.slice(0, 160)).join("\n"));
    }
    throw error;
  }
}

async function migrate(db, { includeBootstrap }) {
  if (includeBootstrap) {
    await applyFile(db, "local/0000_bootstrap.sql", readFileSync(LOCAL_BOOTSTRAP, "utf8"));
  }
  const files = readdirSync(MIGRATIONS_DIR)
    .filter((f) => f.endsWith(".sql"))
    .sort();
  for (const file of files) {
    await applyFile(db, `migrations/${file}`, readFileSync(join(MIGRATIONS_DIR, file), "utf8"));
  }
  return files;
}

async function main() {
  if (RESET) {
    console.log("• dropping local database");
    if (existsSync(DATA_DIR)) rmSync(DATA_DIR, { recursive: true, force: true });
  }

  const db = await openDatabase();
  console.log(`• local postgres at ${DATA_DIR}`);

  const version = await db.query("select version() as v");
  console.log(`• ${String(version.rows[0].v).split(" ").slice(0, 2).join(" ")}`);

  if (RESET) {
    console.log("• applying bootstrap + migrations");
    const files = await migrate(db, { includeBootstrap: true });
    console.log(`• ${files.length} migrations applied`);
  }

  if (SEED) {
    const { runSeed } = await import("./seed.mjs");
    await runSeed(db);
  }

  const counts = await db.query(`
    select
      (select count(*)::int from public.universities) as universities,
      (select count(*)::int from public.campuses)     as campuses,
      (select count(*)::int from public.channels)     as channels,
      (select count(*)::int from public.profiles)     as profiles
  `);
  console.log("• counts", JSON.stringify(counts.rows[0]));

  await db.close();
}

if (import.meta.url === `file://${process.argv[1]}`) {
  main().catch((error) => {
    console.error("\n✖ database setup failed");
    console.error(error);
    process.exit(1);
  });
}
