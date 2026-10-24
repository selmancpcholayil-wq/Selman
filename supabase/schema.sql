-- SimpleSite customer accounts and one saved website brief per account.
create table if not exists public.business_sites (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null unique references auth.users (id) on delete cascade,
  business_name text not null default '',
  details jsonb not null default '{}'::jsonb,
  logo_url text,
  generated_html text,
  status text not null default 'draft' check (status in ('draft', 'submitted')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.business_sites enable row level security;

grant usage on schema public to authenticated;
grant select, insert, update, delete on public.business_sites to authenticated;

create policy "Customers read their own brief"
  on public.business_sites for select to authenticated
  using ((select auth.uid()) = user_id);

create policy "Customers create their own brief"
  on public.business_sites for insert to authenticated
  with check ((select auth.uid()) = user_id);

create policy "Customers update their own brief"
  on public.business_sites for update to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

create policy "Customers delete their own brief"
  on public.business_sites for delete to authenticated
  using ((select auth.uid()) = user_id);

-- Logos are public so the generated static site can display them. Writes are
-- limited to a folder named with the authenticated customer's user ID.
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('business-assets', 'business-assets', true, 2097152,
        array['image/png','image/jpeg','image/webp','image/svg+xml'])
on conflict (id) do update set
  public = excluded.public,
  file_size_limit = excluded.file_size_limit,
  allowed_mime_types = excluded.allowed_mime_types;

create policy "Customers read their own logo metadata"
  on storage.objects for select to authenticated
  using (
    bucket_id = 'business-assets'
    and (storage.foldername(name))[1] = (select auth.uid()::text)
  );

create policy "Customers upload their own logo"
  on storage.objects for insert to authenticated
  with check (
    bucket_id = 'business-assets'
    and (storage.foldername(name))[1] = (select auth.uid()::text)
  );

create policy "Customers replace their own logo"
  on storage.objects for update to authenticated
  using (
    bucket_id = 'business-assets'
    and (storage.foldername(name))[1] = (select auth.uid()::text)
  )
  with check (
    bucket_id = 'business-assets'
    and (storage.foldername(name))[1] = (select auth.uid()::text)
  );

create policy "Customers delete their own logo"
  on storage.objects for delete to authenticated
  using (
    bucket_id = 'business-assets'
    and (storage.foldername(name))[1] = (select auth.uid()::text)
  );
