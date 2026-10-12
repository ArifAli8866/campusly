-- =============================================================================
-- Campusly · LOCAL DEV ONLY · 0000 · Postgres bootstrap
-- =============================================================================
-- Supabase projects already ship the `auth` schema, `auth.uid()` and the
-- `anon` / `authenticated` / `service_role` roles. This file recreates the
-- minimum of that surface so behaviour under test locally is the SAME
-- behaviour in production:
--   * the same roles exist
--   * the same auth.uid() reads the same GUC
--   * the same RLS policies and column grants apply
-- It is executed by `npm run db:local:reset` and is NEVER run on Supabase.
-- =============================================================================

do $$
begin
  if not exists (select 1 from pg_roles where rolname = 'anon') then
    create role anon nologin noinherit;
  end if;
  if not exists (select 1 from pg_roles where rolname = 'authenticated') then
    create role authenticated nologin noinherit;
  end if;
  if not exists (select 1 from pg_roles where rolname = 'service_role') then
    create role service_role nologin noinherit bypassrls;
  end if;
  if not exists (select 1 from pg_roles where rolname = 'supabase_auth_admin') then
    create role supabase_auth_admin nologin noinherit;
  end if;
end $$;

create schema if not exists auth;

-- Mirrors Supabase's definition: reads the JWT claims GUC set per transaction.
create or replace function auth.uid()
returns uuid
language sql
stable
as $$
  select coalesce(
    nullif(current_setting('request.jwt.claim.sub', true), ''),
    nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub'
  )::uuid;
$$;

create or replace function auth.role()
returns text
language sql
stable
as $$
  select coalesce(
    nullif(current_setting('request.jwt.claim.role', true), ''),
    nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role'
  );
$$;

create or replace function auth.email()
returns text
language sql
stable
as $$
  select coalesce(
    nullif(current_setting('request.jwt.claim.email', true), ''),
    nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'email'
  );
$$;

-- Minimal stand-in for the Supabase-managed users table so that the
-- on_auth_user_created trigger (migration 0002) can be exercised locally.
create table if not exists auth.users (
  id                 uuid primary key default gen_random_uuid(),
  email              text unique,
  encrypted_password text,
  email_confirmed_at timestamptz,
  raw_user_meta_data jsonb not null default '{}'::jsonb,
  created_at         timestamptz not null default now(),
  updated_at         timestamptz not null default now()
);

-- Locally we store bcrypt-ish hashes in encrypted_password; the app talks to a
-- local auth adapter that verifies them. See src/server/auth/local-provider.ts
create table if not exists auth.sessions (
  id           uuid primary key default gen_random_uuid(),
  user_id      uuid not null references auth.users (id) on delete cascade,
  token_hash   text not null unique,
  created_at   timestamptz not null default now(),
  expires_at   timestamptz not null,
  user_agent   text
);

create index if not exists sessions_user_idx on auth.sessions (user_id);

grant usage on schema auth to anon, authenticated, service_role;
grant execute on function auth.uid() to anon, authenticated, service_role;
grant execute on function auth.role() to anon, authenticated, service_role;
grant execute on function auth.email() to anon, authenticated, service_role;
grant select on auth.users to service_role;
grant select, insert, update, delete on auth.sessions to service_role;

-- Default privileges so that objects created by the migrations are usable by
-- the local runtime roles without a second grant pass. Migration 0003 then
-- narrows `anon`/`authenticated` down to the exact column set it wants; the
-- service role is what mirrors Supabase's blanket `service_role` grants.
alter default privileges in schema public grant all on tables to service_role;
alter default privileges in schema public grant all on sequences to service_role;
alter default privileges in schema public grant execute on functions to service_role;

-- Media served by the app in local dev comes from the filesystem adapter, but
-- we keep a table so that the "storage.objects" shape is familiar in logs.
create table if not exists public.local_media (
  id         uuid primary key default gen_random_uuid(),
  bucket_id  text not null,
  name       text not null,
  mime_type  text not null,
  byte_size  integer not null,
  checksum   text,
  created_at timestamptz not null default now(),
  unique (bucket_id, name)
);

-- Password reset tokens (local mode only; Supabase Auth owns this in production).
create table if not exists public.password_resets (
  id         uuid primary key default gen_random_uuid(),
  user_id    uuid not null references auth.users (id) on delete cascade,
  token_hash text not null unique,
  expires_at timestamptz not null,
  used_at    timestamptz,
  created_at timestamptz not null default now()
);

create index if not exists password_resets_user_idx on public.password_resets (user_id);
