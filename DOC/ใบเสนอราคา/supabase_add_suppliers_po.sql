-- ONE FOR ALL PACKAGING — Suppliers, Purchase Orders, User Roles
-- รันได้หลายครั้ง ไม่พัง

-- ===== TABLE: user_roles =====
create table if not exists user_roles (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade unique,
  email text,
  role text default 'sales',
  display_name text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- ===== TABLE: suppliers =====
create table if not exists suppliers (
  id uuid primary key default gen_random_uuid(),
  code text,
  name text not null,
  contact_person text,
  phone text,
  email text,
  line_id text,
  address text,
  taxid text,
  products_supplied text,
  payment_terms text,
  note text,
  is_active boolean default true,
  created_at timestamptz default now(),
  updated_at timestamptz default now(),
  created_by uuid references auth.users(id)
);

-- ===== TABLE: purchase_orders =====
create table if not exists purchase_orders (
  id uuid primary key default gen_random_uuid(),
  po_number text,
  date date,
  supplier_id uuid references suppliers(id),
  supplier_name text,
  status text default 'pending',
  contact_method text default 'phone',
  items jsonb default '[]'::jsonb,
  subtotal numeric(15,2) default 0,
  vat numeric(15,2) default 0,
  total numeric(15,2) default 0,
  expected_date date,
  received_date date,
  note text,
  linked_quotation_id uuid references quotations(id),
  created_at timestamptz default now(),
  updated_at timestamptz default now(),
  created_by uuid references auth.users(id)
);

-- ===== PROFIT COLUMNS ในตาราง quotations =====
alter table quotations add column if not exists cost_total numeric(15,2) default 0;
alter table quotations add column if not exists profit numeric(15,2) default 0;
alter table quotations add column if not exists profit_pct numeric(5,2) default 0;

-- ===== TRIGGER FUNCTION =====
create or replace function update_updated_at()
returns trigger as $$
begin new.updated_at = now(); return new; end;
$$ language plpgsql;

drop trigger if exists trig_user_roles_updated on user_roles;
create trigger trig_user_roles_updated before update on user_roles for each row execute function update_updated_at();

drop trigger if exists trig_suppliers_updated on suppliers;
create trigger trig_suppliers_updated before update on suppliers for each row execute function update_updated_at();

drop trigger if exists trig_po_updated on purchase_orders;
create trigger trig_po_updated before update on purchase_orders for each row execute function update_updated_at();

-- ===== HELPER FUNCTION =====
create or replace function get_my_role()
returns text as $$
  select role from user_roles where user_id = auth.uid() limit 1;
$$ language sql security definer;

-- ===== RLS =====
alter table user_roles enable row level security;
alter table suppliers enable row level security;
alter table purchase_orders enable row level security;

-- Drop ก่อนเสมอ
drop policy if exists "user_roles_read" on user_roles;
drop policy if exists "user_roles_director_write" on user_roles;
drop policy if exists "suppliers_access" on suppliers;
drop policy if exists "po_access" on purchase_orders;

-- สร้างใหม่
create policy "user_roles_read" on user_roles for select using (true);
create policy "user_roles_director_write" on user_roles for all
  using (get_my_role() = 'director')
  with check (get_my_role() = 'director');

create policy "suppliers_access" on suppliers for all
  using (get_my_role() in ('director', 'purchasing'))
  with check (get_my_role() in ('director', 'purchasing'));

create policy "po_access" on purchase_orders for all
  using (get_my_role() in ('director', 'purchasing'))
  with check (get_my_role() in ('director', 'purchasing'));

-- ===== INDEXES =====
create index if not exists idx_user_roles_uid on user_roles(user_id);
create index if not exists idx_suppliers_name on suppliers(name);
create index if not exists idx_po_date on purchase_orders(date desc);
create index if not exists idx_po_supplier on purchase_orders(supplier_id);
create index if not exists idx_po_status on purchase_orders(status);

-- ===== SET DIRECTOR (รันแค่ครั้งเดียว) =====
insert into user_roles (user_id, email, role, display_name)
values ('65a52b61-fa0e-478b-9dab-2d7e5bad2b3b', 'ummpluk@gmail.com', 'director', 'Pluk')
on conflict (user_id) do update set role = 'director', display_name = 'Pluk';
