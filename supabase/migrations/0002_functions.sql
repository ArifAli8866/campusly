-- =============================================================================
-- Campusly · 0002 · Functions, triggers and the privacy-safe read API
-- =============================================================================
-- Anonymous identity rule enforced here:
--   `posts.author_id` is never returned to anon/authenticated by these
--   functions unless the caller IS the author, or holds moderator/admin role
--   via an audited function. Clients cannot get it from the table either,
--   because 0003 revokes the column privilege.
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Role helpers. SECURITY DEFINER so that user_roles is never world-readable
-- and so RLS on it cannot cause recursive policy evaluation.
-- -----------------------------------------------------------------------------
create or replace function public.current_app_role()
returns public.app_role
language sql
stable
security definer
set search_path = public
as $$
  select coalesce((select role from public.user_roles where user_id = auth.uid()), 'user'::public.app_role);
$$;

create or replace function public.is_moderator()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select public.current_app_role() in ('moderator', 'admin');
$$;

create or replace function public.is_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select public.current_app_role() = 'admin';
$$;

create or replace function public.is_suspended(p_user uuid default auth.uid())
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select coalesce((select is_suspended from public.profiles where id = p_user), false);
$$;

-- -----------------------------------------------------------------------------
-- Rate limiting (server-side, survives horizontal scaling)
-- -----------------------------------------------------------------------------
create or replace function public.rate_limit_check(
  p_action text,
  p_max integer,
  p_window_seconds integer,
  p_user uuid default auth.uid()
)
returns boolean
language plpgsql
security definer
set search_path = public
as $$
declare
  v_count integer;
begin
  if p_user is null then
    return false;
  end if;

  select count(*) into v_count
  from public.rate_limit_events
  where user_id = p_user
    and action = p_action
    and created_at > now() - make_interval(secs => p_window_seconds);

  if v_count >= p_max then
    return false;
  end if;

  insert into public.rate_limit_events (user_id, action) values (p_user, p_action);
  return true;
end;
$$;

-- -----------------------------------------------------------------------------
-- Counter maintenance. Triggers (not client code) keep counts correct, so a
-- racing double-click or a retried request can never skew a count.
-- -----------------------------------------------------------------------------
create or replace function public.tg_post_like_counters()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if tg_op = 'INSERT' then
    update public.posts set like_count = like_count + 1 where id = new.post_id;
    return new;
  elsif tg_op = 'DELETE' then
    update public.posts set like_count = greatest(like_count - 1, 0) where id = old.post_id;
    return old;
  end if;
  return null;
end;
$$;

drop trigger if exists post_likes_counter on public.post_likes;
create trigger post_likes_counter
  after insert or delete on public.post_likes
  for each row execute function public.tg_post_like_counters();

create or replace function public.tg_comment_like_counters()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if tg_op = 'INSERT' then
    update public.comments set like_count = like_count + 1 where id = new.comment_id;
    return new;
  elsif tg_op = 'DELETE' then
    update public.comments set like_count = greatest(like_count - 1, 0) where id = old.comment_id;
    return old;
  end if;
  return null;
end;
$$;

drop trigger if exists comment_likes_counter on public.comment_likes;
create trigger comment_likes_counter
  after insert or delete on public.comment_likes
  for each row execute function public.tg_comment_like_counters();

create or replace function public.tg_comment_counters()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if tg_op = 'INSERT' then
    update public.posts set comment_count = comment_count + 1 where id = new.post_id;
    if new.parent_id is not null then
      update public.comments set reply_count = reply_count + 1 where id = new.parent_id;
    end if;
    return new;
  elsif tg_op = 'DELETE' then
    update public.posts set comment_count = greatest(comment_count - 1, 0) where id = old.post_id;
    if old.parent_id is not null then
      update public.comments set reply_count = greatest(reply_count - 1, 0) where id = old.parent_id;
    end if;
    return old;
  end if;
  return null;
end;
$$;

drop trigger if exists comments_counter on public.comments;
create trigger comments_counter
  after insert or delete on public.comments
  for each row execute function public.tg_comment_counters();

create or replace function public.tg_poll_vote_counters()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if tg_op = 'INSERT' then
    update public.poll_options set vote_count = vote_count + 1 where id = new.option_id;
    return new;
  elsif tg_op = 'DELETE' then
    update public.poll_options set vote_count = greatest(vote_count - 1, 0) where id = old.option_id;
    return old;
  end if;
  return null;
end;
$$;

drop trigger if exists poll_votes_counter on public.poll_votes;
create trigger poll_votes_counter
  after insert or delete on public.poll_votes
  for each row execute function public.tg_poll_vote_counters();

-- Keep comment thread shape consistent: a reply always points at a root comment
-- and never nests deeper than one level.
create or replace function public.tg_comment_thread_shape()
returns trigger
language plpgsql
as $$
declare
  v_parent public.comments;
begin
  if new.parent_id is null then
    new.root_id := null;
    new.depth := 0;
    return new;
  end if;

  select * into v_parent from public.comments where id = new.parent_id;
  if not found then
    raise exception 'Parent comment % does not exist', new.parent_id using errcode = '23503';
  end if;
  if v_parent.post_id <> new.post_id then
    raise exception 'Reply must belong to the same post as its parent';
  end if;

  new.root_id := coalesce(v_parent.root_id, v_parent.id);
  new.depth := 1;
  return new;
end;
$$;

drop trigger if exists comments_thread_shape on public.comments;
create trigger comments_thread_shape
  before insert or update of parent_id on public.comments
  for each row execute function public.tg_comment_thread_shape();

-- -----------------------------------------------------------------------------
-- Account provisioning. `auth.users` exists on Supabase and is created by the
-- local bootstrap, so the same trigger works in both environments.
-- -----------------------------------------------------------------------------
create or replace function public.tg_handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_username text;
  v_base     text;
  v_suffix   integer := 0;
  v_display  text;
begin
  v_display := coalesce(
    nullif(btrim(new.raw_user_meta_data ->> 'full_name'), ''),
    nullif(btrim(new.raw_user_meta_data ->> 'name'), ''),
    split_part(coalesce(new.email, 'student'), '@', 1)
  );

  v_base := regexp_replace(lower(split_part(coalesce(new.email, 'student'), '@', 1)), '[^a-z0-9_]', '', 'g');
  if char_length(v_base) < 3 then
    v_base := 'student';
  end if;
  v_base := left(v_base, 18);
  v_username := v_base;

  while exists (select 1 from public.profiles where username = v_username) loop
    v_suffix := v_suffix + 1;
    v_username := left(v_base, 18) || v_suffix::text;
  end loop;

  insert into public.profiles (id, username, display_name, avatar_url)
  values (
    new.id,
    v_username,
    left(v_display, 60),
    new.raw_user_meta_data ->> 'avatar_url'
  )
  on conflict (id) do nothing;

  insert into public.user_roles (user_id, role) values (new.id, 'user')
  on conflict (user_id) do nothing;

  insert into public.notification_preferences (user_id) values (new.id)
  on conflict (user_id) do nothing;

  return new;
end;
$$;

do $$
begin
  if exists (select 1 from information_schema.tables where table_schema = 'auth' and table_name = 'users') then
    execute 'drop trigger if exists on_auth_user_created on auth.users';
    execute 'create trigger on_auth_user_created after insert on auth.users
             for each row execute function public.tg_handle_new_user()';
  end if;
end $$;

-- -----------------------------------------------------------------------------
-- Blocking: a blocked pair must not see each other's posts or comments.
-- -----------------------------------------------------------------------------
create or replace function public.is_blocked_pair(p_a uuid, p_b uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1 from public.blocked_users
    where (blocker_id = p_a and blocked_user_id = p_b)
       or (blocker_id = p_b and blocked_user_id = p_a)
  );
$$;

-- =============================================================================
-- READ API
-- =============================================================================
-- Every feed read goes through these SECURITY DEFINER functions. They are the
-- single place that decides what a viewer may see, and the single place where
-- an anonymous author_id is either nulled out or returned (author only).
-- =============================================================================

-- Shared projection helper -----------------------------------------------------
create or replace function public.post_media_url(p_path text)
returns text
language sql
immutable
as $$
  select case
    when p_path is null then null
    when p_path like 'http%' then p_path
    else '/media/' || ltrim(p_path, '/')
  end;
$$;

-- -----------------------------------------------------------------------------
-- feed_posts — channel feed with latest / trending / most-liked / following
-- -----------------------------------------------------------------------------
create or replace function public.feed_posts(
  p_channel_id uuid default null,
  p_sort text default 'latest',
  p_cursor timestamptz default null,
  p_cursor_id uuid default null,
  p_offset integer default 0,
  p_limit integer default 20,
  p_category public.post_category default null,
  p_search text default null,
  p_following_only boolean default false,
  p_author_id uuid default null,
  p_ids uuid[] default null
)
returns table (
  id uuid,
  channel_id uuid,
  channel_slug text,
  channel_name text,
  campus_name text,
  university_id uuid,
  university_name text,
  university_abbreviation text,
  university_slug text,
  city text,
  body text,
  is_anonymous boolean,
  category public.post_category,
  media_path text,
  media_width integer,
  media_height integer,
  moderation_status public.moderation_status,
  like_count integer,
  comment_count integer,
  share_count integer,
  is_pinned boolean,
  edited_at timestamptz,
  created_at timestamptz,
  author_id uuid,
  author_username text,
  author_display_name text,
  author_avatar_url text,
  viewer_has_liked boolean,
  viewer_has_saved boolean,
  viewer_can_manage boolean,
  poll jsonb
)
language sql
stable
security definer
set search_path = public
as $$
  with viewer as (select auth.uid() as uid),
  base as (
    select
      p.id, p.channel_id, p.university_id, p.author_id, p.body, p.is_anonymous,
      p.category, p.media_path, p.media_width, p.media_height, p.moderation_status,
      p.like_count, p.comment_count, p.share_count, p.is_pinned, p.edited_at, p.created_at,
      c.slug as channel_slug, c.name as channel_name,
      camp.name as campus_name,
      u.name as university_name, u.abbreviation as university_abbreviation,
      u.slug as university_slug, coalesce(camp.city, u.city) as city
    from public.posts p
    join public.channels c on c.id = p.channel_id
    join public.universities u on u.id = p.university_id
    join public.campuses camp on camp.id = c.campus_id
    cross join viewer v
    where p.deleted_at is null
      and p.moderation_status = 'published'
      and (p_channel_id is null or p.channel_id = p_channel_id)
      and (p_author_id is null or p.author_id = p_author_id)
      and (p_ids is null or p.id = any(p_ids))
      and (p_category is null or p.category = p_category)
      and (p_search is null or p.search_vector @@ plainto_tsquery('simple', p_search))
      -- blocked users: neither direction is visible
      and not public.is_blocked_pair(v.uid, p.author_id)
      -- a private profile only publishes to its own followers-free model:
      -- non-anonymous posts from suspended accounts are hidden
      and not exists (
        select 1 from public.profiles pr where pr.id = p.author_id and pr.is_suspended
      )
      and (
        not p_following_only
        or exists (
          select 1 from public.channel_members cm
          where cm.channel_id = p.channel_id and cm.user_id = v.uid
        )
      )
      -- Optional "mentioned" filter
      and (
        p_sort <> 'mentioned'
        or exists (
          select 1 from public.mentions m
          where m.source_type = 'post' and m.source_id = p.id and m.mentioned_user_id = v.uid
        )
      )
  )
  select
    b.id, b.channel_id, b.channel_slug, b.channel_name, b.campus_name,
    b.university_id, b.university_name, b.university_abbreviation, b.university_slug, b.city,
    b.body, b.is_anonymous, b.category, b.media_path, b.media_width, b.media_height,
    b.moderation_status, b.like_count, b.comment_count, b.share_count, b.is_pinned,
    b.edited_at, b.created_at,
    -- ---------------------------------------------------------------- identity
    -- Anonymous author_id is returned ONLY to the author themself.
    case when (not b.is_anonymous) or b.author_id = v.uid then b.author_id else null end as author_id,
    case when (not b.is_anonymous) or b.author_id = v.uid then pr.username else null end as author_username,
    case when (not b.is_anonymous) or b.author_id = v.uid then pr.display_name else null end as author_display_name,
    case when (not b.is_anonymous) or b.author_id = v.uid then pr.avatar_url else null end as author_avatar_url,
    exists (select 1 from public.post_likes pl where pl.post_id = b.id and pl.user_id = v.uid) as viewer_has_liked,
    exists (select 1 from public.saved_posts sp where sp.post_id = b.id and sp.user_id = v.uid) as viewer_has_saved,
    (b.author_id = v.uid or public.is_moderator()) as viewer_can_manage,
    (select jsonb_build_object(
        'id', po.id,
        'question', po.question,
        'allow_multiple', po.allow_multiple,
        'closes_at', po.closes_at,
        'total', (select coalesce(sum(o2.vote_count), 0) from public.poll_options o2 where o2.poll_id = po.id),
        'options', (
          select coalesce(jsonb_agg(jsonb_build_object(
                   'id', o.id, 'label', o.label, 'votes', o.vote_count,
                   'voted', exists (select 1 from public.poll_votes pv
                                    where pv.option_id = o.id and pv.user_id = v.uid)
                 ) order by o.position, o.id), '[]'::jsonb)
          from public.poll_options o where o.poll_id = po.id
        )
      )
     from public.polls po where po.post_id = b.id) as poll
  from base b
  cross join viewer v
  left join public.profiles pr on pr.id = b.author_id
  where
    case
      when p_sort = 'latest' and p_cursor is not null then
        (b.created_at, b.id) < (p_cursor, coalesce(p_cursor_id, 'ffffffff-ffff-ffff-ffff-ffffffffffff'::uuid))
      else true
    end
  order by
    b.is_pinned desc,
    case when p_sort = 'most_liked' then b.like_count end desc nulls last,
    case when p_sort = 'trending' then
      (b.like_count * 2 + b.comment_count * 3 + 1)::numeric
        / power(extract(epoch from (now() - b.created_at)) / 3600.0 * 0.35 + 2, 1.6)
    end desc nulls last,
    b.created_at desc,
    b.id desc
  offset (case when p_sort in ('latest') then 0 else greatest(p_offset, 0) end)
  limit least(greatest(p_limit, 1), 50);
$$;

-- -----------------------------------------------------------------------------
-- get_post — single post detail (used by /p/[id] share pages)
-- -----------------------------------------------------------------------------
create or replace function public.get_post(p_post_id uuid)
returns table (
  id uuid, channel_id uuid, channel_slug text, channel_name text, campus_name text,
  university_id uuid, university_name text, university_abbreviation text, university_slug text,
  city text, body text, is_anonymous boolean, category public.post_category,
  media_path text, media_width integer, media_height integer,
  moderation_status public.moderation_status, like_count integer, comment_count integer,
  share_count integer, is_pinned boolean, edited_at timestamptz, created_at timestamptz,
  author_id uuid, author_username text, author_display_name text, author_avatar_url text,
  viewer_has_liked boolean, viewer_has_saved boolean, viewer_can_manage boolean,
  deleted_at timestamptz, poll jsonb
)
language plpgsql
stable
security definer
set search_path = public
as $$
begin
  return query
    select
      f.id, f.channel_id, f.channel_slug, f.channel_name, f.campus_name,
      f.university_id, f.university_name, f.university_abbreviation, f.university_slug, f.city,
      f.body, f.is_anonymous, f.category, f.media_path, f.media_width, f.media_height,
      f.moderation_status, f.like_count, f.comment_count, f.share_count, f.is_pinned,
      f.edited_at, f.created_at,
      f.author_id, f.author_username, f.author_display_name, f.author_avatar_url,
      f.viewer_has_liked, f.viewer_has_saved, f.viewer_can_manage,
      null::timestamptz as deleted_at, f.poll
    from public.feed_posts(
      null, 'latest', null, null, 0, 1, null, null, false, null, array[p_post_id]
    ) f;

  if not found then
    -- Author or moderator looking at their own removed / hidden content.
    return query
      select
        p.id, p.channel_id, c.slug, c.name, camp.name,
        p.university_id, u.name, u.abbreviation, u.slug, coalesce(camp.city, u.city),
        p.body, p.is_anonymous, p.category, p.media_path, p.media_width, p.media_height,
        p.moderation_status, p.like_count, p.comment_count, p.share_count, p.is_pinned,
        p.edited_at, p.created_at,
        case when (not p.is_anonymous) or p.author_id = auth.uid() then p.author_id else null end,
        case when (not p.is_anonymous) or p.author_id = auth.uid() then pr.username else null end,
        case when (not p.is_anonymous) or p.author_id = auth.uid() then pr.display_name else null end,
        case when (not p.is_anonymous) or p.author_id = auth.uid() then pr.avatar_url else null end,
        exists (select 1 from public.post_likes pl where pl.post_id = p.id and pl.user_id = auth.uid()),
        exists (select 1 from public.saved_posts sp where sp.post_id = p.id and sp.user_id = auth.uid()),
        true, p.deleted_at,
        (select jsonb_build_object(
            'id', po.id, 'question', po.question, 'allow_multiple', po.allow_multiple,
            'closes_at', po.closes_at,
            'total', (select coalesce(sum(o2.vote_count), 0) from public.poll_options o2 where o2.poll_id = po.id),
            'options', (select coalesce(jsonb_agg(jsonb_build_object(
                'id', o.id, 'label', o.label, 'votes', o.vote_count,
                'voted', exists (select 1 from public.poll_votes pv where pv.option_id = o.id and pv.user_id = auth.uid())
              ) order by o.position, o.id), '[]'::jsonb)
              from public.poll_options o where o.poll_id = po.id))
         from public.polls po where po.post_id = p.id)
      from public.posts p
      join public.channels c on c.id = p.channel_id
      join public.universities u on u.id = p.university_id
      join public.campuses camp on camp.id = c.campus_id
      left join public.profiles pr on pr.id = p.author_id
      where p.id = p_post_id
        and (p.author_id = auth.uid() or public.is_moderator())
      limit 1;
  end if;
end;
$$;

-- -----------------------------------------------------------------------------
-- post_comments — comment tree with the same anonymous-identity rule.
-- A comment on an anonymous post never reveals the post author, and an
-- anonymous comment never reveals its own author.
-- -----------------------------------------------------------------------------
create or replace function public.post_comments(
  p_post_id uuid,
  p_cursor timestamptz default null,
  p_cursor_id uuid default null,
  p_limit integer default 20
)
returns table (
  id uuid, post_id uuid, parent_id uuid, root_id uuid, depth smallint,
  body text, is_anonymous boolean, like_count integer, reply_count integer,
  edited_at timestamptz, created_at timestamptz, moderation_status public.moderation_status,
  author_id uuid, author_username text, author_display_name text, author_avatar_url text,
  viewer_has_liked boolean, viewer_can_manage boolean, deleted_at timestamptz
)
language sql
stable
security definer
set search_path = public
as $$
  with viewer as (select auth.uid() as uid)
  select
    c.id, c.post_id, c.parent_id, c.root_id, c.depth, c.body, c.is_anonymous,
    c.like_count, c.reply_count, c.edited_at, c.created_at, c.moderation_status,
    case when (not c.is_anonymous) or c.author_id = v.uid then c.author_id else null end,
    case when (not c.is_anonymous) or c.author_id = v.uid then pr.username else null end,
    case when (not c.is_anonymous) or c.author_id = v.uid then pr.display_name else null end,
    case when (not c.is_anonymous) or c.author_id = v.uid then pr.avatar_url else null end,
    exists (select 1 from public.comment_likes cl where cl.comment_id = c.id and cl.user_id = v.uid),
    (c.author_id = v.uid or public.is_moderator()),
    c.deleted_at
  from public.comments c
  cross join viewer v
  left join public.profiles pr on pr.id = c.author_id
  where c.post_id = p_post_id
    and c.parent_id is null
    and (c.moderation_status = 'published' or c.author_id = v.uid or public.is_moderator())
    and not public.is_blocked_pair(v.uid, c.author_id)
    and (c.deleted_at is null or c.author_id = v.uid or public.is_moderator())
    and case
      when p_cursor is not null then
        (c.created_at, c.id) > (p_cursor, coalesce(p_cursor_id, '00000000-0000-0000-0000-000000000000'::uuid))
      else true
    end
  order by c.created_at asc, c.id asc
  limit least(greatest(p_limit, 1), 50);
$$;

create or replace function public.comment_replies(
  p_root_id uuid,
  p_limit integer default 50
)
returns table (
  id uuid, post_id uuid, parent_id uuid, root_id uuid, depth smallint,
  body text, is_anonymous boolean, like_count integer, reply_count integer,
  edited_at timestamptz, created_at timestamptz, moderation_status public.moderation_status,
  author_id uuid, author_username text, author_display_name text, author_avatar_url text,
  viewer_has_liked boolean, viewer_can_manage boolean, deleted_at timestamptz
)
language sql
stable
security definer
set search_path = public
as $$
  with viewer as (select auth.uid() as uid)
  select
    c.id, c.post_id, c.parent_id, c.root_id, c.depth, c.body, c.is_anonymous,
    c.like_count, c.reply_count, c.edited_at, c.created_at, c.moderation_status,
    case when (not c.is_anonymous) or c.author_id = v.uid then c.author_id else null end,
    case when (not c.is_anonymous) or c.author_id = v.uid then pr.username else null end,
    case when (not c.is_anonymous) or c.author_id = v.uid then pr.display_name else null end,
    case when (not c.is_anonymous) or c.author_id = v.uid then pr.avatar_url else null end,
    exists (select 1 from public.comment_likes cl where cl.comment_id = c.id and cl.user_id = v.uid),
    (c.author_id = v.uid or public.is_moderator()),
    c.deleted_at
  from public.comments c
  cross join viewer v
  left join public.profiles pr on pr.id = c.author_id
  where c.root_id = p_root_id
    and (c.moderation_status = 'published' or c.author_id = v.uid or public.is_moderator())
    and not public.is_blocked_pair(v.uid, c.author_id)
    and (c.deleted_at is null or c.author_id = v.uid or public.is_moderator())
  order by c.created_at asc, c.id asc
  limit least(greatest(p_limit, 1), 100);
$$;

-- -----------------------------------------------------------------------------
-- profile_public — a profile row safe for public consumption.
-- Private profiles return only the identity essentials.
-- -----------------------------------------------------------------------------
create or replace function public.profile_public(p_username text)
returns table (
  id uuid, username text, display_name text, avatar_url text, banner_url text, bio text,
  university_id uuid, university_name text, university_abbreviation text, university_slug text,
  campus_id uuid, campus_name text, city text, province text,
  degree_program text, department text, semester text, graduation_year smallint,
  interests text[], profile_visibility public.profile_visibility,
  is_suspended boolean, created_at timestamptz,
  channels_joined integer, public_post_count integer,
  viewer_is_owner boolean, viewer_is_blocking boolean, viewer_is_blocked boolean
)
language sql
stable
security definer
set search_path = public
as $$
  with viewer as (select auth.uid() as uid)
  select
    pr.id, pr.username, pr.display_name, pr.avatar_url, pr.banner_url,
    case when pr.profile_visibility = 'private' and pr.id <> v.uid and not public.is_moderator()
         then null else pr.bio end,
    pr.university_id, u.name, u.abbreviation, u.slug,
    pr.campus_id, camp.name, coalesce(camp.city, u.city), coalesce(camp.province, u.province),
    case when pr.profile_visibility = 'private' and pr.id <> v.uid and not public.is_moderator()
         then null else pr.degree_program end,
    case when pr.profile_visibility = 'private' and pr.id <> v.uid and not public.is_moderator()
         then null else pr.department end,
    case when pr.profile_visibility = 'private' and pr.id <> v.uid and not public.is_moderator()
         then null else pr.semester end,
    case when pr.profile_visibility = 'private' and pr.id <> v.uid and not public.is_moderator()
         then null else pr.graduation_year end,
    case when pr.profile_visibility = 'private' and pr.id <> v.uid and not public.is_moderator()
         then '{}'::text[] else pr.interests end,
    pr.profile_visibility,
    pr.is_suspended, pr.created_at,
    (select count(*)::integer from public.channel_members cm where cm.user_id = pr.id),
    -- Anonymous confessions are never counted here: a public post count that
    -- only counted public posts would let visitors infer authorship by maths.
    (select count(*)::integer from public.posts p
      where p.author_id = pr.id and not p.is_anonymous
        and p.deleted_at is null and p.moderation_status = 'published'),
    (pr.id = v.uid),
    exists (select 1 from public.blocked_users b where b.blocker_id = v.uid and b.blocked_user_id = pr.id),
    exists (select 1 from public.blocked_users b where b.blocker_id = pr.id and b.blocked_user_id = v.uid)
  from public.profiles pr
  cross join viewer v
  left join public.universities u on u.id = pr.university_id
  left join public.campuses camp on camp.id = pr.campus_id
  where pr.username = lower(p_username)
  limit 1;
$$;

-- -----------------------------------------------------------------------------
-- profile_posts — public posts only. Anonymous confessions never appear on a
-- public profile surface; the owner sees them via my_confessions().
-- -----------------------------------------------------------------------------
create or replace function public.profile_posts(
  p_profile_id uuid,
  p_cursor timestamptz default null,
  p_cursor_id uuid default null,
  p_limit integer default 10
)
returns table (
  id uuid, channel_id uuid, channel_slug text, channel_name text, campus_name text,
  university_id uuid, university_name text, university_abbreviation text, university_slug text,
  city text, body text, is_anonymous boolean, category public.post_category,
  media_path text, media_width integer, media_height integer,
  moderation_status public.moderation_status, like_count integer, comment_count integer,
  share_count integer, is_pinned boolean, edited_at timestamptz, created_at timestamptz,
  author_id uuid, author_username text, author_display_name text, author_avatar_url text,
  viewer_has_liked boolean, viewer_has_saved boolean, viewer_can_manage boolean, poll jsonb
)
language sql
stable
security definer
set search_path = public
as $$
  select f.*
  from public.feed_posts(null, 'latest', p_cursor, p_cursor_id, 0, p_limit, null, null, false, p_profile_id) f
  where f.is_anonymous = false
  order by f.created_at desc, f.id desc;
$$;

-- -----------------------------------------------------------------------------
-- my_confessions — the owner's private dashboard of their own anonymous posts.
-- -----------------------------------------------------------------------------
create or replace function public.my_confessions(
  p_cursor timestamptz default null,
  p_cursor_id uuid default null,
  p_limit integer default 20
)
returns table (
  id uuid, channel_id uuid, channel_slug text, channel_name text, campus_name text,
  university_id uuid, university_name text, university_abbreviation text, university_slug text,
  city text, body text, is_anonymous boolean, category public.post_category,
  media_path text, media_width integer, media_height integer,
  moderation_status public.moderation_status, like_count integer, comment_count integer,
  share_count integer, is_pinned boolean, edited_at timestamptz, created_at timestamptz,
  author_id uuid, author_username text, author_display_name text, author_avatar_url text,
  viewer_has_liked boolean, viewer_has_saved boolean, viewer_can_manage boolean, poll jsonb
)
language sql
stable
security definer
set search_path = public
as $$
  select f.*
  from public.feed_posts(null, 'latest', p_cursor, p_cursor_id, 0, p_limit, null, null, false, auth.uid()) f
  where f.is_anonymous = true
  order by f.created_at desc, f.id desc;
$$;

-- -----------------------------------------------------------------------------
-- search_all — unified, database-backed search across all four result types.
-- -----------------------------------------------------------------------------
create or replace function public.search_all(
  p_query text,
  p_scope text default 'all',
  p_limit integer default 12,
  p_offset integer default 0
)
returns jsonb
language plpgsql
stable
security definer
set search_path = public
as $$
declare
  q text := btrim(coalesce(p_query, ''));
  result jsonb;
begin
  if char_length(q) < 2 then
    return jsonb_build_object('universities', '[]'::jsonb, 'campuses', '[]'::jsonb,
                              'users', '[]'::jsonb, 'posts', '[]'::jsonb, 'query', q);
  end if;

  select jsonb_build_object(
    'query', q,
    'universities', case when p_scope in ('all', 'universities') then (
      select coalesce(jsonb_agg(x order by x ->> 'rank' desc), '[]'::jsonb) from (
        select jsonb_build_object(
          'id', u.id, 'name', u.name, 'slug', u.slug, 'abbreviation', u.abbreviation,
          'city', u.city, 'province', u.province, 'logo_url', u.logo_url,
          'banner_url', u.banner_url, 'description', u.description,
          'type', u.institution_type,
          'campus_count', (select count(*) from public.campuses c where c.university_id = u.id and c.is_active),
          'member_count', (select count(*) from public.channel_members cm where cm.university_id = u.id),
          'post_count', (select count(*) from public.posts p where p.university_id = u.id
                          and p.deleted_at is null and p.moderation_status = 'published'),
          'rank', ts_rank(to_tsvector('simple', u.name || ' ' || coalesce(u.abbreviation,'') || ' ' || array_to_string(u.aliases,' ')),
                          plainto_tsquery('simple', q))
        ) as x
        from public.universities u
        where u.is_active and u.status = 'active'
          and (
            to_tsvector('simple', u.name || ' ' || coalesce(u.abbreviation,'') || ' ' || array_to_string(u.aliases,' '))
              @@ plainto_tsquery('simple', q)
            or u.name ilike '%' || q || '%'
            or coalesce(u.abbreviation,'') ilike q || '%'
            or exists (select 1 from unnest(u.aliases) a where a ilike '%' || q || '%')
            or exists (select 1 from public.campuses c where c.university_id = u.id and c.name ilike '%' || q || '%')
            or u.city ilike '%' || q || '%'
          )
        order by ts_rank(to_tsvector('simple', u.name || ' ' || coalesce(u.abbreviation,'') || ' ' || array_to_string(u.aliases,' ')),
                          plainto_tsquery('simple', q)) desc
        limit least(p_limit, 24) offset greatest(p_offset, 0)
      ) s
    ) else '[]'::jsonb end,
    'campuses', case when p_scope in ('all', 'campuses') then (
      select coalesce(jsonb_agg(jsonb_build_object(
        'id', c.id, 'name', c.name, 'slug', c.slug, 'city', c.city, 'province', c.province,
        'university_id', u.id, 'university_name', u.name, 'university_abbreviation', u.abbreviation,
        'university_slug', u.slug, 'logo_url', u.logo_url,
        'channel_slug', ch.slug,
        'member_count', (select count(*) from public.channel_members cm where cm.channel_id = ch.id),
        'post_count', (select count(*) from public.posts p where p.channel_id = ch.id
                        and p.deleted_at is null and p.moderation_status = 'published')
      ) order by u.name, c.name), '[]'::jsonb)
      from public.campuses c
      join public.universities u on u.id = c.university_id
      left join public.channels ch on ch.campus_id = c.id
      where c.is_active and u.is_active and u.status = 'active'
        and (c.name ilike '%' || q || '%' or u.name ilike '%' || q || '%'
             or coalesce(c.city,'') ilike '%' || q || '%')
      limit least(p_limit, 24) offset greatest(p_offset, 0)
    ) else '[]'::jsonb end,
    'users', case when p_scope in ('all', 'users') then (
      -- ORDER BY must live inside the aggregate: the outer SELECT is already
      -- aggregated, so it cannot reference ungrouped columns.
      select coalesce(jsonb_agg(jsonb_build_object(
        'id', pr.id, 'username', pr.username, 'display_name', pr.display_name,
        'avatar_url', pr.avatar_url, 'bio', pr.bio,
        'university_name', u.name, 'university_abbreviation', u.abbreviation,
        'campus_name', camp.name, 'visibility', pr.profile_visibility
      ) order by (pr.username = lower(q)) desc, pr.display_name asc), '[]'::jsonb)
      from (
        select * from public.profiles p2
        where not p2.is_suspended
          and (p2.username ilike '%' || lower(q) || '%' or p2.display_name ilike '%' || q || '%')
          and not public.is_blocked_pair(auth.uid(), p2.id)
        limit least(p_limit, 24) offset greatest(p_offset, 0)
      ) pr
      left join public.universities u on u.id = pr.university_id
      left join public.campuses camp on camp.id = pr.campus_id
    ) else '[]'::jsonb end,
    'posts', case when p_scope in ('all', 'posts') then (
      select coalesce(jsonb_agg(jsonb_build_object(
        'id', f.id, 'body', left(f.body, 280), 'created_at', f.created_at,
        'is_anonymous', f.is_anonymous, 'like_count', f.like_count, 'comment_count', f.comment_count,
        'author_username', f.author_username, 'author_display_name', f.author_display_name,
        'author_avatar_url', f.author_avatar_url,
        'channel_slug', f.channel_slug, 'channel_name', f.channel_name,
        'university_abbreviation', f.university_abbreviation
      )), '[]'::jsonb)
      from public.feed_posts(null, 'latest', null, null, 0, 24, null, q) f
    ) else '[]'::jsonb end
  ) into result;

  return result;
end;
$$;

-- -----------------------------------------------------------------------------
-- trending_topics — hashtags/words genuinely ranked by engagement + recency.
-- -----------------------------------------------------------------------------
create or replace function public.trending_topics(
  p_channel_id uuid default null,
  p_university_id uuid default null,
  p_limit integer default 8,
  p_days integer default 14
)
returns table (topic text, post_count bigint, engagement bigint, latest_at timestamptz)
language sql
stable
security definer
set search_path = public
as $$
  with scoped as (
    select p.id, p.body, p.created_at, (p.like_count * 2 + p.comment_count * 3) as eng
    from public.posts p
    where p.deleted_at is null
      and p.moderation_status = 'published'
      and p.created_at > now() - make_interval(days => greatest(p_days, 1))
      and (p_channel_id is null or p.channel_id = p_channel_id)
      and (p_university_id is null or p.university_id = p_university_id)
  ),
  words as (
    select lower(m[1]) as topic, s.eng, s.created_at
    from scoped s,
         lateral regexp_matches(s.body, '#([A-Za-z][A-Za-z0-9_]{2,24})', 'g') as m
  )
  select w.topic,
         count(*)::bigint as post_count,
         sum(w.eng)::bigint as engagement,
         max(w.created_at) as latest_at
  from words w
  group by w.topic
  having count(*) >= 2
  order by sum(w.eng) desc, max(w.created_at) desc
  limit least(greatest(p_limit, 1), 30);
$$;

-- -----------------------------------------------------------------------------
-- channel_overview — real member + post counts for a channel page.
-- -----------------------------------------------------------------------------
create or replace function public.channel_overview(p_slug text)
returns jsonb
language plpgsql
stable
security definer
set search_path = public
as $$
declare
  result jsonb;
  uid uuid := auth.uid();
begin
  select jsonb_build_object(
    'id', c.id, 'slug', c.slug, 'name', c.name, 'description', c.description,
    'banner_url', c.banner_url, 'guidelines', c.guidelines, 'posting_policy', c.posting_policy,
    'is_active', c.is_active,
    'university_id', u.id, 'university_name', u.name, 'university_slug', u.slug,
    'university_abbreviation', u.abbreviation, 'university_logo_url', u.logo_url,
    'university_banner_url', u.banner_url, 'university_description', u.description,
    'university_city', u.city, 'university_province', u.province,
    'university_type', u.institution_type,
    'campus_id', camp.id, 'campus_name', camp.name, 'campus_city', camp.city, 'campus_province', camp.province,
    'member_count', (select count(*) from public.channel_members cm where cm.channel_id = c.id),
    'post_count', (select count(*) from public.posts p where p.channel_id = c.id
                    and p.deleted_at is null and p.moderation_status = 'published'),
    'today_post_count', (select count(*) from public.posts p where p.channel_id = c.id
                    and p.deleted_at is null and p.moderation_status = 'published'
                    and p.created_at > date_trunc('day', now())),
    'week_post_count', (select count(*) from public.posts p where p.channel_id = c.id
                    and p.deleted_at is null and p.moderation_status = 'published'
                    and p.created_at > now() - interval '7 days'),
    'is_member', exists (select 1 from public.channel_members cm where cm.channel_id = c.id and cm.user_id = uid),
    'is_muted', exists (select 1 from public.channel_mutes m where m.channel_id = c.id and m.user_id = uid),
    'other_campuses', (
      select coalesce(jsonb_agg(jsonb_build_object(
        'id', c2.id, 'slug', c2.slug, 'campus_name', camp2.name, 'city', camp2.city,
        'member_count', (select count(*) from public.channel_members cm2 where cm2.channel_id = c2.id)
      ) order by camp2.name), '[]'::jsonb)
      from public.channels c2
      join public.campuses camp2 on camp2.id = c2.campus_id
      where c2.university_id = c.university_id and c2.id <> c.id and c2.is_active
    )
  ) into result
  from public.channels c
  join public.universities u on u.id = c.university_id
  join public.campuses camp on camp.id = c.campus_id
  where c.slug = p_slug and c.is_active and u.is_active
  limit 1;

  return result;
end;
$$;

-- -----------------------------------------------------------------------------
-- university_cards — the discovery grid, with counts from real membership rows.
-- -----------------------------------------------------------------------------
create or replace function public.university_cards(
  p_query text default null,
  p_province text default null,
  p_city text default null,
  p_type text default null,
  p_sort text default 'name',
  p_limit integer default 24,
  p_offset integer default 0
)
returns table (
  id uuid, name text, slug text, abbreviation text, description text,
  logo_url text, banner_url text, city text, province text, institution_type public.institution_type,
  is_featured boolean, campus_count integer, member_count integer, post_count integer,
  week_post_count integer, viewer_is_member boolean,
  campuses jsonb
)
language sql
stable
security definer
set search_path = public
as $$
  with viewer as (select auth.uid() as uid)
  select
    u.id, u.name, u.slug, u.abbreviation, u.description, u.logo_url, u.banner_url,
    u.city, u.province, u.institution_type, u.is_featured,
    (select count(*)::integer from public.campuses c where c.university_id = u.id and c.is_active),
    (select count(*)::integer from public.channel_members cm where cm.university_id = u.id),
    (select count(*)::integer from public.posts p where p.university_id = u.id
       and p.deleted_at is null and p.moderation_status = 'published'),
    (select count(*)::integer from public.posts p where p.university_id = u.id
       and p.deleted_at is null and p.moderation_status = 'published' and p.created_at > now() - interval '7 days'),
    exists (select 1 from public.channel_members cm join viewer v on true
            where cm.university_id = u.id and cm.user_id = v.uid),
    (select coalesce(jsonb_agg(jsonb_build_object(
              'id', c.id, 'slug', c.slug, 'name', c.name, 'city', c.city,
              'member_count', (select count(*) from public.channel_members cm2 where cm2.channel_id = c.id)
            ) order by c.name), '[]'::jsonb)
     from public.campuses c where c.university_id = u.id and c.is_active)
  from public.universities u
  where u.is_active and u.status = 'active'
    and (p_query is null or btrim(p_query) = '' or
         u.name ilike '%' || btrim(p_query) || '%' or
         coalesce(u.abbreviation,'') ilike '%' || btrim(p_query) || '%' or
         exists (select 1 from unnest(u.aliases) a where a ilike '%' || btrim(p_query) || '%') or
         coalesce(u.city,'') ilike '%' || btrim(p_query) || '%' or
         exists (select 1 from public.campuses c2 where c2.university_id = u.id and c2.name ilike '%' || btrim(p_query) || '%'))
    and (p_province is null or p_province = '' or u.province = p_province)
    and (p_city is null or p_city = '' or u.city = p_city
         or exists (select 1 from public.campuses c3 where c3.university_id = u.id and c3.city = p_city))
    and (p_type is null or p_type = '' or u.institution_type = p_type::public.institution_type)
  order by
    case when p_sort = 'most_joined' then (select count(*) from public.channel_members cm where cm.university_id = u.id) end desc nulls last,
    case when p_sort = 'recently_active' then (select count(*) from public.posts p where p.university_id = u.id
        and p.deleted_at is null and p.moderation_status = 'published' and p.created_at > now() - interval '7 days') end desc nulls last,
    case when p_sort = 'campuses' then (select count(*) from public.campuses c where c.university_id = u.id and c.is_active) end desc nulls last,
    u.is_featured desc,
    u.name asc
  limit least(greatest(p_limit, 1), 60)
  offset greatest(p_offset, 0);
$$;

-- -----------------------------------------------------------------------------
-- my_channels — the /joined page and the onboarding recommender.
-- -----------------------------------------------------------------------------
create or replace function public.my_channels(p_limit integer default 60, p_offset integer default 0)
returns table (
  channel_id uuid, channel_slug text, channel_name text, description text, banner_url text,
  university_id uuid, university_name text, university_slug text, university_abbreviation text,
  university_logo_url text, campus_name text, city text, province text,
  member_count integer, post_count integer, week_post_count integer,
  is_muted boolean, joined_at timestamptz
)
language sql
stable
security definer
set search_path = public
as $$
  select
    c.id, c.slug, c.name, c.description, coalesce(c.banner_url, u.banner_url),
    u.id, u.name, u.slug, u.abbreviation, u.logo_url,
    camp.name, coalesce(camp.city, u.city), coalesce(camp.province, u.province),
    (select count(*)::integer from public.channel_members cm2 where cm2.channel_id = c.id),
    (select count(*)::integer from public.posts p where p.channel_id = c.id
       and p.deleted_at is null and p.moderation_status = 'published'),
    (select count(*)::integer from public.posts p where p.channel_id = c.id
       and p.deleted_at is null and p.moderation_status = 'published' and p.created_at > now() - interval '7 days'),
    exists (select 1 from public.channel_mutes m where m.channel_id = c.id and m.user_id = auth.uid()),
    cm.joined_at
  from public.channel_members cm
  join public.channels c on c.id = cm.channel_id
  join public.universities u on u.id = c.university_id
  join public.campuses camp on camp.id = c.campus_id
  where cm.user_id = auth.uid() and c.is_active
  order by cm.joined_at desc
  limit least(greatest(p_limit, 1), 100)
  offset greatest(p_offset, 0);
$$;

-- -----------------------------------------------------------------------------
-- recommended_channels — onboarding step 4 + /explore recommendations.
-- -----------------------------------------------------------------------------
create or replace function public.recommended_channels(p_limit integer default 8)
returns table (
  channel_id uuid, channel_slug text, channel_name text, description text, banner_url text,
  university_id uuid, university_name text, university_slug text, university_abbreviation text,
  university_logo_url text, campus_name text, city text, province text,
  member_count integer, post_count integer, week_post_count integer,
  is_member boolean, reason text
)
language sql
stable
security definer
set search_path = public
as $$
  with me as (
    select pr.id, pr.university_id, pr.campus_id
    from public.profiles pr where pr.id = auth.uid()
  )
  select
    c.id, c.slug, c.name, c.description, coalesce(c.banner_url, u.banner_url),
    u.id, u.name, u.slug, u.abbreviation, u.logo_url,
    camp.name, coalesce(camp.city, u.city), coalesce(camp.province, u.province),
    (select count(*)::integer from public.channel_members cm where cm.channel_id = c.id),
    (select count(*)::integer from public.posts p where p.channel_id = c.id
       and p.deleted_at is null and p.moderation_status = 'published'),
    (select count(*)::integer from public.posts p where p.channel_id = c.id
       and p.deleted_at is null and p.moderation_status = 'published' and p.created_at > now() - interval '7 days'),
    exists (select 1 from public.channel_members cm where cm.channel_id = c.id and cm.user_id = auth.uid()),
    case
      when c.campus_id = (select campus_id from me) then 'Your campus'
      when c.university_id = (select university_id from me) then 'Another campus of your university'
      when coalesce(camp.city, u.city) = (select city from public.universities where id = (select university_id from me)) then 'Popular in your city'
      else 'Trending on Campusly'
    end
  from public.channels c
  join public.universities u on u.id = c.university_id
  join public.campuses camp on camp.id = c.campus_id
  where c.is_active and u.is_active and u.status = 'active'
    and not exists (
      select 1 from public.channel_members cm
      where cm.channel_id = c.id and cm.user_id = auth.uid()
    )
  order by
    (c.campus_id = (select campus_id from me)) desc,
    (c.university_id = (select university_id from me)) desc,
    (select count(*) from public.channel_members cm where cm.channel_id = c.id) desc,
    (select count(*) from public.posts p where p.channel_id = c.id
       and p.created_at > now() - interval '7 days') desc
  limit least(greatest(p_limit, 1), 30);
$$;

-- -----------------------------------------------------------------------------
-- platform_stats — admin overview. Real aggregates only, no invented numbers.
-- -----------------------------------------------------------------------------
create or replace function public.platform_stats()
returns jsonb
language plpgsql
stable
security definer
set search_path = public
as $$
declare
  result jsonb;
begin
  if not public.is_admin() then
    raise exception 'Administrator role required' using errcode = '42501';
  end if;

  select jsonb_build_object(
    'total_users',        (select count(*) from public.profiles),
    'onboarded_users',    (select count(*) from public.profiles where onboarding_completed),
    'new_users_7d',       (select count(*) from public.profiles where created_at > now() - interval '7 days'),
    'active_users_7d',    (select count(*) from public.profiles where last_active_at > now() - interval '7 days'),
    'active_users_30d',   (select count(*) from public.profiles where last_active_at > now() - interval '30 days'),
    'suspended_users',    (select count(*) from public.profiles where is_suspended),
    'universities',       (select count(*) from public.universities where is_active and status = 'active'),
    'universities_pending', (select count(*) from public.universities where status = 'pending_review'),
    'campuses',           (select count(*) from public.campuses where is_active),
    'channels',           (select count(*) from public.channels where is_active),
    'memberships',        (select count(*) from public.channel_members),
    'posts_total',        (select count(*) from public.posts where deleted_at is null),
    'posts_7d',           (select count(*) from public.posts where deleted_at is null and created_at > now() - interval '7 days'),
    'posts_anonymous',    (select count(*) from public.posts where deleted_at is null and is_anonymous),
    'posts_hidden',       (select count(*) from public.posts where deleted_at is null and moderation_status <> 'published'),
    'comments_total',     (select count(*) from public.comments where deleted_at is null),
    'likes_total',        (select count(*) from public.post_likes),
    'reports_open',       (select count(*) from public.reports where status = 'open'),
    'reports_in_review',  (select count(*) from public.reports where status = 'in_review'),
    'reports_resolved_7d',(select count(*) from public.reports where status in ('resolved','dismissed') and reviewed_at > now() - interval '7 days'),
    'moderators',         (select count(*) from public.user_roles where role in ('moderator','admin'))
  ) into result;

  return result;
end;
$$;

-- -----------------------------------------------------------------------------
-- moderation_queue — reports with their target snapshot attached.
-- -----------------------------------------------------------------------------
create or replace function public.moderation_queue(
  p_status public.report_status default 'open',
  p_limit integer default 30,
  p_offset integer default 0
)
returns table (
  report_id uuid, target_type public.report_target, target_id uuid,
  reason public.report_reason, description text, status public.report_status,
  created_at timestamptz, reporter_username text, report_count bigint,
  reviewed_by_username text, reviewed_at timestamptz, resolution_note text,
  target_snapshot jsonb, snapshot_post_id uuid, snapshot_channel_slug text
)
language sql
stable
security definer
set search_path = public
as $$
  select
    r.id, r.target_type, r.target_id, r.reason, r.description, r.status, r.created_at,
    reporter.username,
    (select count(*) from public.reports r2
      where r2.target_type = r.target_type and r2.target_id = r.target_id
        and r2.status in ('open','in_review')),
    rev.username, r.reviewed_at, r.resolution_note,
    r.target_snapshot,
    case when r.target_type = 'post' then r.target_id
         when r.target_type = 'comment' then (r.target_snapshot ->> 'post_id')::uuid end,
    r.target_snapshot ->> 'channel_slug'
  from public.reports r
  left join public.profiles reporter on reporter.id = r.reporter_id
  left join public.profiles rev on rev.id = r.reviewed_by
  where public.is_moderator()
    and r.status = p_status
  order by r.created_at asc
  limit least(greatest(p_limit, 1), 100)
  offset greatest(p_offset, 0);
$$;

-- -----------------------------------------------------------------------------
-- deanonymise_post — the ONLY way to link an anonymous confession to its
-- author. Moderator-only, reason required, and permanently audited.
-- -----------------------------------------------------------------------------
create or replace function public.deanonymise_post(p_post_id uuid, p_reason text)
returns table (author_id uuid, author_username text, author_display_name text, is_anonymous boolean)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_actor uuid := auth.uid();
  v_post  public.posts;
  v_profile public.profiles;
begin
  if not public.is_moderator() then
    raise exception 'Moderator role required' using errcode = '42501';
  end if;
  if coalesce(btrim(p_reason), '') = '' or char_length(p_reason) < 10 then
    raise exception 'A written justification of at least 10 characters is required' using errcode = '22023';
  end if;

  select * into v_post from public.posts where id = p_post_id;
  if not found then
    raise exception 'Post not found' using errcode = 'P0002';
  end if;

  select * into v_profile from public.profiles where id = v_post.author_id;

  insert into public.audit_log (actor_id, actor_role, event, target_type, target_id, metadata)
  values (v_actor, public.current_app_role(), 'anonymous_identity_disclosed', 'post', p_post_id,
          jsonb_build_object('reason', p_reason));

  return query select v_post.author_id, v_profile.username, v_profile.display_name, v_post.is_anonymous;
end;
$$;

-- -----------------------------------------------------------------------------
-- channel_choices / campus_choices — searchable dropdowns for onboarding &
-- settings. Never load a full catalogue into the client.
-- -----------------------------------------------------------------------------
create or replace function public.university_choices(p_query text default null, p_limit integer default 20)
returns table (id uuid, name text, abbreviation text, slug text, city text, province text, campus_count integer)
language sql
stable
security definer
set search_path = public
as $$
  select u.id, u.name, u.abbreviation, u.slug, u.city, u.province,
         (select count(*)::integer from public.campuses c where c.university_id = u.id and c.is_active)
  from public.universities u
  where u.is_active and u.status = 'active'
    and (p_query is null or btrim(p_query) = '' or
         u.name ilike '%' || btrim(p_query) || '%' or
         coalesce(u.abbreviation,'') ilike '%' || btrim(p_query) || '%' or
         exists (select 1 from unnest(u.aliases) a where a ilike '%' || btrim(p_query) || '%'))
  order by
    case when p_query is null or btrim(p_query) = '' then u.is_featured end desc nulls last,
    u.name asc
  limit least(greatest(p_limit, 1), 50);
$$;

create or replace function public.campus_choices(p_university_id uuid, p_query text default null, p_limit integer default 30)
returns table (id uuid, name text, city text, province text, is_main boolean)
language sql
stable
security definer
set search_path = public
as $$
  select c.id, c.name, c.city, c.province, c.is_main
  from public.campuses c
  where c.university_id = p_university_id and c.is_active
    and (p_query is null or btrim(p_query) = '' or c.name ilike '%' || btrim(p_query) || '%'
         or coalesce(c.city,'') ilike '%' || btrim(p_query) || '%')
  order by c.is_main desc, c.name asc
  limit least(greatest(p_limit, 1), 60);
$$;

-- -----------------------------------------------------------------------------
-- discover_users — the "Discover students" surface.
-- -----------------------------------------------------------------------------
create or replace function public.discover_users(
  p_university_id uuid default null,
  p_query text default null,
  p_limit integer default 12,
  p_offset integer default 0
)
returns table (
  id uuid, username text, display_name text, avatar_url text, bio text,
  university_name text, university_abbreviation text, campus_name text,
  channels_joined integer, created_at timestamptz
)
language sql
stable
security definer
set search_path = public
as $$
  select pr.id, pr.username, pr.display_name, pr.avatar_url,
         case when pr.profile_visibility = 'private' then null else pr.bio end,
         u.name, u.abbreviation, camp.name,
         (select count(*)::integer from public.channel_members cm where cm.user_id = pr.id),
         pr.created_at
  from public.profiles pr
  left join public.universities u on u.id = pr.university_id
  left join public.campuses camp on camp.id = pr.campus_id
  where pr.profile_visibility <> 'private'
    and not pr.is_suspended
    and pr.onboarding_completed
    and (p_university_id is null or pr.university_id = p_university_id)
    and (p_query is null or btrim(p_query) = '' or pr.username ilike '%' || btrim(p_query) || '%'
         or pr.display_name ilike '%' || btrim(p_query) || '%')
    and not public.is_blocked_pair(auth.uid(), pr.id)
  order by pr.last_active_at desc
  limit least(greatest(p_limit, 1), 40)
  offset greatest(p_offset, 0);
$$;

create or replace function public.unread_notification_count()
returns integer
language sql
stable
security definer
set search_path = public
as $$
  select count(*)::integer from public.notifications
  where recipient_id = auth.uid() and not is_read;
$$;

-- -----------------------------------------------------------------------------
-- saved_posts_feed / my_drafts — private surfaces
-- -----------------------------------------------------------------------------
create or replace function public.saved_posts_feed(p_limit integer default 20, p_offset integer default 0)
returns table (
  id uuid, channel_id uuid, channel_slug text, channel_name text, campus_name text,
  university_id uuid, university_name text, university_abbreviation text, university_slug text,
  city text, body text, is_anonymous boolean, category public.post_category,
  media_path text, media_width integer, media_height integer,
  moderation_status public.moderation_status, like_count integer, comment_count integer,
  share_count integer, is_pinned boolean, edited_at timestamptz, created_at timestamptz,
  author_id uuid, author_username text, author_display_name text, author_avatar_url text,
  viewer_has_liked boolean, viewer_has_saved boolean, viewer_can_manage boolean, poll jsonb,
  saved_at timestamptz
)
language plpgsql
stable
security definer
set search_path = public
as $$
declare
  v_ids uuid[];
begin
  select coalesce(array_agg(sp.post_id), '{}')
    into v_ids
    from public.saved_posts sp
    where sp.user_id = auth.uid();

  if array_length(v_ids, 1) is null then
    return;
  end if;

  return query
    select f.*, sp.created_at
    from public.feed_posts(null, 'latest', null, null, 0, 50, null, null, false, null, v_ids) f
    join public.saved_posts sp on sp.post_id = f.id and sp.user_id = auth.uid()
    order by sp.created_at desc
    limit least(greatest(p_limit, 1), 50);
end;
$$;

-- -----------------------------------------------------------------------------
-- weekly_highlights — genuinely top posts of the last 7 days.
-- -----------------------------------------------------------------------------
create or replace function public.weekly_highlights(p_limit integer default 5)
returns table (
  id uuid, channel_id uuid, channel_slug text, channel_name text, campus_name text,
  university_id uuid, university_name text, university_abbreviation text, university_slug text,
  city text, body text, is_anonymous boolean, category public.post_category,
  media_path text, media_width integer, media_height integer,
  moderation_status public.moderation_status, like_count integer, comment_count integer,
  share_count integer, is_pinned boolean, edited_at timestamptz, created_at timestamptz,
  author_id uuid, author_username text, author_display_name text, author_avatar_url text,
  viewer_has_liked boolean, viewer_has_saved boolean, viewer_can_manage boolean, poll jsonb
)
language sql
stable
security definer
set search_path = public
as $$
  select f.* from public.feed_posts(null, 'trending', null, null, 0, 24) f
  where f.created_at > now() - interval '7 days'
  order by (f.like_count * 2 + f.comment_count * 3) desc, f.created_at desc
  limit least(greatest(p_limit, 1), 20);
$$;


-- -----------------------------------------------------------------------------
-- catalogue_counts — real, live size of the university catalogue.
-- Used by the landing page and onboarding instead of any hardcoded figure.
-- -----------------------------------------------------------------------------
create or replace function public.catalogue_counts()
returns jsonb
language sql
stable
security definer
set search_path = public
as $$
  select jsonb_build_object(
    'universities', (select count(*) from public.universities where is_active and status = 'active'),
    'campuses',     (select count(*) from public.campuses c
                      join public.universities u on u.id = c.university_id
                      where c.is_active and u.is_active and u.status = 'active'),
    'channels',     (select count(*) from public.channels c
                      join public.universities u on u.id = c.university_id
                      where c.is_active and u.is_active and u.status = 'active'),
    'provinces',    (select count(distinct province) from public.universities
                      where is_active and status = 'active' and province is not null),
    'cities',       (select count(distinct city) from public.universities
                      where is_active and status = 'active' and city is not null)
  );
$$;


-- -----------------------------------------------------------------------------
-- resolve_*_mentions — mention rendering.
--
-- Only handles that were *stored* when the post or comment was written resolve,
-- and resolution is by user id, never by re-parsing a username out of the body.
-- A handle that no longer exists therefore degrades to plain text instead of
-- becoming a dead or misleading link. Usernames are public, so this reveals
-- nothing about authorship — including for anonymous posts.
-- -----------------------------------------------------------------------------
create or replace function public.resolve_post_mentions(p_post_ids uuid[], p_comment_ids uuid[])
returns table (source_id uuid, handle text, username text)
language sql
stable
security definer
set search_path = public
as $$
  select m.source_id, lower(pr.username) as handle, pr.username
  from public.mentions m
  join public.profiles pr on pr.id = m.mentioned_user_id
  where (m.source_type = 'post' and m.source_id = any (coalesce(p_post_ids, '{}')))
     or (m.source_type = 'comment' and m.source_id = any (coalesce(p_comment_ids, '{}')));
$$;


-- -----------------------------------------------------------------------------
-- Denormalised parent keys are derived, never trusted from the client.
--
-- `posts.university_id` and `channel_members.university_id` exist so that the
-- common "everything in my university" queries do not need a join. They are set
-- here, from the channel row, so a crafted insert cannot claim that a post
-- belongs to a different institution than the channel it was posted in.
-- -----------------------------------------------------------------------------
create or replace function public.tg_derive_post_university()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  select c.university_id into new.university_id from public.channels c where c.id = new.channel_id;
  if new.university_id is null then
    raise exception 'unknown channel' using errcode = '23503';
  end if;
  return new;
end $$;

drop trigger if exists posts_derive_university on public.posts;
create trigger posts_derive_university
  before insert or update of channel_id on public.posts
  for each row execute function public.tg_derive_post_university();

create or replace function public.tg_derive_member_university()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  select c.university_id into new.university_id from public.channels c where c.id = new.channel_id;
  if new.university_id is null then
    raise exception 'unknown channel' using errcode = '23503';
  end if;
  return new;
end $$;

drop trigger if exists channel_members_derive_university on public.channel_members;
create trigger channel_members_derive_university
  before insert or update of channel_id on public.channel_members
  for each row execute function public.tg_derive_member_university();
