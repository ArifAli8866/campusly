-- =============================================================================
-- Campusly · 0006 · University & Channel Routing Fixes
-- =============================================================================
-- Solves the "We could not find that page" issue when clicking university channels:
-- 1. Enhances channel_overview to resolve channel by channel slug, campus slug,
--    university slug, acronym, or alias.
-- 2. Enhances university_cards to map campus items directly to active channel
--    IDs and slugs with accurate membership counts, and allows slug filtering.
-- 3. Activates all higher education institutions in the national directory.
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. Enhanced channel_overview: multi-strategy slug resolution
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
  cleaned_slug text := btrim(lower(coalesce(p_slug, '')));
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
        'id', c2.id,
        'slug', c2.slug,
        'campus_id', camp2.id,
        'campus_slug', camp2.slug,
        'campus_name', camp2.name,
        'city', camp2.city,
        'member_count', (select count(*) from public.channel_members cm2 where cm2.channel_id = c2.id)
      ) order by camp2.is_main desc, camp2.name asc), '[]'::jsonb)
      from public.channels c2
      join public.campuses camp2 on camp2.id = c2.campus_id
      where c2.university_id = c.university_id and c2.id <> c.id and c2.is_active
    )
  ) into result
  from public.channels c
  join public.universities u on u.id = c.university_id
  join public.campuses camp on camp.id = c.campus_id
  where (
    c.slug = cleaned_slug
    or camp.slug = cleaned_slug
    or u.slug = cleaned_slug
    or lower(coalesce(u.abbreviation, '')) = cleaned_slug
    or lower(regexp_replace(coalesce(u.abbreviation, ''), '[^a-zA-Z0-9]+', '-', 'g')) = cleaned_slug
    or lower(regexp_replace(coalesce(u.abbreviation, ''), '[^a-zA-Z0-9]+', '-', 'g') || '-' || lower(regexp_replace(coalesce(camp.city, camp.name), '[^a-zA-Z0-9]+', '-', 'g'))) = cleaned_slug
    or (
      coalesce(u.abbreviation, '') <> '' and coalesce(camp.city, '') <> ''
      and cleaned_slug ilike lower(regexp_replace(u.abbreviation, '[^a-zA-Z0-9]+', '-', 'g')) || '%'
      and cleaned_slug ilike '%' || lower(regexp_replace(camp.city, '[^a-zA-Z0-9]+', '-', 'g')) || '%'
    )
    or exists (
      select 1 from unnest(u.aliases) a
      where lower(regexp_replace(a, '[^a-zA-Z0-9]+', '-', 'g')) = cleaned_slug
         or lower(a) = cleaned_slug
    )
    or c.slug ilike '%' || cleaned_slug || '%'
    or cleaned_slug ilike '%' || c.slug || '%'
  )
  and c.is_active and u.is_active
  order by
    case
      when c.slug = cleaned_slug then 1
      when camp.slug = cleaned_slug then 2
      when lower(regexp_replace(coalesce(u.abbreviation, ''), '[^a-zA-Z0-9]+', '-', 'g') || '-' || lower(regexp_replace(coalesce(camp.city, camp.name), '[^a-zA-Z0-9]+', '-', 'g'))) = cleaned_slug then 3
      when u.slug = cleaned_slug and camp.is_main then 4
      when u.slug = cleaned_slug then 5
      when lower(coalesce(u.abbreviation, '')) = cleaned_slug and camp.is_main then 6
      when lower(coalesce(u.abbreviation, '')) = cleaned_slug then 7
      else 8
    end,
    camp.is_main desc,
    c.name asc
  limit 1;

  return result;
end;
$$;

grant execute on function public.channel_overview(text) to anon, authenticated;

-- -----------------------------------------------------------------------------
-- 2. Enhanced university_cards: slug lookups & channel mapping
-- -----------------------------------------------------------------------------
drop function if exists public.university_cards(text, text, text, text, text, integer, integer);
drop function if exists public.university_cards(text, text, text, text, text, integer, integer, text);

create or replace function public.university_cards(
  p_query text default null,
  p_province text default null,
  p_city text default null,
  p_type text default null,
  p_sort text default 'name',
  p_limit integer default 60,
  p_offset integer default 0,
  p_slug text default null
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
              'id', coalesce(ch.id, c.id),
              'campus_id', c.id,
              'slug', coalesce(ch.slug, c.slug),
              'channel_slug', coalesce(ch.slug, c.slug),
              'campus_slug', c.slug,
              'name', c.name,
              'city', c.city,
              'member_count', (select count(*) from public.channel_members cm2 where cm2.channel_id = ch.id)
            ) order by c.is_main desc, c.name asc), '[]'::jsonb)
     from public.campuses c
     left join public.channels ch on ch.campus_id = c.id
     where c.university_id = u.id and c.is_active)
  from public.universities u
  where u.is_active and u.status = 'active'
    and (p_slug is null or btrim(p_slug) = '' or
         u.slug = btrim(lower(p_slug)) or
         lower(coalesce(u.abbreviation, '')) = btrim(lower(p_slug)))
    and (p_query is null or btrim(p_query) = '' or
         u.name ilike '%' || btrim(p_query) || '%' or
         u.slug = btrim(lower(p_query)) or
         u.slug ilike '%' || btrim(lower(p_query)) || '%' or
         coalesce(u.abbreviation,'') ilike '%' || btrim(p_query) || '%' or
         lower(coalesce(u.abbreviation,'')) = btrim(lower(p_query)) or
         exists (select 1 from unnest(u.aliases) a where a ilike '%' || btrim(p_query) || '%' or lower(regexp_replace(a, '[^a-zA-Z0-9]+', '-', 'g')) = btrim(lower(p_query))) or
         coalesce(u.city,'') ilike '%' || btrim(p_query) || '%' or
         exists (select 1 from public.campuses c2 where c2.university_id = u.id and (c2.name ilike '%' || btrim(p_query) || '%' or c2.slug = btrim(lower(p_query)))) or
         exists (select 1 from public.channels ch2 where ch2.university_id = u.id and (ch2.slug = btrim(lower(p_query)) or ch2.name ilike '%' || btrim(p_query) || '%')))
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
  limit least(greatest(p_limit, 1), 600)
  offset greatest(p_offset, 0);
$$;

grant execute on function public.university_cards(text, text, text, text, text, integer, integer, text) to anon, authenticated;

-- -----------------------------------------------------------------------------
-- 3. Activate all institutions and campuses in the directory
-- -----------------------------------------------------------------------------
update public.universities
set status = 'active', is_active = true
where status = 'pending_review' or not is_active;

update public.campuses
set is_active = true
where not is_active;

update public.channels
set is_active = true
where not is_active;
