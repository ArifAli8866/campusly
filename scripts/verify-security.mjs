#!/usr/bin/env node
/**
 * Security smoke test for the anonymous-identity model.
 *
 * Runs against the local embedded Postgres using the real migrations, real
 * column grants and real RLS. Every check runs as the `authenticated` role with
 * a specific JWT subject, exactly as PostgREST would.
 *
 * Usage: node scripts/verify-security.mjs
 */
import { PGlite } from "@electric-sql/pglite";
import { readFileSync, readdirSync } from "node:fs";
import { join, dirname } from "node:path";
import { fileURLToPath } from "node:url";

const ROOT = join(dirname(fileURLToPath(import.meta.url)), "..");

let passed = 0;
let failed = 0;

function check(label, condition, detail = "") {
  if (condition) {
    passed += 1;
    console.log(`  PASS  ${label}`);
  } else {
    failed += 1;
    console.log(`  FAIL  ${label}${detail ? ` — ${detail}` : ""}`);
  }
}

async function asActor(pg, actorId, sql, params = []) {
  await pg.query("begin");
  try {
    if (actorId === "__service__") {
      await pg.query("set local role service_role");
    } else if (actorId === null) {
      await pg.query("set local role anon");
      await pg.query("select set_config('request.jwt.claims', $1, true)", [JSON.stringify({ role: "anon" })]);
    } else {
      await pg.query("set local role authenticated");
      await pg.query("select set_config('request.jwt.claims', $1, true)", [
        JSON.stringify({ sub: actorId, role: "authenticated" }),
      ]);
    }
    const result = await pg.query(sql, params);
    await pg.query("commit");
    return { ok: true, rows: result.rows ?? [] };
  } catch (error) {
    await pg.query("rollback").catch(() => undefined);
    return { ok: false, error };
  }
}

const pg = await PGlite.create();

// ---- schema + seed ---------------------------------------------------------
await pg.exec(readFileSync(join(ROOT, "supabase/local/0000_bootstrap.sql"), "utf8"));
for (const file of readdirSync(join(ROOT, "supabase/migrations")).filter((f) => f.endsWith(".sql")).sort()) {
  await pg.exec(readFileSync(join(ROOT, "supabase/migrations", file), "utf8"));
}
await pg.exec(readFileSync(join(ROOT, "supabase/seed/seed.sql"), "utf8"));

// ---- fixtures --------------------------------------------------------------
const ALICE = "11111111-1111-4111-8111-111111111111"; // author of an anonymous confession
const BOB = "22222222-2222-4222-8222-222222222222"; // ordinary reader
const MOD = "33333333-3333-4333-8333-333333333333"; // moderator
const ADMIN = "44444444-4444-4444-8444-444444444444"; // administrator

await pg.exec(`
insert into auth.users (id, email, email_confirmed_at, raw_user_meta_data) values
  ('${ALICE}', 'alice@example.edu.pk', now(), '{"full_name":"Alice Khan"}'),
  ('${BOB}',   'bob@example.edu.pk',   now(), '{"full_name":"Bob Ahmed"}'),
  ('${MOD}',   'mod@example.edu.pk',   now(), '{"full_name":"Moderator One"}'),
  ('${ADMIN}', 'admin@example.edu.pk', now(), '{"full_name":"Administrator"}');

update public.user_roles set role = 'moderator' where user_id = '${MOD}';
update public.user_roles set role = 'admin'     where user_id = '${ADMIN}';

update public.profiles set university_id = (select id from public.universities where slug = 'fast-national-university-of-computer-and-emerging-sciences'),
                            campus_id     = (select id from public.campuses where slug = 'fast-national-university-of-computer-and-emerging-sciences-islamabad-campus')
where id = '${ALICE}';

insert into public.channel_members (user_id, channel_id, university_id)
select '${ALICE}', c.id, c.university_id
from public.channels c where c.slug = 'fast-national-university-of-computer-and-emerging-sciences-islamabad-campus';

insert into public.channel_members (user_id, channel_id, university_id)
select '${BOB}', c.id, c.university_id
from public.channels c where c.slug = 'fast-national-university-of-computer-and-emerging-sciences-islamabad-campus';

insert into public.posts (id, channel_id, university_id, author_id, body, is_anonymous)
select 'aaaaaaaa-0000-4000-8000-000000000001', c.id, c.university_id, '${ALICE}',
       'Anonymous confession: the library AC has been broken for three weeks.', true
from public.channels c where c.slug = 'fast-national-university-of-computer-and-emerging-sciences-islamabad-campus';

insert into public.posts (id, channel_id, university_id, author_id, body, is_anonymous)
select 'aaaaaaaa-0000-4000-8000-000000000002', c.id, c.university_id, '${ALICE}',
       'Public post: looking for a study group for Discrete Structures.', false
from public.channels c where c.slug = 'fast-national-university-of-computer-and-emerging-sciences-islamabad-campus';
`);

const ANON_POST = "aaaaaaaa-0000-4000-8000-000000000001";
const PUBLIC_POST = "aaaaaaaa-0000-4000-8000-000000000002";

console.log("\n── Anonymous identity ─────────────────────────────────────────");

// 1. A client cannot even select the author_id column.
{
  const r = await asActor(pg, BOB, `select author_id from public.posts where id = $1`, [ANON_POST]);
  check(
    "client cannot select posts.author_id directly (column privilege revoked)",
    !r.ok && String(r.error?.message ?? "").includes("permission denied"),
    r.ok ? "query succeeded — identity column is exposed!" : undefined,
  );
}

// 2. feed_posts never hands out the author of an anonymous post.
{
  const r = await asActor(pg, BOB, `select id, is_anonymous, author_id, author_username, author_display_name from public.feed_posts(null,'latest',null,null,0,50)`);
  const anon = r.rows?.find((row) => row.id === ANON_POST);
  check("feed_posts returns the anonymous post to a reader", Boolean(anon));
  check("feed_posts nulls author_id for a non-author", anon?.author_id === null, `got ${anon?.author_id}`);
  check("feed_posts nulls author_username", anon?.author_username === null);
  check("feed_posts nulls author_display_name", anon?.author_display_name === null);

  const pub = r.rows?.find((row) => row.id === PUBLIC_POST);
  check("feed_posts still attributes public posts", pub?.author_username === "alice", `got ${pub?.author_username}`);
}

// 3. The author still sees and can manage their own confession.
{
  const r = await asActor(pg, ALICE, `select id, author_id, viewer_can_manage from public.feed_posts(null,'latest',null,null,0,50)`);
  const anon = r.rows?.find((row) => row.id === ANON_POST);
  check("author can retrieve their own anonymous post's author_id", anon?.author_id === ALICE);
  check("author gets viewer_can_manage on their anonymous post", anon?.viewer_can_manage === true);
}

// 4. get_post behaves the same on the share/preview path.
{
  const r = await asActor(pg, BOB, `select * from public.get_post($1)`, [ANON_POST]);
  check("get_post hides author from a reader", r.rows?.[0]?.author_id === null);
  const r2 = await asActor(pg, ALICE, `select * from public.get_post($1)`, [ANON_POST]);
  check("get_post shows author to the author", r2.rows?.[0]?.author_id === ALICE);
}

// 5. Search results must not leak authorship.
{
  const r = await asActor(pg, BOB, `select public.search_all('library', 'posts', 10, 0) as s`);
  const posts = r.rows?.[0]?.s?.posts ?? [];
  const hit = posts.find((p) => p.id === ANON_POST);
  check("search_all finds the confession", Boolean(hit));
  check("search_all carries no author fields for an anonymous post", hit && hit.author_username === null && hit.author_display_name === null);
}

// 6. Notifications must not name the anonymous author.
{
  await asActor(pg, "55555555-5555-4555-8555-555555555555", `select 1`); // noop
  await pg.exec(`
    insert into auth.users (id, email, email_confirmed_at) values
      ('55555555-5555-4555-8555-555555555555', 'carol@example.edu.pk', now());
  `);

  await asActor(
    pg,
    "__service__",
    `insert into public.notifications (recipient_id, actor_id, type, post_id)
     values ('55555555-5555-4555-8555-555555555555', '${ALICE}', 'mention_post', $1)`,
    [ANON_POST],
  );

  const r = await asActor(pg, "55555555-5555-4555-8555-555555555555", `select * from public.notification_feed(20,0)`);
  const n = r.rows?.[0];
  check("notification row exists for the recipient", Boolean(n));
  check("notification actor_id is null for an anonymous source", n?.actor_id === null, `got ${n?.actor_id}`);
  check("notification actor_username is null too", n?.actor_username === null);
  check("notification post excerpt is withheld", n?.post_excerpt === null);
}

// 7. Only an audited moderator function discloses identity.
{
  const asBob = await asActor(pg, BOB, `select * from public.deanonymise_post($1, 'test justification text')`, [ANON_POST]);
  check("non-moderator cannot call deanonymise_post", !asBob.ok && String(asBob.error?.message).includes("Moderator"));

  const noReason = await asActor(pg, MOD, `select * from public.deanonymise_post($1, '')`, [ANON_POST]);
  check("deanonymise_post requires a justification", !noReason.ok);

  const asMod = await asActor(pg, MOD, `select * from public.deanonymise_post($1, 'Harassment investigation #4417')`, [ANON_POST]);
  check("moderator can disclose with justification", asMod.ok && asMod.rows?.[0]?.author_id === ALICE);

  const audit = await asActor(pg, ADMIN, `select count(*)::int as c from public.audit_log where event = 'anonymous_identity_disclosed'`);
  check("disclosure is written to the audit log", (audit.rows?.[0]?.c ?? 0) >= 1, `count=${audit.rows?.[0]?.c}`);
}

console.log("\n── Profile, roles and authorisation ──────────────────────────");

// 8. Public profile counts must not let maths reveal authorship.
{
  const r = await asActor(pg, BOB, `select * from public.profile_public('alice')`);
  check("public_post_count excludes anonymous confessions", r.rows?.[0]?.public_post_count === 1, `got ${r.rows?.[0]?.public_post_count}`);
}

// 9. A user cannot promote themselves.
{
  const r = await asActor(pg, BOB, `update public.user_roles set role = 'admin' where user_id = '${BOB}'`);
  const stillUser = await asActor(pg, BOB, `select role from public.user_roles where user_id = '${BOB}'`);
  check(
    "self-promotion to admin is refused",
    !r.ok || (stillUser.rows?.[0]?.role ?? "user") !== "admin",
    `role is now ${stillUser.rows?.[0]?.role}`,
  );
}

// 10. platform_stats is admin-only.
{
  const asBob = await asActor(pg, BOB, `select public.platform_stats() as s`);
  check("non-admin cannot read platform_stats", !asBob.ok && String(asBob.error?.message).includes("Administrator"));
  const asAdmin = await asActor(pg, ADMIN, `select public.platform_stats() as s`);
  check("admin can read platform_stats", asAdmin.ok);
}

// 11. Other people's notifications and reports are unreadable.
{
  const r = await asActor(pg, BOB, `select count(*)::int as c from public.notifications`);
  check("a user sees none of another user's notifications", (r.rows?.[0]?.c ?? -1) === 0, `got ${r.rows?.[0]?.c}`);
}

// 12. Suspended users cannot publish.
{
  await pg.exec(`update public.profiles set is_suspended = true where id = '${BOB}'`);
  const asBob = await asActor(
    pg,
    BOB,
    `insert into public.posts (channel_id, university_id, author_id, body, is_anonymous)
     select c.id, c.university_id, '${BOB}', 'suspended user post', true from public.channels c limit 1`,
  );
  check("suspended user cannot publish", !asBob.ok);
  await pg.exec(`update public.profiles set is_suspended = false where id = '${BOB}'`);
}

// 13. Duplicate membership is impossible at the database layer.
{
  const first = await asActor(
    pg,
    BOB,
    `insert into public.channel_members (user_id, channel_id, university_id)
     select '${BOB}', c.id, c.university_id from public.channels c
     where c.slug = 'national-university-of-sciences-and-technology-islamabad-campus'
     on conflict do nothing`,
  );
  check("first join succeeds", first.ok);
  const second = await asActor(
    pg,
    BOB,
    `insert into public.channel_members (user_id, channel_id, university_id)
     select '${BOB}', c.id, c.university_id from public.channels c
     where c.slug = 'national-university-of-sciences-and-technology-islamabad-campus'`,
  );
  check("second join is rejected by the unique index", !second.ok && String(second.error?.code) === "23505");

  const count = await asActor(pg, BOB, `select count(*)::int as c from public.channel_members where user_id = '${BOB}'`);
  check("exactly one membership row exists", count.rows?.[0]?.c === 2, `got ${count.rows?.[0]?.c} (1 FAST + 1 NUST)`);
}

// 14. Duplicate likes are impossible and counts stay accurate.
{
  await asActor(pg, BOB, `insert into public.post_likes (post_id, user_id) values ($1, '${BOB}')`, [PUBLIC_POST]);
  const dup = await asActor(pg, BOB, `insert into public.post_likes (post_id, user_id) values ($1, '${BOB}')`, [PUBLIC_POST]);
  check("double like is rejected", !dup.ok && String(dup.error?.code) === "23505");

  const counts = await asActor(pg, BOB, `select like_count from public.posts where id = $1`, [PUBLIC_POST]);
  check("like_count reflects exactly one like", counts.rows?.[0]?.like_count === 1, `got ${counts.rows?.[0]?.like_count}`);

  await asActor(pg, BOB, `delete from public.post_likes where post_id = $1 and user_id = '${BOB}'`, [PUBLIC_POST]);
  const after = await asActor(pg, BOB, `select like_count from public.posts where id = $1`, [PUBLIC_POST]);
  check("unlike decrements the counter", after.rows?.[0]?.like_count === 0);
}

// 15. Posts from suspended authors disappear from the feed.
{
  await pg.exec(`update public.profiles set is_suspended = true where id = '${ALICE}'`);
  const r = await asActor(pg, BOB, `select id from public.feed_posts(null,'latest',null,null,0,50)`);
  const visible = r.rows?.some((row) => row.id === ANON_POST);
  check("suspended author's posts are hidden from the feed", !visible);
  await pg.exec(`update public.profiles set is_suspended = false where id = '${ALICE}'`);
}

// 16. Blocked users cannot see each other.
{
  await asActor(pg, BOB, `insert into public.blocked_users (blocker_id, blocked_user_id) values ('${BOB}', '${ALICE}')`);
  const r = await asActor(pg, BOB, `select id from public.feed_posts(null,'latest',null,null,0,50)`);
  check("blocking hides the other user's posts", !r.rows?.some((row) => row.id === PUBLIC_POST));
  await asActor(pg, BOB, `delete from public.blocked_users where blocker_id = '${BOB}'`);
}

// 17. Anonymous read access is limited to published, non-deleted content.
{
  const r = await asActor(pg, null, `select count(*)::int as c from public.feed_posts(null,'latest',null,null,0,50)`);
  check("signed-out visitor can read the public feed", r.ok && (r.rows?.[0]?.c ?? 0) >= 1);
  const t = await asActor(pg, null, `select author_id from public.posts limit 1`);
  check("signed-out visitor cannot select posts.author_id", !t.ok);
}

// 18. Nothing in the app's read API returns a decrypted author for anon posts.
{
  const r = await asActor(pg, BOB, `select * from public.weekly_highlights(20)`);
  const anyLeak = (r.rows ?? []).some((row) => row.is_anonymous && row.author_id !== null);
  check("weekly_highlights never leaks an anonymous author", !anyLeak);
}

console.log(`\n${passed} passed, ${failed} failed\n`);
await pg.close();
process.exit(failed === 0 ? 0 : 1);
