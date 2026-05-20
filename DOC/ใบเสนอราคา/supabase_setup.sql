-- ONE FOR ALL PACKAGING — Supabase Setup SQL
-- วิธีใช้: ไปที่ Supabase Dashboard → SQL Editor → วางโค้ดนี้ → กด Run

-- ===== TABLE: quotations (ใบเสนอราคา) =====
create table if not exists quotations (
  id uuid primary key default gen_random_uuid(),
  number text,
  date date,
  customer text,
  contact_person text,
  phone text,
  status text default 'draft',
  validity integer default 30,
  note text,
  items jsonb default '[]'::jsonb,
  subtotal numeric(15,2) default 0,
  vat numeric(15,2) default 0,
  total numeric(15,2) default 0,
  created_at timestamptz default now(),
  updated_at timestamptz default now(),
  user_id uuid references auth.users(id) on delete cascade
);

-- ===== TABLE: products (สินค้า) =====
create table if not exists products (
  id uuid primary key default gen_random_uuid(),
  code text,
  type text,
  name text,
  price numeric(15,4) default 0,
  unit text,
  description text,
  created_at timestamptz default now(),
  updated_at timestamptz default now(),
  user_id uuid references auth.users(id) on delete cascade
);

-- ===== TABLE: contacts (ลูกค้า) =====
create table if not exists contacts (
  id uuid primary key default gen_random_uuid(),
  company text,
  name text,
  phone text,
  email text,
  line_id text,
  address text,
  taxid text,
  note text,
  created_at timestamptz default now(),
  updated_at timestamptz default now(),
  user_id uuid references auth.users(id) on delete cascade
);

-- ===== AUTO-UPDATE updated_at =====
create or replace function update_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

drop trigger if exists trig_quotations_updated on quotations;
create trigger trig_quotations_updated
  before update on quotations
  for each row execute function update_updated_at();

drop trigger if exists trig_products_updated on products;
create trigger trig_products_updated
  before update on products
  for each row execute function update_updated_at();

drop trigger if exists trig_contacts_updated on contacts;
create trigger trig_contacts_updated
  before update on contacts
  for each row execute function update_updated_at();

-- ===== ROW LEVEL SECURITY =====
alter table quotations enable row level security;
alter table products enable row level security;
alter table contacts enable row level security;

-- Drop existing policies first (safe to re-run)
drop policy if exists "quotations_own" on quotations;
drop policy if exists "products_own" on products;
drop policy if exists "contacts_own" on contacts;

-- Policies: user เห็น/แก้ได้เฉพาะข้อมูลตัวเอง
create policy "quotations_own" on quotations for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "products_own" on products for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "contacts_own" on contacts for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- ===== INDEXES (เพิ่มความเร็ว) =====
create index if not exists idx_quotations_user_date on quotations(user_id, date desc);
create index if not exists idx_quotations_status on quotations(status);
create index if not exists idx_quotations_customer on quotations(customer);
create index if not exists idx_products_user on products(user_id, created_at desc);
create index if not exists idx_contacts_user on contacts(user_id, created_at desc);
