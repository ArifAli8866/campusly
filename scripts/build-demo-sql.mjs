#!/usr/bin/env node
/**
 * Generates supabase/seed/demo.sql — throwaway demo content for local dev.
 *
 * Split out from seed.sql on purpose:
 *   • seed.sql   = the real university/campus/channel catalogue (safe anywhere)
 *   • demo.sql   = fake students, fake confessions, fake polls. Never run this
 *                  against a deployment you intend to keep.
 *
 * Every id is derived from a stable string, so the file is idempotent and can
 * be re-applied without creating duplicates.
 */
import { createHash, randomBytes, scryptSync } from "node:crypto";
import { mkdirSync, writeFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const __dirname = dirname(fileURLToPath(import.meta.url));
const SEED_DIR = join(__dirname, "..", "supabase", "seed");

/** Deterministic uuid from a label, so re-running the seed is a no-op. */
function uid(label) {
  const h = createHash("sha1").update(`campusly:${label}`).digest("hex");
  return `${h.slice(0, 8)}-${h.slice(8, 12)}-5${h.slice(13, 16)}-a${h.slice(17, 20)}-${h.slice(20, 32)}`;
}

const q = (v) => (v === null || v === undefined ? "null" : `'${String(v).replace(/'/g, "''")}'`);
const qArr = (v) => (v?.length ? `array[${v.map(q).join(", ")}]::text[]` : `'{}'::text[]`);
const bool = (v) => (v ? "true" : "false");

/** Matches hashPassword() in src/server/auth/session.ts exactly. */
function hashPassword(password) {
  const salt = randomBytes(16);
  const derived = scryptSync(password, salt, 64);
  return `scrypt$${salt.toString("hex")}$${derived.toString("hex")}`;
}

const DEMO_PASSWORD = "Campusly!demo1";

/* --------------------------------------------------------------------- people */

const PEOPLE = [
  { key: "admin", email: "admin@campusly.dev", name: "Hira Admin", role: "admin", uni: "fast-national-university-of-computer-and-emerging-sciences", city: "Peshawar", bio: "Platform administrator. Reaches out from this account only." },
  { key: "mod", email: "mod@campusly.dev", name: "Usman Moderator", role: "moderator", uni: "national-university-of-sciences-and-technology", city: "Islamabad", bio: "Volunteer moderator for the Islamabad campuses." },

  { key: "ayesha", email: "ayesha@campusly.dev", name: "Ayesha Khan", uni: "fast-national-university-of-computer-and-emerging-sciences", city: "Peshawar", bio: "4th semester CS. Football on Fridays, C++ at 3am.", programme: "BS Computer Science", dept: "Faculty of Computing", semester: "4th semester", year: 2027, interests: ["study-groups", "coding", "sports", "food"] },
  { key: "bilal", email: "bilal@campusly.dev", name: "Bilal Afridi", uni: "fast-national-university-of-computer-and-emerging-sciences", city: "Peshawar", bio: "Electrical engineering, robotics society.", programme: "BS Electrical Engineering", dept: "Faculty of Engineering", semester: "6th semester", year: 2026, interests: ["coding", "research"] },
  { key: "hammadt", email: "hammad@campusly.dev", name: "Hammad Tariq", uni: "fast-national-university-of-computer-and-emerging-sciences", city: "Islamabad", bio: "Transfer student. Ask me about the hostel mess, I have opinions.", programme: "BS Software Engineering", dept: "Faculty of Computing", semester: "3rd semester", year: 2028, interests: ["sports", "music", "food"] },
  { key: "zainab", email: "zainab@campusly.dev", name: "Zainab Riaz", uni: "fast-national-university-of-computer-and-emerging-sciences", city: "Lahore", bio: "Design lead at the campus tech society.", programme: "BS Computer Science", dept: "Faculty of Computing", semester: "8th semester", year: 2026, interests: ["art", "coding", "entrepreneurship"] },
  { key: "nida", email: "nida@campusly.dev", name: "Nida Farooq", uni: "national-university-of-sciences-and-technology", city: "Islamabad", bio: "Materials engineering. Lab hours are my whole personality.", programme: "BE Materials Engineering", dept: "School of Chemical and Materials Engineering", semester: "5th semester", year: 2027, interests: ["research", "books"] },
  { key: "talha", email: "talha@campusly.dev", name: "Talha Mehmood", uni: "national-university-of-sciences-and-technology", city: "Islamabad", bio: "Final year, job hunting, sleep optional.", programme: "BS Computer Science", dept: "School of Electrical Engineering and Computer Science", semester: "8th semester", year: 2026, interests: ["careers", "coding", "study-groups"] },
  { key: "iqra", email: "iqra@campusly.dev", name: "Iqra Noor", uni: "university-of-engineering-and-technology-peshawar", city: "Peshawar", bio: "Civil engineering. Field survey survivor.", programme: "BSc Civil Engineering", dept: "Department of Civil Engineering", semester: "7th semester", year: 2026, interests: ["research", "sports"] },
  { key: "waleed", email: "waleed@campusly.dev", name: "Waleed Gul", uni: "university-of-engineering-and-technology-peshawar", city: "Peshawar", bio: "Mechanical. Car guy, broke student.", programme: "BSc Mechanical Engineering", dept: "Department of Mechanical Engineering", semester: "2nd semester", year: 2029, interests: ["sports", "food", "music"] },
  { key: "maryam", email: "maryam@campusly.dev", name: "Maryam Sheikh", uni: "lahore-university-of-management-sciences", city: "Lahore", bio: "Economics and a permanent readings backlog.", programme: "BA Economics", dept: "Department of Economics", semester: "5th semester", year: 2027, interests: ["entrepreneurship", "books", "careers"] },
  { key: "osama", email: "osama@campusly.dev", name: "Osama Javed", uni: "lahore-university-of-management-sciences", city: "Lahore", bio: "Case competitions, coffee, very little sleep.", programme: "BSc Accounting and Finance", dept: "Suleman Dawood School of Business", semester: "6th semester", year: 2027, interests: ["entrepreneurship", "careers", "sports"] },
  { key: "sana", email: "sana@campusly.dev", name: "Sana Rahim", uni: "institute-of-business-administration", city: "Karachi", bio: "Marketing major, campus media.", programme: "BBA", dept: "Department of Marketing", semester: "4th semester", year: 2028, interests: ["art", "entrepreneurship", "music"] },
  { key: "fahad", email: "fahad@campusly.dev", name: "Fahad Zaidi", uni: "institute-of-business-administration", city: "Karachi", bio: "Finance. Yes, I have a spreadsheet for that.", programme: "BBA", dept: "Department of Finance", semester: "7th semester", year: 2026, interests: ["careers", "research"] },
  { key: "anaya", email: "anaya@campusly.dev", name: "Anaya Yousaf", uni: "quaid-i-azam-university", city: "Islamabad", bio: "Biotechnology. Mostly in the lab.", programme: "BS Biotechnology", dept: "Department of Biotechnology", semester: "3rd semester", year: 2028, interests: ["research", "books", "study-groups"] },
  { key: "hamza", email: "hamza@campusly.dev", name: "Hamza Iqbal", uni: "comsats-university-islamabad", city: "Islamabad", bio: "CS. Building things nobody asked for.", programme: "BS Computer Science", dept: "Department of Computer Science", semester: "5th semester", year: 2027, interests: ["coding", "entrepreneurship"] },
  { key: "rida", email: "rida@campusly.dev", name: "Rida Aslam", uni: "ned-university-of-engineering-and-technology", city: "Karachi", bio: "Electrical. Robotics club, soldering burns included.", programme: "BE Electrical Engineering", dept: "Department of Electrical Engineering", semester: "6th semester", year: 2027, interests: ["coding", "sports", "research"] },
  { key: "kabir", email: "kabir@campusly.dev", name: "Kabir Shah", uni: "ghulam-ishaq-khan-institute-of-engineering-sciences-and-technology", city: "Swabi", bio: "GIKI, top of a hill, no signal.", programme: "BS Mechanical Engineering", dept: "Faculty of Mechanical Engineering", semester: "4th semester", year: 2028, interests: ["sports", "music", "coding"] },
  { key: "mehak", email: "mehak@campusly.dev", name: "Mehak Butt", uni: "university-of-engineering-and-technology-lahore", city: "Lahore", bio: "Industrial and manufacturing engineering.", programme: "BSc Industrial and Manufacturing Engineering", dept: "Department of Industrial and Manufacturing Engineering", semester: "2nd semester", year: 2029, interests: ["books", "art", "food"] },
  { key: "arsalan", email: "arsalan@campusly.dev", name: "Arsalan Baig", uni: "bahria-university", city: "Islamabad", bio: "Cybersecurity student. Please do not send me your passwords.", programme: "BS Cyber Security", dept: "Department of Computer Science", semester: "5th semester", year: 2027, interests: ["coding", "careers", "research"] },
];


/* --------------------------------------------------------------------- posts */

const POSTS = [
  { by: "ayesha", anon: true, uni: "fast-national-university-of-computer-and-emerging-sciences", city: "Peshawar", category: "complaints" },
  { by: "ayesha", anon: false, uni: "fast-national-university-of-computer-and-emerging-sciences", city: "Peshawar", category: "advice" },
  { by: "bilal", anon: true, uni: "fast-national-university-of-computer-and-emerging-sciences", city: "Peshawar", category: "general" },
  { by: "hammadt", anon: true, uni: "fast-national-university-of-computer-and-emerging-sciences", city: "Islamabad", category: "complaints" },
  { by: "hammadt", anon: false, uni: "fast-national-university-of-computer-and-emerging-sciences", city: "Islamabad", category: "advice" },
  { by: "zainab", anon: true, uni: "fast-national-university-of-computer-and-emerging-sciences", city: "Lahore", category: "general" },
  { by: "nida", anon: false, uni: "national-university-of-sciences-and-technology", city: "Islamabad", category: "career" },
  { by: "talha", anon: true, uni: "national-university-of-sciences-and-technology", city: "Islamabad", category: "academics" },
  { by: "talha", anon: false, uni: "national-university-of-sciences-and-technology", city: "Islamabad", category: "advice" },
  { by: "iqra", anon: true, uni: "university-of-engineering-and-technology-peshawar", city: "Peshawar", category: "campus_life" },
  { by: "waleed", anon: false, uni: "university-of-engineering-and-technology-peshawar", city: "Peshawar", category: "complaints" },
  { by: "maryam", anon: true, uni: "lahore-university-of-management-sciences", city: "Lahore", category: "campus_life" },
  { by: "osama", anon: false, uni: "lahore-university-of-management-sciences", city: "Lahore", category: "career" },
  { by: "sana", anon: true, uni: "institute-of-business-administration", city: "Karachi", category: "complaints" },
  { by: "fahad", anon: false, uni: "institute-of-business-administration", city: "Karachi", category: "general" },
  { by: "anaya", anon: true, uni: "quaid-i-azam-university", city: "Islamabad", category: "advice" },
  { by: "hamza", anon: false, uni: "comsats-university-islamabad", city: "Islamabad", category: "advice" },
  { by: "rida", anon: true, uni: "ned-university-of-engineering-and-technology", city: "Karachi", category: "complaints" },
  { by: "kabir", anon: false, uni: "ghulam-ishaq-khan-institute-of-engineering-sciences-and-technology", city: "Swabi", category: "career" },
  { by: "mehak", anon: true, uni: "university-of-engineering-and-technology-lahore", city: "Lahore", category: "memes" },
  { by: "arsalan", anon: false, uni: "bahria-university", city: "Islamabad", category: "advice" },
  { by: "ayesha", anon: true, uni: "fast-national-university-of-computer-and-emerging-sciences", city: "Peshawar", category: "advice" },
  { by: "hammadt", anon: true, uni: "fast-national-university-of-computer-and-emerging-sciences", city: "Islamabad", category: "exams" },
  { by: "nida", anon: true, uni: "national-university-of-sciences-and-technology", city: "Islamabad", category: "advice" },
  { by: "osama", anon: true, uni: "lahore-university-of-management-sciences", city: "Lahore", category: "exams" },
];

/* ------------------------------------------------------------------- helpers */

const out = [];
const line = (s = "") => out.push(s);

function insert(table, columns, rows, conflict) {
  if (rows.length === 0) return;
  line(`insert into public.${table} (${columns.join(", ")}) values`);
  rows.forEach((row, index) => {
    line(`  (${row.join(", ")})${index === rows.length - 1 ? "" : ","}`);
  });
  line(conflict ? `on conflict ${conflict} do nothing;` : ";");
  line();
}

/* ---------------------------------------------------------------------- main */

function build() {
  const passwordHash = hashPassword(DEMO_PASSWORD);

  line("-- =============================================================================");
  line("-- Demo content — LOCAL DEVELOPMENT ONLY.");
  line("-- Fake students, fake confessions. Do not load this into a real deployment.");
  line("-- Generated by scripts/build-demo-sql.mjs — edit that file, not this one.");
  line("--");
  line(`-- Every demo account uses the password:  ${DEMO_PASSWORD}`);
  line("-- =============================================================================");
  line("begin;");
  line();

  /* ---------------------------------------------------------------- auth users */
  line("-- 1. Auth users (the same rows Supabase Auth would create) ---------------");
  const userRows = PEOPLE.map((person) => [
    q(uid(`user:${person.key}`)),
    q(person.email),
    q(passwordHash),
    "now()",
    `${q(JSON.stringify({ full_name: person.name }))}::jsonb`,
  ]);

  line("insert into auth.users (id, email, encrypted_password, email_confirmed_at, raw_user_meta_data)");
  line("select v.id, v.email, v.encrypted_password, v.email_confirmed_at, v.raw_user_meta_data");
  line("from (values");
  userRows.forEach((row, index) =>
    line(`  (${row[0]}::uuid, ${row[1]}, ${row[2]}, ${row[3]}::timestamptz, ${row[4]})${index === userRows.length - 1 ? "" : ","}`),
  );
  line(") as v(id, email, encrypted_password, email_confirmed_at, raw_user_meta_data)");
  line("where not exists (");
  line("  select 1 from auth.users u where u.id = v.id or u.email = v.email");
  line(")");
  line("on conflict (id) do nothing;");
  line();
  line("-- Profiles are created by the on_auth_user_created trigger. Fill in the rest.");
  line();

  /* ------------------------------------------------------------------ profiles */
  const profileRows = PEOPLE.map((person) => [
    q(uid(`user:${person.key}`)),
    q(person.name),
    q(person.bio ?? null),
    q(person.programme ?? null),
    q(person.dept ?? null),
    q(person.semester ?? null),
    person.year ?? "null",
    qArr(person.interests ?? []),
    "true",
    "4",
  ]);

  line("update public.profiles as p set");
  line("  display_name    = v.display_name,");
  line("  bio             = v.bio,");
  line("  degree_program  = v.programme,");
  line("  department      = v.department,");
  line("  semester        = v.semester,");
  line("  graduation_year = v.year,");
  line("  interests       = v.interests,");
  line("  onboarding_completed = true,");
  line("  onboarding_step = 4");
  line("from (values");
  profileRows.forEach((row, index) => {
    // row order: id, display_name, bio, programme, dept, semester, year, interests
    line(`  (${row[0]}::uuid, ${row[1]}, ${row[2]}, ${row[3]}, ${row[4]}, ${row[5]}, ${row[6]}::int, ${row[7]})${index === profileRows.length - 1 ? "" : ","}`);
  });
  line(") as v(id, display_name, bio, programme, department, semester, year, interests)");
  line("where p.id = v.id;");
  line();

  /* ------------------------------------------------------- university + campus */
  line("-- 2. Attach each demo student to a real university + campus ----------------");
  const attachRows = PEOPLE.filter((p) => p.uni).map(
    (person, index, all) =>
      `  (${q(uid(`user:${person.key}`))}::uuid, ${q(person.uni)}, ${q(person.city)})${index === all.length - 1 ? "" : ","}`,
  );

  line("update public.profiles as p set");
  line("  university_id = u.id,");
  line("  campus_id     = c.id,");
  line("  country       = 'Pakistan'");
  line("from (values");
  attachRows.forEach((row) => line(row));
  line(") as v(id, uni_slug, campus_city)");
  line("join public.universities u on u.slug = v.uni_slug");
  line("join public.campuses c on c.university_id = u.id and c.city = v.campus_city");
  line("where p.id = v.id;");
  line();

  /* ------------------------------------------------------------------- roles */
  line("-- 3. Roles ---------------------------------------------------------------");
  const roleRows = PEOPLE.filter((p) => p.role).map((p) => [q(uid(`user:${p.key}`)), q(p.role)]);
  insert("user_roles", ["user_id", "role"], roleRows, "(user_id)");

  /* -------------------------------------------------------------- memberships */
  line("-- 4. Channel memberships (one per campus channel) -------------------------");
  const memberRows = PEOPLE.filter((p) => p.uni).map(
    (person, index, all) =>
      `  (${q(uid(`user:${person.key}`))}::uuid, ${q(person.uni)}, ${q(person.city)})${index === all.length - 1 ? "" : ","}`,
  );

  line("insert into public.channel_members (user_id, channel_id, university_id)");
  line("select v.id, ch.id, u.id");
  line("from (values");
  memberRows.forEach((row) => line(row));
  line(") as v(id, uni_slug, campus_city)");
  line("join public.universities u on u.slug = v.uni_slug");
  line("join public.campuses c on c.university_id = u.id and c.city = v.campus_city");
  line("join public.channels ch on ch.campus_id = c.id");
  line("on conflict (user_id, channel_id) do nothing;");
  line();

  line("-- Students may join campuses they do not attend; the model allows many.");
  const crossRows = CROSS_MEMBERSHIPS.map(
    (row, index, all) =>
      `  (${q(uid(`user:${row[0]}`))}::uuid, ${q(row[1])}, ${q(row[2])})${index === all.length - 1 ? "" : ","}`,
  );
  line("insert into public.channel_members (user_id, channel_id, university_id)");
  line("select v.id, ch.id, u.id");
  line("from (values");
  crossRows.forEach((row) => line(row));
  line(") as v(id, uni_slug, campus_city)");
  line("join public.universities u on u.slug = v.uni_slug");
  line("join public.campuses c on c.university_id = u.id and c.city = v.campus_city");
  line("join public.channels ch on ch.campus_id = c.id");
  line("on conflict (user_id, channel_id) do nothing;");
  line();

  /* ------------------------------------------------------------------- posts */
  line("-- 5. Confessions and public posts ----------------------------------------");
  line("-- Bodies are deliberately mundane. Nothing here names a real person.");
  line("insert into public.posts (id, channel_id, author_id, body, is_anonymous, category, created_at)");
  line("select v.id, ch.id, v.author_id, v.body, v.is_anonymous, v.category::public.post_category, now() - (v.age_hours || ' hours')::interval");
  line("from (values");
  const postRows = POSTS.map((post, index) => {
    const person = PEOPLE.find((p) => p.key === post.by);
    const id = uid(`post:${index}`);
    const body = BODIES[index];
    const age = AGE_HOURS[index];
    return `  (${q(id)}::uuid, ${q(uid(`user:${person.key}`))}::uuid, ${q(body)}, ${bool(post.anon)}, ${q(post.category)}, ${age}, ${q(post.uni)}, ${q(post.city)})${index === POSTS.length - 1 ? "" : ","}`;
  });
  postRows.forEach((row) => line(row));
  line(") as v(id, author_id, body, is_anonymous, category, age_hours, uni_slug, campus_city)");
  line("join public.universities u on u.slug = v.uni_slug");
  line("join public.campuses c on c.university_id = u.id and c.city = v.campus_city");
  line("join public.channels ch on ch.campus_id = c.id");
  line("on conflict (id) do nothing;");
  line();

  /* ---------------------------------------------------------------- reactions */
  line("-- 6. Likes, comments and saves ------------------------------------------");
  line("insert into public.post_likes (post_id, user_id)");
  line("select v.post_id, v.user_id");
  line("from (values");
  const likeValues = [];
  POSTS.forEach((post, postIndex) => {
    const postId = uid(`post:${postIndex}`);
    // Deterministic spread of likes so counts are stable and plausible.
    PEOPLE.forEach((person, personIndex) => {
      if ((postIndex * 7 + personIndex * 3) % 4 !== 0) return;
      if (person.key === post.by) return;
      likeValues.push(`  (${q(postId)}::uuid, ${q(uid(`user:${person.key}`))}::uuid)`);
    });
  });
  likeValues.forEach((row, index) => line(`${row}${index === likeValues.length - 1 ? "" : ","}`));
  line(") as v(post_id, user_id)");
  line("join public.posts p on p.id = v.post_id");
  line("on conflict (post_id, user_id) do nothing;");
  line();

  line("insert into public.comments (id, post_id, author_id, body, is_anonymous, created_at)");
  line("select v.id, v.post_id, v.author_id, v.body, v.is_anonymous, now() - (v.age_minutes || ' minutes')::interval");
  line("from (values");
  const commentRows = [];
  COMMENT_PLAN.forEach((plan, index) => {
    const person = PEOPLE.find((p) => p.key === plan.by);
    commentRows.push(
      `  (${q(uid(`comment:${index}`))}::uuid, ${q(uid(`post:${plan.post}`))}::uuid, ${q(uid(`user:${person.key}`))}::uuid, ${q(plan.body)}, ${bool(plan.anon)}, ${plan.age})`,
    );
  });
  commentRows.forEach((row, index) => line(`${row}${index === commentRows.length - 1 ? "" : ","}`));
  line(") as v(id, post_id, author_id, body, is_anonymous, age_minutes)");
  line("join public.posts p on p.id = v.post_id");
  line("on conflict (id) do nothing;");
  line();

  line("insert into public.saved_posts (user_id, post_id, created_at)");
  line("select v.user_id, v.post_id, now()");
  line("from (values");
  const savedRows = [
    ["ayesha", 7, "nida"],
    ["ayesha", 12, "maryam"],
    ["talha", 22, "osama"],
  ].map(([key, postIndex], index, all) =>
    `  (${q(uid(`user:${key}`))}::uuid, ${q(uid(`post:${postIndex}`))}::uuid)${index === all.length - 1 ? "" : ","}`,
  );
  savedRows.forEach((row) => line(row));
  line(") as v(user_id, post_id)");
  line("join public.posts p on p.id = v.post_id");
  line("on conflict (user_id, post_id) do nothing;");
  line();

  line("-- Drafts: private to their owner until published.");
  line("insert into public.drafts (id, user_id, channel_id, body, is_anonymous, updated_at)");
  line("select v.id, v.author_id, ch.id, v.body, true, now()");
  line("from (values");
  const draftRows = [
    ["ayesha", "fast-nuces-peshawar", "Midterms week survival guide — does anyone actually finish the DB assignment on time?"],
    ["talha", "nust-islamabad", "Draft: honest review of the fourth semester workload. Needs a conclusion."],
  ].map(([key, slug, body], i, all) =>
    `  (${q(uid(`draft:${i}`))}::uuid, ${q(uid(`user:${key}`))}::uuid, ${q(body)}, ${q(slug)})${i === all.length - 1 ? "" : ","}`,
  );
  draftRows.forEach((row) => line(row));
  line(") as v(id, author_id, body, channel_slug)");
  line("join public.channels ch on ch.slug = v.channel_slug");
  line("on conflict (id) do nothing;");
  line();

  /* -------------------------------------------------------------------- polls */
  line("-- 7. A poll: a real one, with real votes, inside a real post ---------------");
  line(`insert into public.polls (id, post_id, question, allow_multiple, closes_at)`);
  line(`select ${q(uid("poll:1"))}::uuid, p.id, 'How is everyone coping with the new timetable?', false, now() + interval '6 days'`);
  line(`from public.posts p where p.id = ${q(uid("post:21"))}::uuid`);
  line("on conflict (post_id) do nothing;");
  line();
  line("insert into public.poll_options (id, poll_id, label, position)");
  line("values");
  line(`  (${q(uid("poll:1:0"))}::uuid, ${q(uid("poll:1"))}::uuid, 'Genuinely fine', 0),`);
  line(`  (${q(uid("poll:1:1"))}::uuid, ${q(uid("poll:1"))}::uuid, 'Surviving on chai', 1),`);
  line(`  (${q(uid("poll:1:2"))}::uuid, ${q(uid("poll:1"))}::uuid, 'Openly not okay', 2),`);
  line(`  (${q(uid("poll:1:3"))}::uuid, ${q(uid("poll:1"))}::uuid, 'I stopped reading the timetable', 3)`);
  line("on conflict (id) do nothing;");
  line();
  line("insert into public.poll_votes (poll_id, option_id, user_id)");
  line("values");
  const voteRows = [
    ["bilal", 1], ["hammadt", 1], ["zainab", 3], ["nida", 1], ["talha", 2], ["iqra", 1],
    ["waleed", 3], ["maryam", 0], ["osama", 1], ["sana", 2], ["fahad", 1], ["anaya", 2], ["hamza", 1],
  ].map(([key, option], index, all) =>
    `  (${q(uid("poll:1"))}::uuid, ${q(uid(`poll:1:${option}`))}::uuid, ${q(uid(`user:${key}`))}::uuid)${index === all.length - 1 ? "" : ","}`,
  );
  voteRows.forEach((row) => line(row));
  line("on conflict (poll_id, option_id, user_id) do nothing;");
  line();

  /* ------------------------------------------------------------------ reports */
  line("-- 8. Two open reports so the moderation queue is not empty ----------------");
  line("insert into public.reports (id, reporter_id, target_type, target_id, reason, description, target_snapshot, status, created_at)");
  line("select v.id, v.reporter_id, v.target_type::public.report_target, v.target_id, v.reason::public.report_reason, v.description, v.snapshot::jsonb, 'open', now() - (v.age_hours || ' hours')::interval");
  line("from (values");
  const reportRows = [
    `  (${q(uid("report:1"))}::uuid, ${q(uid("user:talha"))}::uuid, 'post', ${q(uid("post:4"))}::uuid, 'harassment', 'Names a specific hostel room and a person. Please review.', '{"body":"[snapshot withheld from this seed file]"}', 6)`,
    `  (${q(uid("report:2"))}::uuid, ${q(uid("user:mehak"))}::uuid, 'comment', ${q(uid("comment:6"))}::uuid, 'spam', 'Repeated advertising for a paid service.', '{"body":"[snapshot withheld from this seed file]"}', 2)`,
  ];
  reportRows.forEach((row, index) => line(`${row}${index === reportRows.length - 1 ? "" : ","}`));
  line(") as v(id, reporter_id, target_type, target_id, reason, description, snapshot, age_hours)");
  line("where exists (select 1 from public.posts p where p.id = v.target_id)");
  line("   or exists (select 1 from public.comments cm where cm.id = v.target_id)");
  line("on conflict (id) do nothing;");
  line();

  line("commit;");
  line();
  line("-- Summary ------------------------------------------------------------------");
  line("do $$");
  line("declare r record;");
  line("begin");
  line("  select count(*) as profiles, 0 as posts into r from public.profiles;");
  line("  raise notice 'demo: % profiles', r.profiles;");
  line("end $$;");

  mkdirSync(SEED_DIR, { recursive: true });
  writeFileSync(join(SEED_DIR, "demo.sql"), out.join("\n"), "utf8");
  console.log(`  ok   wrote supabase/seed/demo.sql (${out.length} lines, ${PEOPLE.length} demo accounts)`);
}

/* ------------------------------------------------------------------ content */

const BODIES = [
  "To the person who returned my lost ID card to the front desk last week: I do not know who you are and I probably never will, but I hope both sides of your pillow are cold tonight. Small kindness, big week.",
  "Genuine question for seniors: is the fourth semester actually harder, or does everyone just say that to scare us? Trying to plan my society commitments and I would rather know now.",
  "Our section has a two-person group project and one of us has done every single line of code. I am the other one. I have learned more from watching them work than from the entire course so far, and I am not sure whether to feel grateful or guilty.",
  "The hostel mess served the same daal for eleven days straight. Eleven. I am not asking for biryani. I am asking for variety. A rotation. Anything.",
  "Anyone else find that the 8am lecture has a completely different attendance crowd than the 11am? It is like two different universities sharing one building.",
  "I came into this university convinced I was going to change my field after the first semester. Two years later I am the person helping juniors survive the same course. It does get better, and it gets better faster than you expect.",
  "Reminder: scholarship and financial-aid applications for the next cycle close at the end of this month. The office has extended walk-in hours on weekdays. Bring your previous transcript and your income documents — they will not accept photocopies of photocopies.",
  "There is a lecturer here who marks assignments at 2am and still replies to emails at 6am. I do not know how. I do not want to know how. I just want to say thank you, because I have never once waited more than a day for a reply.",
  "Has anyone taken the machine learning elective without the prerequisite? Timeline says I need the maths course first but I already did something very similar at A-levels. Wondering if the department will waive it.",
  "The power went out in the middle of our lab practical and half the class immediately started studying for the other subject by phone torch. Something about that moment felt enormously Pakistani and I mean that as a compliment.",
  "Our workshop has a broken lathe that three batches have now reported and nobody has fixed. Tagging the department in case a society member knows who to actually email.",
  "I have been at this university for three years and I only found out last week that the library basement has a quiet reading room. Three years. If you are new: it exists, it is empty, it is yours.",
  "Case competition season is starting and every team needs one person who can make a deck look decent. That person is always the same person. If you are that person, charge for it.",
  "The mess queue at 8pm is a social experiment and I am the control group. Whoever decided dinner should start at the same time as the evening class ending deserves a very long conversation.",
  "Took the wrong bus home on Wednesday, ended up forty minutes in the wrong direction, and met a final-year student from my own department who gave me the most useful advice about internships I have heard all year. Best mistake.",
  "I have started leaving my notes on the shared drive with my initials in the filename. No idea if anyone uses them. If you do, no need to say anything, just pass it on to the next batch.",
  "Standing offer: if you are stuck on the data structures assignment and cannot afford a tutor, comment here and I will go through it with you in the library. No payment, no strings, I have been stuck before.",
  "The escalator in the engineering block has been out of service since the start of the semester and there is now a genuine traffic jam on the stairs between classes. This is a real accessibility problem, not just an inconvenience.",
  "Something nobody tells you about engineering: you will spend more time writing documentation and arguing in meetings than doing the maths you actually came here for. Practice explaining your work plainly. It is the higher-leverage skill.",
  "Whoever runs the campus radio at lunchtime, your playlist on Tuesday was the only reason I stayed on campus instead of going home. Thank you.",
  "Quick poll for everyone who lives on campus — genuinely curious how the new timetable is landing now that we are a few weeks in.",
  "Second attempt: does anyone have last year's question bank for the discrete maths final? I will happily trade for my summarised notes from the whole course.",
  "A note to first years that I wish someone had given me: your first semester marks are not a verdict on your ability. They are a verdict on how well you had learned to study at that exact moment. That is a fixable thing.",
  "If you are in the economics department and quietly wondering whether you should have done computer science instead: the answer is that you can do both, badly, for two years, and then decide. Ask me how I know.",
  "Reminder that the department will not accept late submissions for any reason they consider discretionary. Back up your work. Email yourself the draft. I am saying this from experience and the experience was expensive.",
];

const AGE_HOURS = [2, 4, 7, 11, 14, 19, 26, 31, 38, 45, 52, 60, 68, 76, 84, 93, 102, 118, 130, 145, 160, 178, 196, 214, 240];

/** (user key, university slug, campus city) — communities outside the home campus. */
const CROSS_MEMBERSHIPS = [
  ["ayesha", "fast-national-university-of-computer-and-emerging-sciences", "Islamabad"],
  ["ayesha", "university-of-engineering-and-technology-peshawar", "Peshawar"],
  ["bilal", "fast-national-university-of-computer-and-emerging-sciences", "Lahore"],
  ["hammadt", "fast-national-university-of-computer-and-emerging-sciences", "Peshawar"],
  ["zainab", "fast-national-university-of-computer-and-emerging-sciences", "Islamabad"],
  ["talha", "fast-national-university-of-computer-and-emerging-sciences", "Islamabad"],
  ["nida", "quaid-i-azam-university", "Islamabad"],
  ["maryam", "national-university-of-sciences-and-technology", "Islamabad"],
  ["hamza", "national-university-of-sciences-and-technology", "Islamabad"],
  ["arsalan", "national-university-of-sciences-and-technology", "Islamabad"],
  ["mehak", "university-of-engineering-and-technology-peshawar", "Peshawar"],
  ["kabir", "comsats-university-islamabad", "Islamabad"],
];

const COMMENT_PLAN = [
  { post: 0, by: "bilal", anon: false, age: 95, body: "This is the nicest thing I have read on here." },
  { post: 0, by: "hamza", anon: true, age: 88, body: "Same thing happened to me in September. There are more decent people here than it feels like." },
  { post: 1, by: "talha", anon: false, age: 200, body: "Fourth semester is the first one where the courses stop being independent. It is not harder content, it is more of it, all at once." },
  { post: 1, by: "nida", anon: false, age: 190, body: "Agreed with the above. Pick two societies maximum for that semester. You can go back to three afterwards." },
  { post: 1, by: "ayesha", anon: false, age: 176, body: "This is genuinely useful, thank you both." },
  { post: 3, by: "waleed", anon: true, age: 240, body: "Eleven days is nothing. Ask the 2023 batch about the rice month." },
  { post: 3, by: "sana", anon: false, age: 230, body: "You can raise it through the hostel committee and they do actually respond. Two people is enough to file a complaint." },
  { post: 5, by: "maryam", anon: false, age: 400, body: "Second-year me needed this post and I did not have it. Saving it for the next person who needs it." },
  { post: 6, by: "anaya", anon: false, age: 320, body: "Adding that the office accepts a signed statement from a guardian if the income documents are in someone else's name. Saved me a whole trip." },
  { post: 8, by: "arsalan", anon: false, age: 300, body: "I did it last year. The department waived it after I showed the course outline and asked politely. Go to the office in person." },
  { post: 8, by: "hamza", anon: true, age: 288, body: "Also worth asking if you can sit the first quiz and have it count as the prerequisite check. That is how mine was handled." },
];

build();
