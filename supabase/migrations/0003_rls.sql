-- =============================================================================
-- Campusly · 0003 · Row Level Security + column privileges
-- =============================================================================
-- Two independent layers protect anonymous identity:
--   Layer 1 (this file): `posts.author_id` is removed from the privilege set of
--     `anon` and `authenticated` entirely. A client asking PostgREST for
--     `select=author_id` gets a 42501 permission error, not a hidden value.
--   Layer 2 (0002): the only sanctioned reader is public.feed_posts() and
--     friends (SECURITY DEFINER), which null the value unless the caller is
--     the author. Moderators must call deanonymise_post(), which is audited.
-- Hiding the column also means `posts` cannot be joined to `profiles` by a
-- client to reconstruct authorship.
-- =============================================================================

alter table public.universities          enable row level security;
alter table public.campuses              enable row level security;
alter table public.channels              enable row level security;
alter table public.profiles              enable row level security;
alter table public.user_roles            enable row level security;
alter table public.channel_members       enable row level security;
alter table public.posts                 enable row level security;
alter table public.comments              enable row level security;
alter table public.post_likes            enable row level security;
alter table public.comment_likes         enable row level security;
alter table public.mentions              enable row level security;
alter table public.notifications         enable row level security;
alter table public.notification_preferences enable row level security;
alter table public.saved_posts           enable row level security;
alter table public.drafts                enable row level security;
alter table public.blocked_users         enable row level security;
alter table public.channel_mutes         enable row level security;
alter table public.polls                 enable row level security;
alter table public.poll_options          enable row level security;
alter table public.poll_votes            enable row level security;
alter table public.reports               enable row level security;
alter table public.moderation_actions    enable row level security;
alter table public.audit_log             enable row level security;
alter table public.rate_limit_events     enable row level security;
alter table public.search_history        enable row level security;
alter table public.post_shares           enable row level security;

-- -----------------------------------------------------------------------------
-- Layer 1 · column privileges
-- -----------------------------------------------------------------------------
revoke all on all tables    in schema public from anon, authenticated;
revoke all on all sequences in schema public from anon, authenticated;
revoke all on all functions in schema public from anon, authenticated;

grant usage on schema public to anon, authenticated;

-- Catalogue: fully readable.
grant select on public.universities, public.campuses, public.channels to anon, authenticated;

-- Profiles: readable, but a client may never write the derived/private columns.
grant select on public.profiles to anon, authenticated;
grant update (display_name, username, avatar_url, banner_url, bio, university_id, campus_id,
              country, degree_program, department, semester, graduation_year, interests,
              profile_visibility, onboarding_step, onboarding_completed, last_active_at, username_changed_at)
      on public.profiles to authenticated;

-- Channel membership: insert/delete only; the unique index prevents duplicates.
grant select, insert, delete on public.channel_members to authenticated;
grant update (is_muted) on public.channel_members to authenticated;

-- Posts ---------------------------------------------------------------------
-- NOTE the deliberate omission of `author_id`. This is the core privacy control.
grant select (id, channel_id, university_id, body, is_anonymous, category,
              media_path, media_width, media_height, link_preview, moderation_status,
              like_count, comment_count, share_count, is_pinned, edited_at,
              search_vector, created_at, updated_at, deleted_at)
      on public.posts to authenticated;

grant insert (channel_id, university_id, author_id, body, is_anonymous, category, media_path)
      on public.posts to authenticated;
grant update (body, category, media_path, deleted_at, edited_at, is_pinned)
      on public.posts to authenticated;
grant delete on public.posts to authenticated;

-- Comments ------------------------------------------------------------------
grant select (id, post_id, parent_id, root_id, depth, body, is_anonymous,
              moderation_status, like_count, reply_count, edited_at,
              search_vector, created_at, updated_at, deleted_at)
      on public.comments to authenticated;
grant insert (post_id, author_id, parent_id, body, is_anonymous) on public.comments to authenticated;
grant update (body, deleted_at, edited_at) on public.comments to authenticated;
grant delete on public.comments to authenticated;

-- Reactions, saves, mutes, blocks, polls ------------------------------------
grant select, insert, delete on public.post_likes, public.comment_likes to authenticated;
grant select, insert, delete on public.saved_posts to authenticated;
grant select, insert, delete on public.blocked_users to authenticated;
grant select, insert, delete on public.channel_mutes to authenticated;
grant select, insert, delete on public.drafts to authenticated;
grant update (body, is_anonymous, category, media_path, channel_id) on public.drafts to authenticated;

grant select on public.polls, public.poll_options to authenticated;
grant insert on public.poll_votes to authenticated;
grant select, delete on public.poll_votes to authenticated;

-- Mentions: readable, but writes are constrained to the caller's own content.
grant select on public.mentions to authenticated;
grant insert, delete on public.mentions to authenticated;

-- Notifications & preferences ----------------------------------------------
grant select on public.notifications to authenticated;
grant update (is_read) on public.notifications to authenticated;
grant delete on public.notifications to authenticated;
grant select, insert, update on public.notification_preferences to authenticated;

-- Reports: reporters may create and read their own; moderators are handled by
-- the RLS policies below, not by grants.
grant insert, select on public.reports to authenticated;

-- Search history is private to its owner.
grant select, insert, delete on public.search_history to authenticated;

-- Share counting.
grant insert on public.post_shares to authenticated;

-- Moderation tables: moderators act through SECURITY DEFINER RPCs, so no
-- blanket grants here. Admin catalogue management is granted narrowly.
grant select on public.moderation_actions, public.audit_log to authenticated;
grant insert, update on public.moderation_actions to authenticated;

-- Catalogue management (guarded by the is_admin() policies below).
grant insert, update, delete on public.universities, public.campuses, public.channels to authenticated;
grant insert, update, delete on public.reports to authenticated;
grant insert, update on public.user_roles to authenticated;
grant select on public.user_roles to authenticated;
grant select, insert, update, delete on public.rate_limit_events to authenticated;

-- Sequences used by identity/serial columns.
grant usage, select on all sequences in schema public to authenticated;

-- -----------------------------------------------------------------------------
-- RPC grants — the sanctioned read surface
-- -----------------------------------------------------------------------------
grant execute on function public.feed_posts to anon, authenticated;
grant execute on function public.get_post to anon, authenticated;
grant execute on function public.post_comments to anon, authenticated;
grant execute on function public.comment_replies to anon, authenticated;
grant execute on function public.profile_public to anon, authenticated;
grant execute on function public.profile_posts to anon, authenticated;
grant execute on function public.my_confessions to authenticated;
grant execute on function public.search_all to anon, authenticated;
grant execute on function public.trending_topics to anon, authenticated;
grant execute on function public.channel_overview to anon, authenticated;
grant execute on function public.university_cards to anon, authenticated;
grant execute on function public.university_choices to anon, authenticated;
grant execute on function public.campus_choices to anon, authenticated;
grant execute on function public.discover_users to anon, authenticated;
grant execute on function public.my_channels to authenticated;
grant execute on function public.recommended_channels to authenticated;
grant execute on function public.unread_notification_count to authenticated;
grant execute on function public.saved_posts_feed to authenticated;
grant execute on function public.weekly_highlights to anon, authenticated;
grant execute on function public.platform_stats to authenticated;
grant execute on function public.moderation_queue to authenticated;
grant execute on function public.deanonymise_post to authenticated;
grant execute on function public.current_app_role to authenticated;
grant execute on function public.is_moderator to authenticated;
grant execute on function public.is_admin to authenticated;
grant execute on function public.is_suspended to authenticated;
grant execute on function public.is_blocked_pair to authenticated;
grant execute on function public.rate_limit_check to authenticated;
grant execute on function public.post_media_url to anon, authenticated;
grant execute on function public.catalogue_counts to anon, authenticated;
grant execute on function public.resolve_post_mentions to anon, authenticated;

grant execute on function public.tg_touch_updated_at to authenticated;
grant execute on function public.tg_post_like_counters to authenticated;
grant execute on function public.tg_comment_like_counters to authenticated;
grant execute on function public.tg_comment_counters to authenticated;
grant execute on function public.tg_poll_vote_counters to authenticated;
grant execute on function public.tg_comment_thread_shape to authenticated;
grant execute on function public.tg_handle_new_user to authenticated;

-- =============================================================================
-- POLICIES
-- =============================================================================

-- ---------------------------------------------------------------- universities
drop policy if exists universities_read on public.universities;
create policy universities_read on public.universities
  for select using (is_active and status = 'active' or public.is_moderator());

drop policy if exists universities_admin_insert on public.universities;
create policy universities_admin_insert on public.universities
  for insert with check (public.is_admin());

drop policy if exists universities_admin_update on public.universities;
create policy universities_admin_update on public.universities
  for update using (public.is_admin()) with check (public.is_admin());

drop policy if exists universities_admin_delete on public.universities;
create policy universities_admin_delete on public.universities
  for delete using (public.is_admin());

-- --------------------------------------------------------------------- campuses
drop policy if exists campuses_read on public.campuses;
create policy campuses_read on public.campuses
  for select using (
    (is_active and exists (select 1 from public.universities u
                            where u.id = university_id and u.is_active and u.status = 'active'))
    or public.is_moderator()
  );

drop policy if exists campuses_admin_write on public.campuses;
create policy campuses_admin_write on public.campuses
  for all using (public.is_admin()) with check (public.is_admin());

-- ---------------------------------------------------------------------- channels
drop policy if exists channels_read on public.channels;
create policy channels_read on public.channels
  for select using (
    (is_active and exists (select 1 from public.universities u
                            where u.id = university_id and u.is_active and u.status = 'active'))
    or public.is_moderator()
  );

drop policy if exists channels_admin_write on public.channels;
create policy channels_admin_write on public.channels
  for all using (public.is_admin()) with check (public.is_admin());

-- ---------------------------------------------------------------------- profiles
-- Anyone (including signed-out visitors) may read a profile row. The RPC layer
-- decides which *fields* are visible for private profiles; the row itself is
-- needed for author attribution on public posts.
drop policy if exists profiles_read on public.profiles;
create policy profiles_read on public.profiles
  for select using (true);

drop policy if exists profiles_update_own on public.profiles;
create policy profiles_update_own on public.profiles
  for update using (auth.uid() = id) with check (auth.uid() = id);

-- Suspension is a moderator-only field; the column grant already excludes it
-- from the authenticated update set, and this policy documents the intent.
drop policy if exists profiles_insert_own on public.profiles;
create policy profiles_insert_own on public.profiles
  for insert with check (auth.uid() = id);

drop policy if exists profiles_moderator_write on public.profiles;
create policy profiles_moderator_write on public.profiles
  for update using (public.is_moderator()) with check (public.is_moderator());

-- ------------------------------------------------------------------- user_roles
-- Read your own role (needed to render moderation nav) and moderators read all.
-- No policy grants INSERT/UPDATE/DELETE to non-admins: a user cannot promote
-- themselves even with a crafted PostgREST request.
drop policy if exists user_roles_read on public.user_roles;
create policy user_roles_read on public.user_roles
  for select using (user_id = auth.uid() or public.is_admin());

drop policy if exists user_roles_admin_insert on public.user_roles;
create policy user_roles_admin_insert on public.user_roles
  for insert with check (public.is_admin());

drop policy if exists user_roles_admin_update on public.user_roles;
create policy user_roles_admin_update on public.user_roles
  for update using (public.is_admin()) with check (public.is_admin());

drop policy if exists user_roles_admin_delete on public.user_roles;
create policy user_roles_admin_delete on public.user_roles
  for delete using (public.is_admin());

-- -------------------------------------------------------------- channel_members
drop policy if exists channel_members_read on public.channel_members;
create policy channel_members_read on public.channel_members
  for select using (true);

-- Joining: authenticated, for a live channel, not suspended. The unique index
-- guarantees the "exactly one membership" requirement under concurrency.
drop policy if exists channel_members_join on public.channel_members;
create policy channel_members_join on public.channel_members
  for insert with check (
    auth.uid() = user_id
    and not public.is_suspended(auth.uid())
    and exists (select 1 from public.channels c where c.id = channel_id and c.is_active)
  );

drop policy if exists channel_members_leave on public.channel_members;
create policy channel_members_leave on public.channel_members
  for delete using (auth.uid() = user_id or public.is_moderator());

drop policy if exists channel_members_mute_own on public.channel_members;
create policy channel_members_mute_own on public.channel_members
  for update using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- ----------------------------------------------------------------------- posts
-- Row visibility for direct table access. Reads in the app go through
-- feed_posts(); this policy exists so that any direct query is still safe.
drop policy if exists posts_read on public.posts;
create policy posts_read on public.posts
  for select using (
    (
      deleted_at is null
      and moderation_status = 'published'
      and not exists (select 1 from public.profiles pr where pr.id = author_id and pr.is_suspended)
    )
    or auth.uid() = author_id
    or public.is_moderator()
  );

-- Publishing: own identity only, live channel, not suspended, and the channel
-- policy must permit it.
drop policy if exists posts_insert on public.posts;
create policy posts_insert on public.posts
  for insert with check (
    auth.uid() = author_id
    and not public.is_suspended(auth.uid())
    and exists (
      select 1 from public.channels c
      where c.id = channel_id
        and c.is_active
        and c.university_id = university_id
        and (
          c.posting_policy = 'anyone_authenticated'
          or (c.posting_policy = 'members' and exists (
                select 1 from public.channel_members cm
                where cm.channel_id = c.id and cm.user_id = auth.uid()))
          or public.is_moderator()
        )
    )
  );

drop policy if exists posts_update_own on public.posts;
create policy posts_update_own on public.posts
  for update using (auth.uid() = author_id) with check (auth.uid() = author_id);

drop policy if exists posts_moderator_update on public.posts;
create policy posts_moderator_update on public.posts
  for update using (public.is_moderator()) with check (public.is_moderator());

drop policy if exists posts_delete_own on public.posts;
create policy posts_delete_own on public.posts
  for delete using (auth.uid() = author_id or public.is_moderator());

-- -------------------------------------------------------------------- comments
drop policy if exists comments_read on public.comments;
create policy comments_read on public.comments
  for select using (
    (
      deleted_at is null
      and moderation_status = 'published'
      and not exists (select 1 from public.profiles pr where pr.id = author_id and pr.is_suspended)
      and exists (select 1 from public.posts p where p.id = post_id and p.deleted_at is null)
    )
    or auth.uid() = author_id
    or public.is_moderator()
  );

drop policy if exists comments_insert on public.comments;
create policy comments_insert on public.comments
  for insert with check (
    auth.uid() = author_id
    and not public.is_suspended(auth.uid())
    and exists (
      select 1 from public.posts p
      where p.id = post_id
        and p.deleted_at is null
        and p.moderation_status = 'published'
    )
  );

drop policy if exists comments_update_own on public.comments;
create policy comments_update_own on public.comments
  for update using (auth.uid() = author_id) with check (auth.uid() = author_id);

drop policy if exists comments_moderator_update on public.comments;
create policy comments_moderator_update on public.comments
  for update using (public.is_moderator()) with check (public.is_moderator());

drop policy if exists comments_delete_own on public.comments;
create policy comments_delete_own on public.comments
  for delete using (auth.uid() = author_id or public.is_moderator());

-- ------------------------------------------------------------------ post_likes
drop policy if exists post_likes_read on public.post_likes;
create policy post_likes_read on public.post_likes
  for select using (true);

drop policy if exists post_likes_write on public.post_likes;
create policy post_likes_write on public.post_likes
  for insert with check (
    auth.uid() = user_id
    and not public.is_suspended(auth.uid())
    and exists (select 1 from public.posts p where p.id = post_id and p.deleted_at is null)
  );

drop policy if exists post_likes_delete on public.post_likes;
create policy post_likes_delete on public.post_likes
  for delete using (auth.uid() = user_id);

-- --------------------------------------------------------------- comment_likes
drop policy if exists comment_likes_read on public.comment_likes;
create policy comment_likes_read on public.comment_likes
  for select using (true);

drop policy if exists comment_likes_write on public.comment_likes;
create policy comment_likes_write on public.comment_likes
  for insert with check (auth.uid() = user_id and not public.is_suspended(auth.uid()));

drop policy if exists comment_likes_delete on public.comment_likes;
create policy comment_likes_delete on public.comment_likes
  for delete using (auth.uid() = user_id);

-- -------------------------------------------------------------------- mentions
-- A mention record may only be created by the author of the source content,
-- and only against a user the source author can actually see.
drop policy if exists mentions_read on public.mentions;
create policy mentions_read on public.mentions
  for select using (true);

drop policy if exists mentions_insert on public.mentions;
create policy mentions_insert on public.mentions
  for insert with check (
    not public.is_suspended(auth.uid())
    and mentioned_user_id <> auth.uid()
    and case source_type
          when 'post' then exists (
            select 1 from public.posts p where p.id = source_id and p.author_id = auth.uid())
          when 'comment' then exists (
            select 1 from public.comments c where c.id = source_id and c.author_id = auth.uid())
        end
  );

drop policy if exists mentions_delete on public.mentions;
create policy mentions_delete on public.mentions
  for delete using (
    exists (select 1 from public.posts p where p.id = source_id and p.author_id = auth.uid())
    or exists (select 1 from public.comments c where c.id = source_id and c.author_id = auth.uid())
    or public.is_moderator()
  );

-- --------------------------------------------------------------- notifications
-- Strictly the recipient's own rows. Nobody can read or forge another user's
-- notifications; they are only ever written by SECURITY DEFINER triggers.
drop policy if exists notifications_read_own on public.notifications;
create policy notifications_read_own on public.notifications
  for select using (recipient_id = auth.uid());

drop policy if exists notifications_update_own on public.notifications;
create policy notifications_update_own on public.notifications
  for update using (recipient_id = auth.uid()) with check (recipient_id = auth.uid());

drop policy if exists notifications_delete_own on public.notifications;
create policy notifications_delete_own on public.notifications
  for delete using (recipient_id = auth.uid());

drop policy if exists notification_prefs_own on public.notification_preferences;
create policy notification_prefs_own on public.notification_preferences
  for all using (user_id = auth.uid()) with check (user_id = auth.uid());

-- ------------------------------------------------------------- saved_posts etc.
drop policy if exists saved_posts_own on public.saved_posts;
create policy saved_posts_own on public.saved_posts
  for all using (user_id = auth.uid()) with check (user_id = auth.uid());

drop policy if exists drafts_own on public.drafts;
create policy drafts_own on public.drafts
  for all using (user_id = auth.uid()) with check (user_id = auth.uid());

drop policy if exists blocked_users_own on public.blocked_users;
create policy blocked_users_own on public.blocked_users
  for all using (blocker_id = auth.uid()) with check (blocker_id = auth.uid());

drop policy if exists channel_mutes_own on public.channel_mutes;
create policy channel_mutes_own on public.channel_mutes
  for all using (user_id = auth.uid()) with check (user_id = auth.uid());

drop policy if exists search_history_own on public.search_history;
create policy search_history_own on public.search_history
  for all using (user_id = auth.uid()) with check (user_id = auth.uid());

drop policy if exists post_shares_insert on public.post_shares;
create policy post_shares_insert on public.post_shares
  for insert with check (user_id is null or user_id = auth.uid());

-- ----------------------------------------------------------------------- polls
drop policy if exists polls_read on public.polls;
create policy polls_read on public.polls
  for select using (exists (select 1 from public.posts p where p.id = post_id and p.deleted_at is null));

drop policy if exists polls_insert on public.polls;
create policy polls_insert on public.polls
  for insert with check (exists (select 1 from public.posts p where p.id = post_id and p.author_id = auth.uid()));

drop policy if exists poll_options_read on public.poll_options;
create policy poll_options_read on public.poll_options
  for select using (exists (select 1 from public.polls pl
                             join public.posts p on p.id = pl.post_id
                             where pl.id = poll_id and p.deleted_at is null));

drop policy if exists poll_options_insert on public.poll_options;
create policy poll_options_insert on public.poll_options
  for insert with check (exists (select 1 from public.polls pl
                                  join public.posts p on p.id = pl.post_id
                                  where pl.id = poll_id and p.author_id = auth.uid()));

-- One vote per option per user (unique index) and one option per user unless
-- the poll allows multiple answers.
drop policy if exists poll_votes_read on public.poll_votes;
create policy poll_votes_read on public.poll_votes
  for select using (user_id = auth.uid() or exists (select 1 from public.polls pl where pl.id = poll_id and not pl.anonymous_votes));

drop policy if exists poll_votes_insert on public.poll_votes;
create policy poll_votes_insert on public.poll_votes
  for insert with check (
    auth.uid() = user_id
    and not public.is_suspended(auth.uid())
    and exists (
      select 1 from public.polls pl
      join public.posts p on p.id = pl.post_id
      where pl.id = poll_id
        and p.deleted_at is null
        and (pl.closes_at is null or pl.closes_at > now())
        and (pl.allow_multiple or not exists (
              select 1 from public.poll_votes pv where pv.poll_id = poll_id and pv.user_id = auth.uid()))
    )
  );

drop policy if exists poll_votes_delete_own on public.poll_votes;
create policy poll_votes_delete_own on public.poll_votes
  for delete using (user_id = auth.uid());

-- --------------------------------------------------------------------- reports
-- Reporters see only their own reports. Moderators see everything.
drop policy if exists reports_read on public.reports;
create policy reports_read on public.reports
  for select using (reporter_id = auth.uid() or public.is_moderator());

drop policy if exists reports_insert on public.reports;
create policy reports_insert on public.reports
  for insert with check (auth.uid() = reporter_id and not public.is_suspended(auth.uid()));

drop policy if exists reports_moderator_update on public.reports;
create policy reports_moderator_update on public.reports
  for update using (public.is_moderator()) with check (public.is_moderator());

-- ------------------------------------------------------- moderation & audit
drop policy if exists moderation_actions_read on public.moderation_actions;
create policy moderation_actions_read on public.moderation_actions
  for select using (public.is_moderator());

drop policy if exists moderation_actions_insert on public.moderation_actions;
create policy moderation_actions_insert on public.moderation_actions
  for insert with check (public.is_moderator() and moderator_id = auth.uid());

drop policy if exists audit_log_read on public.audit_log;
create policy audit_log_read on public.audit_log
  for select using (public.is_admin());

-- ------------------------------------------------------------------ rate limits
drop policy if exists rate_limit_own on public.rate_limit_events;
create policy rate_limit_own on public.rate_limit_events
  for select using (user_id = auth.uid() or public.is_admin());

drop policy if exists rate_limit_insert on public.rate_limit_events;
create policy rate_limit_insert on public.rate_limit_events
  for insert with check (user_id = auth.uid());
