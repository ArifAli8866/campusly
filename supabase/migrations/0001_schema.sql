-- =============================================================================
-- Campusly · 0001 · Core schema
-- =============================================================================
-- Target: Supabase Postgres 15+ and vanilla Postgres 13+ (local dev via PGlite).
-- Deliberately avoids pgcrypto / citext / pg_trgm so the exact same migration
-- runs locally and on Supabase. `gen_random_uuid()` is core since PG13.
-- =============================================================================

create schema if not exists extensions;

-- -----------------------------------------------------------------------------
-- Enumerated domains
-- -----------------------------------------------------------------------------
do $$ begin
  create type public.app_role as enum ('user', 'moderator', 'admin');
exception when duplicate_object then null; end $$;

do $$ begin
  create type public.profile_visibility as enum ('public', 'university', 'private');
exception when duplicate_object then null; end $$;

do $$ begin
  create type public.institution_type as enum ('public', 'private', 'semi_government', 'military', 'unknown');
exception when duplicate_object then null; end $$;

do $$ begin
  create type public.university_status as enum ('active', 'pending_review', 'merged', 'archived');
exception when duplicate_object then null; end $$;

do $$ begin
  create type public.moderation_status as enum ('published', 'under_review', 'hidden', 'removed');
exception when duplicate_object then null; end $$;

do $$ begin
  create type public.mention_source as enum ('post', 'comment');
exception when duplicate_object then null; end $$;

do $$ begin
  create type public.notification_type as enum (
    'mention_post', 'mention_comment', 'comment_on_post', 'reply_to_comment',
    'post_like', 'comment_like', 'channel_join', 'moderation_action', 'welcome'
  );
exception when duplicate_object then null; end $$;

do $$ begin
  create type public.report_target as enum ('post', 'comment', 'user');
exception when duplicate_object then null; end $$;

do $$ begin
  create type public.report_reason as enum (
    'harassment', 'bullying', 'threats', 'hate_speech', 'impersonation',
    'spam', 'private_information', 'inappropriate_content', 'other'
  );
exception when duplicate_object then null; end $$;

do $$ begin
  create type public.report_status as enum ('open', 'in_review', 'resolved', 'dismissed');
exception when duplicate_object then null; end $$;

do $$ begin
  create type public.moderation_action as enum (
    'content_hidden', 'content_restored', 'content_removed',
    'user_suspended', 'user_reinstated', 'user_warned',
    'report_resolved', 'report_dismissed', 'identity_disclosed'
  );
exception when duplicate_object then null; end $$;

do $$ begin
  create type public.post_category as enum (
    'general', 'campus_life', 'academics', 'exams', 'relationships',
    'memes', 'career', 'complaints', 'advice'
  );
exception when duplicate_object then null; end $$;

-- -----------------------------------------------------------------------------
-- Shared trigger: keep updated_at honest (server time, never client supplied)
-- -----------------------------------------------------------------------------
create or replace function public.tg_touch_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at := now();
  return new;
end;
$$;

-- =============================================================================
-- 1. Institutions
-- =============================================================================

create table if not exists public.universities (
  id              uuid primary key default gen_random_uuid(),
  name            text not null check (char_length(name) between 2 and 200),
  -- normalised_name is what uniqueness + search operate on; keeps
  -- "FAST-NUCES" / "FAST National University..." from existing twice.
  normalized_name text not null,
  slug            text not null,
  abbreviation    text,
  aliases         text[] not null default '{}',
  description     text,
  logo_url        text,
  banner_url      text,
  city            text,
  province        text,
  institution_type public.institution_type not null default 'unknown',
  is_featured     boolean not null default false,
  status          public.university_status not null default 'active',
  is_active       boolean not null default true,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now(),
  constraint universities_slug_format check (slug ~ '^[a-z0-9]+(-[a-z0-9]+)*$'),
  constraint universities_normalized_format check (normalized_name = lower(normalized_name))
);

create unique index if not exists universities_slug_key on public.universities (slug);
create unique index if not exists universities_normalized_key on public.universities (normalized_name);
create index if not exists universities_city_idx on public.universities (lower(city));
create index if not exists universities_province_idx on public.universities (province);
create index if not exists universities_active_idx on public.universities (is_active, status) where is_active;
-- Index expression must be IMMUTABLE: array_to_string() is only STABLE, so
-- aliases live in their own GIN array index (below) and are matched with `&&`
-- / element scans rather than being folded into this tsvector.
create index if not exists universities_search_idx on public.universities
  using gin (to_tsvector('simple', name || ' ' || coalesce(abbreviation, '')));
create index if not exists universities_aliases_idx on public.universities using gin (aliases);

drop trigger if exists universities_touch on public.universities;
create trigger universities_touch before update on public.universities
  for each row execute function public.tg_touch_updated_at();

create table if not exists public.campuses (
  id            uuid primary key default gen_random_uuid(),
  university_id uuid not null references public.universities (id) on delete cascade,
  name          text not null check (char_length(name) between 2 and 160),
  slug          text not null,
  city          text,
  province      text,
  address       text,
  is_main       boolean not null default false,
  is_active     boolean not null default true,
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now(),
  constraint campuses_slug_format check (slug ~ '^[a-z0-9]+(-[a-z0-9]+)*$')
);

create unique index if not exists campuses_slug_key on public.campuses (slug);
create unique index if not exists campuses_uni_name_key on public.campuses (university_id, lower(name));
create index if not exists campuses_university_idx on public.campuses (university_id);
create index if not exists campuses_city_idx on public.campuses (lower(city));

drop trigger if exists campuses_touch on public.campuses;
create trigger campuses_touch before update on public.campuses
  for each row execute function public.tg_touch_updated_at();

-- =============================================================================
-- 2. Channels — one community per campus. Stable, shareable slug.
-- =============================================================================
create table if not exists public.channels (
  id            uuid primary key default gen_random_uuid(),
  university_id uuid not null references public.universities (id) on delete cascade,
  campus_id     uuid not null references public.campuses (id) on delete cascade,
  slug          text not null,
  name          text not null,
  description   text,
  banner_url    text,
  guidelines    text,
  posting_policy text not null default 'members'
    check (posting_policy in ('members', 'anyone_authenticated', 'moderators_only')),
  is_active     boolean not null default true,
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now(),
  constraint channels_slug_format check (slug ~ '^[a-z0-9]+(-[a-z0-9]+)*$')
);

create unique index if not exists channels_slug_key on public.channels (slug);
create unique index if not exists channels_campus_key on public.channels (campus_id);
create index if not exists channels_university_idx on public.channels (university_id);
create index if not exists channels_active_idx on public.channels (is_active) where is_active;

drop trigger if exists channels_touch on public.channels;
create trigger channels_touch before update on public.channels
  for each row execute function public.tg_touch_updated_at();

-- =============================================================================
-- 3. Profiles (1:1 with auth.users)
-- =============================================================================
create table if not exists public.profiles (
  id             uuid primary key,
  username       text not null,
  display_name   text not null check (char_length(display_name) between 1 and 60),
  avatar_url     text,
  banner_url     text,
  bio            text check (char_length(bio) <= 300),
  university_id  uuid references public.universities (id) on delete set null,
  campus_id      uuid references public.campuses (id) on delete set null,
  country        text not null default 'Pakistan',
  degree_program text,
  department     text,
  semester       text,
  graduation_year smallint check (graduation_year between 1950 and 2100),
  interests      text[] not null default '{}',
  profile_visibility public.profile_visibility not null default 'public',
  onboarding_step smallint not null default 0 check (onboarding_step between 0 and 4),
  onboarding_completed boolean not null default false,
  username_changed_at timestamptz,
  is_suspended   boolean not null default false,
  suspended_reason text,
  last_active_at timestamptz not null default now(),
  created_at     timestamptz not null default now(),
  updated_at     timestamptz not null default now(),
  -- usernames are stored lowercase; the unique index makes them race-safe
  constraint profiles_username_format check (username ~ '^[a-z0-9_]{3,24}$'),
  constraint profiles_username_lower check (username = lower(username))
);

create unique index if not exists profiles_username_key on public.profiles (username);
create index if not exists profiles_university_idx on public.profiles (university_id);
create index if not exists profiles_campus_idx on public.profiles (campus_id);
create index if not exists profiles_display_name_idx on public.profiles (lower(display_name));
create index if not exists profiles_search_idx on public.profiles
  using gin (to_tsvector('simple', display_name || ' ' || username || ' ' || coalesce(bio, '')));
create index if not exists profiles_active_idx on public.profiles (last_active_at desc);

drop trigger if exists profiles_touch on public.profiles;
create trigger profiles_touch before update on public.profiles
  for each row execute function public.tg_touch_updated_at();

-- Roles live in their own table: a profile UPDATE can never escalate privileges.
create table if not exists public.user_roles (
  user_id    uuid primary key,
  role       public.app_role not null default 'user',
  granted_by uuid,
  granted_at timestamptz not null default now()
);

create index if not exists user_roles_role_idx on public.user_roles (role) where role <> 'user';

-- =============================================================================
-- 4. Channel membership
-- =============================================================================
create table if not exists public.channel_members (
  id         uuid primary key default gen_random_uuid(),
  user_id    uuid not null references public.profiles (id) on delete cascade,
  channel_id uuid not null references public.channels (id) on delete cascade,
  university_id uuid not null references public.universities (id) on delete cascade,
  role       text not null default 'member' check (role in ('member', 'moderator')),
  is_muted   boolean not null default false,
  joined_at  timestamptz not null default now()
);

-- The uniqueness guarantee that stops duplicate memberships at the DB layer.
create unique index if not exists channel_members_unique_key on public.channel_members (user_id, channel_id);
create index if not exists channel_members_channel_idx on public.channel_members (channel_id, joined_at desc);
create index if not exists channel_members_user_idx on public.channel_members (user_id, joined_at desc);

-- =============================================================================
-- 5. Posts — the confession engine
-- =============================================================================
create table if not exists public.posts (
  id            uuid primary key default gen_random_uuid(),
  channel_id    uuid not null references public.channels (id) on delete cascade,
  university_id uuid not null references public.universities (id) on delete cascade,
  -- PRIVATE. Column-level privileges are revoked for anon/authenticated; the
  -- only sanctioned reader is public.feed_posts() / get_post() (SECURITY DEFINER).
  author_id     uuid not null references public.profiles (id) on delete cascade,
  body          text not null check (char_length(btrim(body)) between 1 and 2000),
  is_anonymous  boolean not null default true,
  category      public.post_category,
  media_path    text,
  media_width   integer,
  media_height  integer,
  link_preview  jsonb,
  moderation_status public.moderation_status not null default 'published',
  like_count     integer not null default 0 check (like_count >= 0),
  comment_count  integer not null default 0 check (comment_count >= 0),
  share_count    integer not null default 0 check (share_count >= 0),
  is_pinned     boolean not null default false,
  edited_at     timestamptz,
  search_vector tsvector generated always as (
                  to_tsvector('simple', coalesce(body, '')) ) stored,
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now(),
  deleted_at    timestamptz
);

create index if not exists posts_channel_latest_idx on public.posts (channel_id, created_at desc, id desc)
  where deleted_at is null and moderation_status = 'published';
create index if not exists posts_author_idx on public.posts (author_id, created_at desc) where deleted_at is null;
create index if not exists posts_search_idx on public.posts using gin (search_vector);
create index if not exists posts_moderation_idx on public.posts (moderation_status) where moderation_status <> 'published';
create index if not exists posts_created_idx on public.posts (created_at desc) where deleted_at is null;

drop trigger if exists posts_touch on public.posts;
create trigger posts_touch before update on public.posts
  for each row execute function public.tg_touch_updated_at();

-- =============================================================================
-- 6. Comments & replies
-- =============================================================================
create table if not exists public.comments (
  id           uuid primary key default gen_random_uuid(),
  post_id      uuid not null references public.posts (id) on delete cascade,
  author_id    uuid not null references public.profiles (id) on delete cascade,
  parent_id    uuid references public.comments (id) on delete cascade,
  root_id      uuid references public.comments (id) on delete cascade,
  depth        smallint not null default 0 check (depth between 0 and 1),
  body         text not null check (char_length(btrim(body)) between 1 and 1500),
  is_anonymous boolean not null default false,
  moderation_status public.moderation_status not null default 'published',
  like_count   integer not null default 0 check (like_count >= 0),
  reply_count  integer not null default 0 check (reply_count >= 0),
  edited_at    timestamptz,
  search_vector tsvector generated always as (
                  to_tsvector('simple', coalesce(body, '')) ) stored,
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now(),
  deleted_at   timestamptz
);

create index if not exists comments_post_idx on public.comments (post_id, created_at asc, id asc)
  where deleted_at is null and moderation_status = 'published';
create index if not exists comments_parent_idx on public.comments (parent_id, created_at asc) where deleted_at is null;
create index if not exists comments_author_idx on public.comments (author_id, created_at desc) where deleted_at is null;
create index if not exists comments_search_idx on public.comments using gin (search_vector);

drop trigger if exists comments_touch on public.comments;
create trigger comments_touch before update on public.comments
  for each row execute function public.tg_touch_updated_at();

-- =============================================================================
-- 7. Reactions
-- =============================================================================
create table if not exists public.post_likes (
  id         uuid primary key default gen_random_uuid(),
  post_id    uuid not null references public.posts (id) on delete cascade,
  user_id    uuid not null references public.profiles (id) on delete cascade,
  created_at timestamptz not null default now()
);

-- Exactly one like per user per post, enforced by the database, not the UI.
create unique index if not exists post_likes_unique_key on public.post_likes (post_id, user_id);
create index if not exists post_likes_user_idx on public.post_likes (user_id, created_at desc);

create table if not exists public.comment_likes (
  id         uuid primary key default gen_random_uuid(),
  comment_id uuid not null references public.comments (id) on delete cascade,
  user_id    uuid not null references public.profiles (id) on delete cascade,
  created_at timestamptz not null default now()
);

create unique index if not exists comment_likes_unique_key on public.comment_likes (comment_id, user_id);

-- =============================================================================
-- 8. Mentions — structured user references, never plain-text matching
-- =============================================================================
create table if not exists public.mentions (
  id                uuid primary key default gen_random_uuid(),
  source_type       public.mention_source not null,
  source_id         uuid not null,
  mentioned_user_id uuid not null references public.profiles (id) on delete cascade,
  created_at        timestamptz not null default now()
);

create unique index if not exists mentions_unique_key
  on public.mentions (source_type, source_id, mentioned_user_id);
create index if not exists mentions_user_idx on public.mentions (mentioned_user_id, created_at desc);
create index if not exists mentions_source_idx on public.mentions (source_type, source_id);

-- =============================================================================
-- 9. Notifications
-- =============================================================================
create table if not exists public.notifications (
  id         uuid primary key default gen_random_uuid(),
  recipient_id uuid not null references public.profiles (id) on delete cascade,
  -- actor_id is NULLed by trigger whenever the source is an anonymous post.
  actor_id   uuid references public.profiles (id) on delete set null,
  type       public.notification_type not null,
  post_id    uuid references public.posts (id) on delete cascade,
  comment_id uuid references public.comments (id) on delete cascade,
  channel_id uuid references public.channels (id) on delete cascade,
  body_preview text,
  is_read    boolean not null default false,
  created_at timestamptz not null default now()
);

create index if not exists notifications_recipient_idx on public.notifications (recipient_id, created_at desc);
create index if not exists notifications_unread_idx on public.notifications (recipient_id) where not is_read;
create unique index if not exists notifications_dedupe_key
  on public.notifications (recipient_id, type, coalesce(post_id, '00000000-0000-0000-0000-000000000000'::uuid),
                           coalesce(comment_id, '00000000-0000-0000-0000-000000000000'::uuid),
                           coalesce(actor_id, '00000000-0000-0000-0000-000000000000'::uuid));

create table if not exists public.notification_preferences (
  user_id            uuid primary key references public.profiles (id) on delete cascade,
  mentions           boolean not null default true,
  comments           boolean not null default true,
  replies            boolean not null default true,
  likes              boolean not null default true,
  channel_activity   boolean not null default false,
  product_updates    boolean not null default true,
  updated_at         timestamptz not null default now()
);

-- =============================================================================
-- 10. Saves, drafts, mutes, blocks
-- =============================================================================
create table if not exists public.saved_posts (
  user_id    uuid not null references public.profiles (id) on delete cascade,
  post_id    uuid not null references public.posts (id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (user_id, post_id)
);

create index if not exists saved_posts_user_idx on public.saved_posts (user_id, created_at desc);

create table if not exists public.drafts (
  id         uuid primary key default gen_random_uuid(),
  user_id    uuid not null references public.profiles (id) on delete cascade,
  channel_id uuid references public.channels (id) on delete set null,
  body       text not null default '' check (char_length(body) <= 2000),
  is_anonymous boolean not null default true,
  category   public.post_category,
  media_path text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists drafts_user_idx on public.drafts (user_id, updated_at desc);

drop trigger if exists drafts_touch on public.drafts;
create trigger drafts_touch before update on public.drafts
  for each row execute function public.tg_touch_updated_at();

create table if not exists public.blocked_users (
  blocker_id    uuid not null references public.profiles (id) on delete cascade,
  blocked_user_id uuid not null references public.profiles (id) on delete cascade,
  created_at    timestamptz not null default now(),
  primary key (blocker_id, blocked_user_id),
  constraint blocked_users_not_self check (blocker_id <> blocked_user_id)
);

create index if not exists blocked_users_blocked_idx on public.blocked_users (blocked_user_id);

create table if not exists public.channel_mutes (
  user_id    uuid not null references public.profiles (id) on delete cascade,
  channel_id uuid not null references public.channels (id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (user_id, channel_id)
);

-- =============================================================================
-- 11. Polls
-- =============================================================================
create table if not exists public.polls (
  id            uuid primary key default gen_random_uuid(),
  post_id       uuid not null unique references public.posts (id) on delete cascade,
  question      text not null check (char_length(btrim(question)) between 2 and 200),
  allow_multiple boolean not null default false,
  anonymous_votes boolean not null default true,
  closes_at     timestamptz,
  created_at    timestamptz not null default now()
);

create table if not exists public.poll_options (
  id         uuid primary key default gen_random_uuid(),
  poll_id    uuid not null references public.polls (id) on delete cascade,
  label      text not null check (char_length(btrim(label)) between 1 and 120),
  position   smallint not null default 0,
  vote_count integer not null default 0 check (vote_count >= 0)
);

create index if not exists poll_options_poll_idx on public.poll_options (poll_id, position);

create table if not exists public.poll_votes (
  id        uuid primary key default gen_random_uuid(),
  poll_id   uuid not null references public.polls (id) on delete cascade,
  option_id uuid not null references public.poll_options (id) on delete cascade,
  user_id   uuid not null references public.profiles (id) on delete cascade,
  created_at timestamptz not null default now()
);

create unique index if not exists poll_votes_unique_key on public.poll_votes (poll_id, option_id, user_id);
create index if not exists poll_votes_poll_user_idx on public.poll_votes (poll_id, user_id);

-- =============================================================================
-- 12. Safety & moderation
-- =============================================================================
create table if not exists public.reports (
  id          uuid primary key default gen_random_uuid(),
  reporter_id uuid not null references public.profiles (id) on delete cascade,
  target_type public.report_target not null,
  target_id   uuid not null,
  -- snapshot so the moderator can review after the target is deleted
  target_snapshot jsonb,
  reason      public.report_reason not null,
  description text check (char_length(description) <= 1000),
  status      public.report_status not null default 'open',
  priority    smallint not null default 0,
  reviewed_by uuid references public.profiles (id) on delete set null,
  reviewed_at timestamptz,
  resolution_note text,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

create unique index if not exists reports_dedupe_key on public.reports (reporter_id, target_type, target_id)
  where status in ('open', 'in_review');
create index if not exists reports_status_idx on public.reports (status, created_at asc);
create index if not exists reports_target_idx on public.reports (target_type, target_id);

drop trigger if exists reports_touch on public.reports;
create trigger reports_touch before update on public.reports
  for each row execute function public.tg_touch_updated_at();

create table if not exists public.moderation_actions (
  id         uuid primary key default gen_random_uuid(),
  moderator_id uuid not null references public.profiles (id) on delete cascade,
  action     public.moderation_action not null,
  target_type public.report_target,
  target_id  uuid,
  report_id  uuid references public.reports (id) on delete set null,
  note       text check (char_length(note) <= 2000),
  metadata   jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

create index if not exists moderation_actions_created_idx on public.moderation_actions (created_at desc);
create index if not exists moderation_actions_target_idx on public.moderation_actions (target_type, target_id);

-- Immutable trail for anything sensitive (role changes, identity disclosure…)
create table if not exists public.audit_log (
  id         bigserial primary key,
  actor_id   uuid,
  actor_role public.app_role,
  event      text not null,
  target_type text,
  target_id  uuid,
  metadata   jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

create index if not exists audit_log_created_idx on public.audit_log (created_at desc);
create index if not exists audit_log_event_idx on public.audit_log (event);

-- Per-user rate limiting, enforced server-side (survives multi-instance Vercel).
create table if not exists public.rate_limit_events (
  id         bigserial primary key,
  user_id    uuid not null,
  action     text not null,
  created_at timestamptz not null default now()
);

create index if not exists rate_limit_lookup_idx on public.rate_limit_events (user_id, action, created_at desc);

-- Recent searches are private to the user and never exposed publicly.
create table if not exists public.search_history (
  id         bigserial primary key,
  user_id    uuid not null references public.profiles (id) on delete cascade,
  query      text not null,
  result_type text not null default 'all',
  created_at timestamptz not null default now()
);

create index if not exists search_history_user_idx on public.search_history (user_id, created_at desc);

create table if not exists public.post_shares (
  id         bigserial primary key,
  post_id    uuid not null references public.posts (id) on delete cascade,
  user_id    uuid references public.profiles (id) on delete set null,
  channel    text not null default 'copy_link',
  created_at timestamptz not null default now()
);

create index if not exists post_shares_post_idx on public.post_shares (post_id);
