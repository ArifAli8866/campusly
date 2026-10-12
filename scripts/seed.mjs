#!/usr/bin/env node
/**
 * Loads supabase/seed/seed.sql into the local embedded Postgres.
 *
 * Demo accounts + demo confessions live in a SEPARATE file (demo.sql) so that
 * the production catalogue and throwaway demo content can never be confused.
 * Run with `--demo` to include them.
 */
import { readFileSync, existsSync } from "node:fs";
import { join, dirname } from "node:path";
import { fileURLToPath } from "node:url";

const __dirname = dirname(fileURLToPath(import.meta.url));
const ROOT = join(__dirname, "..");
const SEED_DIR = join(ROOT, "supabase", "seed");

function brief(error) {
  return String(error?.message ?? error).split("\n")[0].slice(0, 300);
}

export async function runSeed(db, { withDemo = process.argv.includes("--demo") } = {}) {
  try {
    return await seed(db, { withDemo });
  } catch (error) {
    console.error("  FAIL seed:", brief(error));
    throw error;
  }
}

async function seed(db, { withDemo }) {
  const seedSql = readFileSync(join(SEED_DIR, "seed.sql"), "utf8");
  await db.exec(seedSql);
  const counts = await db.query(`
    select
      (select count(*)::int from public.universities) as universities,
      (select count(*)::int from public.campuses)     as campuses,
      (select count(*)::int from public.channels)     as channels
  `);
  console.log("  ok   catalogue", JSON.stringify(counts.rows[0]));

  const demoPath = join(SEED_DIR, "demo.sql");
  if (withDemo && existsSync(demoPath)) {
    await db.exec(readFileSync(demoPath, "utf8"));
    const demo = await db.query(`
      select
        (select count(*)::int from public.profiles)  as profiles,
        (select count(*)::int from public.posts)     as posts,
        (select count(*)::int from public.comments)  as comments
    `);
    console.log("  ok   demo data", JSON.stringify(demo.rows[0]));
  }
}

if (import.meta.url === `file://${process.argv[1]}`) {
  const { openDatabase } = await import("./db-local.mjs");
  const db = await openDatabase();
  await runSeed(db);
  await db.close();
}
