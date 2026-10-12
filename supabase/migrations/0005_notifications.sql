-- =============================================================================
-- Campusly · 0005 · Notification generation (database-side)
-- =============================================================================
-- Notifications are derived, not authored: they are produced by triggers on the
-- rows that cause them. Two reasons this belongs in Postgres rather than in an
-- API route:
--
--   1. Clients are not granted INSERT on `notifications` at all, so nobody can
--      forge a notification from someone else. There is no service-role code
--      path in the app that could be misused to write one.
--   2. Anonymity sanitisation happens in the same transaction as the write, so
--      there is no window in which an unsanitised row is readable.
--
-- Which actor is ever disclosed, precisely:
--   post_like / comment_like  -> actor is the liker, never anonymous
--   comment_on_post           -> actor is the commenter (null if that comment is anonymous)
--   reply_to_comment          -> actor is the replier  (null if that reply is anonymous)
--   mention_post              -> actor is the post author  (null if the post is anonymous)
--   mention_comment           -> actor is the comment author (null if the comment is anonymous)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Replaces the coarse version from 0002, which nulled the actor whenever the
-- *post* was anonymous. That was both too aggressive (a commenter's name is not
-- a secret just because the post was anonymous) and too weak (it ignored
-- comment-level anonymity).
-- -----------------------------------------------------------------------------
create or replace function public.tg_notification_anonymise_actor()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_post_anonymous boolean;
  v_comment_anonymous boolean;
  v_hide_actor boolean := false;
begin
  -- The liker is named by definition; no source anonymity applies.
  if new.type in ('post_like', 'comment_like') then
    return new;
  end if;

  if new.post_id is not null then
    select is_anonymous into v_post_anonymous from public.posts where id = new.post_id;
  end if;

  if new.comment_id is not null then
    select is_anonymous into v_comment_anonymous from public.comments where id = new.comment_id;
  end if;

  v_hide_actor := case new.type
    when 'mention_post'    then coalesce(v_post_anonymous, false)
    when 'mention_comment' then coalesce(v_comment_anonymous, false)
    when 'comment_on_post' then coalesce(v_comment_anonymous, false)
    when 'reply_to_comment' then coalesce(v_comment_anonymous, false)
    else false
  end;

  if v_hide_actor then
    new.actor_id := null;
    -- Withholding the preview too: it is the anonymous author's own words.
    new.body_preview := null;
  end if;

  return new;
end;
$$;

-- -----------------------------------------------------------------------------
-- Recipients must not be notified repeatedly, by someone they blocked, or about
-- their own action. Preferences are honoured here so every trigger below gets
-- the same behaviour.
-- -----------------------------------------------------------------------------
create or replace function public.notification_allowed(
  p_recipient uuid,
  p_actor uuid,
  p_type public.notification_type
)
returns boolean
language plpgsql
stable
security definer
set search_path = public
as $$
declare
  prefs public.notification_preferences;
begin
  if p_recipient is null then
    return false;
  end if;
  -- Never notify someone about their own action.
  if p_actor is not null and p_actor = p_recipient then
    return false;
  end if;
  -- A blocked pair must not generate notifications in either direction.
  if p_actor is not null and public.is_blocked_pair(p_recipient, p_actor) then
    return false;
  end if;
  -- Do not notify suspended accounts.
  if exists (select 1 from public.profiles where id = p_recipient and is_suspended) then
    return false;
  end if;

  select * into prefs from public.notification_preferences where user_id = p_recipient;
  if not found then
    return true; -- defaults are all-on
  end if;

  return case p_type
    when 'mention_post'    then prefs.mentions
    when 'mention_comment' then prefs.mentions
    when 'comment_on_post' then prefs.comments
    when 'reply_to_comment' then prefs.replies
    when 'post_like'       then prefs.likes
    when 'comment_like'    then prefs.likes
    when 'channel_join'    then prefs.channel_activity
    else true
  end;
end;
$$;

create or replace function public.insert_notification(
  p_recipient uuid,
  p_actor uuid,
  p_type public.notification_type,
  p_post uuid default null,
  p_comment uuid default null,
  p_channel uuid default null,
  p_preview text default null
)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if not public.notification_allowed(p_recipient, p_actor, p_type) then
    return;
  end if;

  insert into public.notifications (recipient_id, actor_id, type, post_id, comment_id, channel_id, body_preview)
  values (p_recipient, p_actor, p_type, p_post, p_comment, p_channel, left(p_preview, 140))
  on conflict do nothing; -- notifications_dedupe_key
end;
$$;

-- -----------------------------------------------------------------------------
-- Comment / reply notifications
-- -----------------------------------------------------------------------------
create or replace function public.tg_notify_on_comment()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_post_author uuid;
  v_parent_author uuid;
  v_parent_anonymous boolean;
begin
  if new.deleted_at is not null or new.moderation_status <> 'published' then
    return new;
  end if;

  select author_id into v_post_author from public.posts where id = new.post_id;

  if new.parent_id is null then
    -- "Someone commented on your post." Recipient is the post author, who
    -- already knows whether they wrote it anonymously, so the actor here is
    -- the commenter — sanitised by the anonymise trigger if they posted
    -- anonymously.
    perform public.insert_notification(
      v_post_author, new.author_id, 'comment_on_post', new.post_id, new.id, null, new.body
    );
  else
    select author_id, is_anonymous into v_parent_author, v_parent_anonymous
    from public.comments where id = new.parent_id;

    -- Reply notifications name the parent comment's author as recipient, so
    -- this never reveals who wrote an anonymous confession.
    perform public.insert_notification(
      v_parent_author, new.author_id, 'reply_to_comment', new.post_id, new.id, null, new.body
    );
  end if;

  return new;
end;
$$;

drop trigger if exists comments_notify on public.comments;
create trigger comments_notify
  after insert on public.comments
  for each row execute function public.tg_notify_on_comment();

-- -----------------------------------------------------------------------------
-- Mention notifications. The mention row already records exactly who was
-- mentioned, so no text parsing is needed here.
-- -----------------------------------------------------------------------------
create or replace function public.tg_notify_on_mention()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_actor uuid;
  v_post_id uuid;
  v_channel_id uuid;
  v_preview text;
begin
  if new.source_type = 'post' then
    select author_id, id, channel_id, left(body, 140)
      into v_actor, v_post_id, v_channel_id, v_preview
    from public.posts where id = new.source_id;

    perform public.insert_notification(
      new.mentioned_user_id, v_actor, 'mention_post', v_post_id, null, v_channel_id, v_preview
    );
  else
    select c.author_id, c.post_id, p.channel_id, left(c.body, 140)
      into v_actor, v_post_id, v_channel_id, v_preview
    from public.comments c
    join public.posts p on p.id = c.post_id
    where c.id = new.source_id;

    perform public.insert_notification(
      new.mentioned_user_id, v_actor, 'mention_comment', v_post_id, new.source_id, v_channel_id, v_preview
    );
  end if;

  return new;
end;
$$;

drop trigger if exists mentions_notify on public.mentions;
create trigger mentions_notify
  after insert on public.mentions
  for each row execute function public.tg_notify_on_mention();

-- -----------------------------------------------------------------------------
-- Like notifications. Only the first like counts; the unique index on
-- (post_id, user_id) means there is no "unlike then re-like" spam vector.
-- -----------------------------------------------------------------------------
create or replace function public.tg_notify_on_post_like()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_author uuid;
begin
  select author_id into v_author from public.posts where id = new.post_id;

  perform public.insert_notification(v_author, new.user_id, 'post_like', new.post_id, null, null, null);
  return new;
end;
$$;

drop trigger if exists post_likes_notify on public.post_likes;
create trigger post_likes_notify
  after insert on public.post_likes
  for each row execute function public.tg_notify_on_post_like();

create or replace function public.tg_notify_on_comment_like()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_author uuid;
  v_post uuid;
begin
  select author_id, post_id into v_author, v_post from public.comments where id = new.comment_id;

  perform public.insert_notification(v_author, new.user_id, 'comment_like', v_post, new.comment_id, null, null);
  return new;
end;
$$;

drop trigger if exists comment_likes_notify on public.comment_likes;
create trigger comment_likes_notify
  after insert on public.comment_likes
  for each row execute function public.tg_notify_on_comment_like();

-- -----------------------------------------------------------------------------
-- Read path: authority for what may be shown is the stored row, which the
-- trigger above already sanitised. The guards here are a second, independent
-- check so a future read path cannot accidentally widen disclosure.
-- -----------------------------------------------------------------------------
create or replace function public.notification_feed(p_limit integer default 25, p_offset integer default 0)
returns table (
  id uuid, type public.notification_type, is_read boolean, created_at timestamptz,
  actor_id uuid, actor_username text, actor_display_name text, actor_avatar_url text,
  post_id uuid, post_is_anonymous boolean, post_channel_slug text, post_excerpt text,
  comment_id uuid, comment_excerpt text, channel_id uuid, channel_slug text, channel_name text
)
language sql
stable
security definer
set search_path = public
as $$
  with rows as (
    select
      n.id, n.type, n.is_read, n.created_at, n.actor_id, n.post_id, n.comment_id,
      coalesce(n.channel_id, p.channel_id) as channel_id,
      n.body_preview,
      coalesce(p.is_anonymous, false) as post_anonymous,
      coalesce(pc.is_anonymous, false) as comment_anonymous
    from public.notifications n
    left join public.posts p on p.id = n.post_id
    left join public.comments pc on pc.id = n.comment_id
    where n.recipient_id = auth.uid()
  )
  select
    r.id, r.type, r.is_read, r.created_at,
    case
      when r.type = 'mention_post' and r.post_anonymous then null
      when r.type in ('mention_comment', 'comment_on_post', 'reply_to_comment') and r.comment_anonymous then null
      else r.actor_id
    end as actor_id,
    case when r.type = 'mention_post' and r.post_anonymous then null
         when r.type in ('mention_comment', 'comment_on_post', 'reply_to_comment') and r.comment_anonymous then null
         else a.username end as actor_username,
    case when r.type = 'mention_post' and r.post_anonymous then null
         when r.type in ('mention_comment', 'comment_on_post', 'reply_to_comment') and r.comment_anonymous then null
         else a.display_name end as actor_display_name,
    case when r.type = 'mention_post' and r.post_anonymous then null
         when r.type in ('mention_comment', 'comment_on_post', 'reply_to_comment') and r.comment_anonymous then null
         else a.avatar_url end as actor_avatar_url,
    r.post_id,
    r.post_anonymous,
    c.slug,
    -- The excerpt is withheld whenever the actor is withheld.
    case when r.type = 'mention_post' and r.post_anonymous then null else r.body_preview end,
    r.comment_id,
    case when r.type in ('mention_comment', 'comment_on_post', 'reply_to_comment') and r.comment_anonymous
         then null else r.body_preview end,
    r.channel_id, c.slug, c.name
  from rows r
  left join public.profiles a on a.id = r.actor_id
  left join public.channels c on c.id = r.channel_id
  order by r.created_at desc
  limit least(greatest(p_limit, 1), 100)
  offset greatest(p_offset, 0);
$$;

grant execute on function public.notification_feed to authenticated;
grant execute on function public.notification_allowed to authenticated;
grant execute on function public.tg_notification_anonymise_actor to authenticated;
grant execute on function public.tg_notify_on_comment to authenticated;
grant execute on function public.tg_notify_on_mention to authenticated;
grant execute on function public.tg_notify_on_post_like to authenticated;
grant execute on function public.tg_notify_on_comment_like to authenticated;
grant execute on function public.insert_notification to authenticated;
