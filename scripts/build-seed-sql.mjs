#!/usr/bin/env node
/**
 * Generates supabase/seed/seed.sql from supabase/seed/universities.json.
 *
 * One generated file is used by BOTH environments:
 *   • locally, scripts/seed.mjs pipes it into the embedded Postgres
 *   • on Supabase, paste it into the SQL editor (or `supabase db reset`)
 *
 * Everything is idempotent: re-running it updates names/aliases and never
 * duplicates a university, campus or channel.
 */
import { readFileSync, writeFileSync } from "node:fs";
import { join, dirname } from "node:path";
import { fileURLToPath } from "node:url";

const __dirname = dirname(fileURLToPath(import.meta.url));
const ROOT = join(__dirname, "..");
const SEED_DIR = join(ROOT, "supabase", "seed");

const q = (value) => {
  if (value === null || value === undefined) return "null";
  return `'${String(value).replace(/'/g, "''")}'`;
};
const qArr = (values) =>
  values && values.length
    ? `array[${values.map((v) => q(v)).join(", ")}]::text[]`
    : `'{}'::text[]`;

const DESCRIPTION_TEMPLATES = {
  technology:
    "Engineering, computing and applied-science programmes. Members share course advice, lab notes and campus news.",
  business:
    "Business, management and finance programmes. Members compare programmes, internships and campus life.",
  general:
    "A student community for this campus — announcements, questions and everyday campus conversation.",
};

function describe(record) {
  const n = record.name.toLowerCase();
  if (/engineering|technology|technical|computer|science|polytechnic|textile|space|aviation/.test(n)) {
    return `${record.name}${record.abbreviation ? ` (${record.abbreviation})` : ""} is an engineering and applied-sciences institution in ${record.city ?? "Pakistan"}. ${DESCRIPTION_TEMPLATES.technology}`;
  }
  if (/business|management|economic|commerce|account|banking/.test(n)) {
    return `${record.name}${record.abbreviation ? ` (${record.abbreviation})` : ""} is a business and management institution in ${record.city ?? "Pakistan"}. ${DESCRIPTION_TEMPLATES.business}`;
  }
  return `${record.name}${record.abbreviation ? ` (${record.abbreviation})` : ""}${record.city ? ` is located in ${record.city}, ${record.province}.` : " is in Pakistan."} ${DESCRIPTION_TEMPLATES.general}`;
}

const GUIDELINES = `1. Be decent. Disagree with ideas, not with people.
2. No doxxing — never post a real name, phone number, address, CNIC or screenshot of private chats.
3. No harassment, hate speech, threats or targeted bullying.
4. Confessions about specific people must not be identifiable.
5. No exam-paper leaks, admission fraud or academic-dishonesty services.
6. Reports are reviewed by moderators; repeat offenders lose access.`;

function build() {
  const records = JSON.parse(readFileSync(join(SEED_DIR, "universities.json"), "utf8"));

  const lines = [];
  lines.push("-- =============================================================================");
  lines.push("-- Campusly · GENERATED FILE — do not edit by hand.");
  lines.push("-- Regenerate with: npm run seed:build");
  lines.push(`-- Source: ${records.length} institutions, ${records.reduce((n, r) => n + r.campuses.length, 0)} campuses`);
  lines.push("-- =============================================================================");
  lines.push("");
  lines.push("begin;");
  lines.push("");

  // ---- universities -------------------------------------------------------
  lines.push("-- 1. Institutions ------------------------------------------------------------");
  for (const r of records) {
    lines.push(`insert into public.universities
  (name, normalized_name, slug, abbreviation, aliases, description, city, province, status, is_active, is_featured)
values (
  ${q(r.name)},
  lower(regexp_replace(${q(r.name)}, '[^a-zA-Z0-9]+', ' ', 'g')),
  ${q(r.slug)},
  ${q(r.abbreviation)},
  ${qArr(r.aliases && r.aliases.length ? r.aliases : [r.name])},
  ${q(describe(r))},
  ${q(r.city)},
  ${q(r.province)},
  ${q(r.status)}::public.university_status,
  ${r.is_active ? "true" : "false"},
  ${r.is_featured ? "true" : "false"}
)
on conflict (normalized_name) do update set
  name = excluded.name,
  slug = excluded.slug,
  abbreviation = coalesce(excluded.abbreviation, public.universities.abbreviation),
  aliases = excluded.aliases,
  description = coalesce(public.universities.description, excluded.description),
  city = coalesce(excluded.city, public.universities.city),
  province = coalesce(excluded.province, public.universities.province),
  updated_at = now();`);
  }

  // ---- campuses -----------------------------------------------------------
  lines.push("");
  lines.push("-- 2. Campuses ----------------------------------------------------------------");
  for (const r of records) {
    for (const c of r.campuses) {
      lines.push(`insert into public.campuses (university_id, name, slug, city, province, is_main, is_active)
select u.id, ${q(c.name)}, ${q(c.slug)}, ${q(c.city)}, ${q(c.province)}, ${c.name === "Main Campus" ? "true" : "false"}, ${r.is_active ? "true" : "false"}
from public.universities u where u.slug = ${q(r.slug)}
on conflict (university_id, lower(name)) do update set
  city = coalesce(excluded.city, public.campuses.city),
  province = coalesce(excluded.province, public.campuses.province),
  updated_at = now();`);
    }
  }

  // ---- channels (one per campus) -----------------------------------------
  lines.push("");
  lines.push("-- 3. One community channel per campus ---------------------------------------");
  lines.push(`insert into public.channels (university_id, campus_id, slug, name, description, guidelines, banner_url, posting_policy, is_active)
select
  u.id,
  c.id,
  -- stable, shareable slug: <university-slug>-<campus-slug-tail>
  case
    when c.name = 'Main Campus' then u.slug
    else u.slug || '-' || regexp_replace(lower(c.name), '[^a-z0-9]+', '-', 'g')
  end,
  u.name || case when c.name = 'Main Campus' then '' else ' · ' || c.name end,
  coalesce(c.city, u.city, 'Pakistan') || ' · ' || u.name ||
    case when c.name = 'Main Campus' then '' else ' (' || c.name || ')' end,
  ${q(GUIDELINES)},
  coalesce(u.banner_url, null),
  'members',
  c.is_active
from public.campuses c
join public.universities u on u.id = c.university_id
on conflict (campus_id) do update set
  name = excluded.name,
  description = excluded.description,
  guidelines = excluded.guidelines,
  is_active = excluded.is_active,
  updated_at = now();`);

  lines.push("");
  lines.push("commit;");
  lines.push("");

  writeFileSync(join(SEED_DIR, "seed.sql"), lines.join("\n") + "\n", "utf8");

  const campusCount = records.reduce((n, r) => n + r.campuses.length, 0);
  console.log(`generated supabase/seed/seed.sql`);
  console.log(`  universities: ${records.length}`);
  console.log(`  campuses    : ${campusCount}`);
  console.log(`  channels    : ${campusCount}`);
  console.log(`  active      : ${records.filter((r) => r.is_active).length}`);
}

build();
