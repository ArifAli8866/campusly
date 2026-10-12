-- =============================================================================
-- Campusly · 0004 · Storage buckets & policies
-- =============================================================================
-- This migration only executes where Supabase Storage is present (i.e. on a
-- Supabase project). Local development uses the filesystem storage adapter
-- behind the same service interface — see src/server/storage/.
-- =============================================================================
do $$
begin
  if not exists (select 1 from information_schema.schemata where schema_name = 'storage') then
    raise notice 'Supabase Storage not present — skipping storage bootstrap (local dev).';
    return;
  end if;

  -- ------------------------------------------------------------------ buckets
  insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
  values
    ('avatars',  'avatars',  true,  2097152,
      array['image/jpeg','image/png','image/webp','image/gif']),
    ('banners',  'banners',  true,  5242880,
      array['image/jpeg','image/png','image/webp']),
    ('post-media','post-media', true, 5242880,
      array['image/jpeg','image/png','image/webp','image/gif']),
    ('branding', 'branding', true,  5242880,
      array['image/jpeg','image/png','image/webp','image/svg+xml'])
  on conflict (id) do update
    set public = excluded.public,
        file_size_limit = excluded.file_size_limit,
        allowed_mime_types = excluded.allowed_mime_types;

  -- ------------------------------------------------------------------ policies
  -- Convention: object name is `<user_uuid>/<filename>`, so ownership is
  -- derivable from the path and a user can never overwrite someone else's file.
  execute $p$ drop policy if exists campusly_read_public_media on storage.objects $p$;
  execute $p$
    create policy campusly_read_public_media on storage.objects
      for select using (bucket_id in ('avatars','banners','post-media','branding'))
  $p$;

  execute $p$ drop policy if exists campusly_upload_own on storage.objects $p$;
  execute $p$
    create policy campusly_upload_own on storage.objects
      for insert to authenticated
      with check (
        bucket_id in ('avatars','banners','post-media')
        and (storage.foldername(name))[1] = auth.uid()::text
      )
  $p$;

  execute $p$ drop policy if exists campusly_update_own on storage.objects $p$;
  execute $p$
    create policy campusly_update_own on storage.objects
      for update to authenticated
      using (
        bucket_id in ('avatars','banners','post-media')
        and (storage.foldername(name))[1] = auth.uid()::text
      )
      with check (
        bucket_id in ('avatars','banners','post-media')
        and (storage.foldername(name))[1] = auth.uid()::text
      )
  $p$;

  execute $p$ drop policy if exists campusly_delete_own on storage.objects $p$;
  execute $p$
    create policy campusly_delete_own on storage.objects
      for delete to authenticated
      using (
        bucket_id in ('avatars','banners','post-media')
        and (storage.foldername(name))[1] = auth.uid()::text
      )
  $p$;

  -- Branding is admin-only.
  execute $p$ drop policy if exists campusly_branding_admin on storage.objects $p$;
  execute $p$
    create policy campusly_branding_admin on storage.objects
      for all to authenticated
      using (bucket_id = 'branding' and public.is_admin())
      with check (bucket_id = 'branding' and public.is_admin())
  $p$;
end $$;
