-- Migration: Add DN, TI, RC, WHT, CN document tables
-- Run in Supabase SQL Editor (project: kxzghbxgrkvwnfpahkxk)
-- Date: 2026-06-16

-- ===== DELIVERY NOTES =====
CREATE TABLE IF NOT EXISTS delivery_notes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  number TEXT NOT NULL,
  date DATE,
  customer TEXT,
  contact_name TEXT,
  contact_phone TEXT,
  so_id UUID REFERENCES sale_orders(id) ON DELETE SET NULL,
  items JSONB DEFAULT '[]',
  subtotal NUMERIC DEFAULT 0,
  vat NUMERIC DEFAULT 0,
  total NUMERIC DEFAULT 0,
  status TEXT DEFAULT 'pending',
  note TEXT,
  user_id UUID,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE delivery_notes ENABLE ROW LEVEL SECURITY;
CREATE POLICY "delivery_notes_auth" ON delivery_notes FOR ALL TO authenticated USING (true);

-- ===== TAX INVOICES =====
CREATE TABLE IF NOT EXISTS tax_invoices (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  number TEXT NOT NULL,
  date DATE,
  customer TEXT,
  contact_name TEXT,
  contact_phone TEXT,
  dn_id UUID REFERENCES delivery_notes(id) ON DELETE SET NULL,
  items JSONB DEFAULT '[]',
  subtotal NUMERIC DEFAULT 0,
  vat NUMERIC DEFAULT 0,
  total NUMERIC DEFAULT 0,
  status TEXT DEFAULT 'draft',
  note TEXT,
  user_id UUID,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE tax_invoices ENABLE ROW LEVEL SECURITY;
CREATE POLICY "tax_invoices_auth" ON tax_invoices FOR ALL TO authenticated USING (true);

-- ===== RECEIPTS =====
CREATE TABLE IF NOT EXISTS receipts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  number TEXT NOT NULL,
  date DATE,
  customer TEXT,
  ti_id UUID REFERENCES tax_invoices(id) ON DELETE SET NULL,
  amount NUMERIC DEFAULT 0,
  paid_method TEXT DEFAULT 'transfer',
  status TEXT DEFAULT 'draft',
  note TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE receipts ENABLE ROW LEVEL SECURITY;
CREATE POLICY "receipts_auth" ON receipts FOR ALL TO authenticated USING (true);

-- ===== WHT DOCUMENTS =====
CREATE TABLE IF NOT EXISTS wht_documents (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  number TEXT NOT NULL,
  date DATE,
  customer TEXT,
  ti_id UUID REFERENCES tax_invoices(id) ON DELETE SET NULL,
  income_type TEXT DEFAULT 'จ้างทำของ',
  amount_before_tax NUMERIC DEFAULT 0,
  tax_rate NUMERIC DEFAULT 3,
  tax_amount NUMERIC DEFAULT 0,
  status TEXT DEFAULT 'draft',
  note TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE wht_documents ENABLE ROW LEVEL SECURITY;
CREATE POLICY "wht_documents_auth" ON wht_documents FOR ALL TO authenticated USING (true);

-- ===== CREDIT NOTES =====
CREATE TABLE IF NOT EXISTS credit_notes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  number TEXT NOT NULL,
  date DATE,
  customer TEXT,
  ti_id UUID REFERENCES tax_invoices(id) ON DELETE SET NULL,
  reason TEXT,
  items JSONB DEFAULT '[]',
  subtotal NUMERIC DEFAULT 0,
  vat NUMERIC DEFAULT 0,
  total NUMERIC DEFAULT 0,
  status TEXT DEFAULT 'draft',
  note TEXT,
  user_id UUID,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE credit_notes ENABLE ROW LEVEL SECURITY;
CREATE POLICY "credit_notes_auth" ON credit_notes FOR ALL TO authenticated USING (true);
