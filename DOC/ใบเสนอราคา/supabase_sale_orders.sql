-- ========== SALE ORDERS TABLE ==========
-- Run this in Supabase SQL Editor
-- Project: oneforall-office (kxzghbxgrkvwnfpahkxk)

CREATE TABLE IF NOT EXISTS sale_orders (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  number TEXT,                        -- SO2569001
  date DATE,
  customer TEXT,
  contact_name TEXT,
  contact_phone TEXT,
  status TEXT DEFAULT 'pending',      -- pending | processing | shipped | completed | cancelled
  delivery_date DATE,
  quote_id UUID REFERENCES quotations(id) ON DELETE SET NULL,
  note TEXT,
  items JSONB DEFAULT '[]',
  subtotal NUMERIC(12,2) DEFAULT 0,
  vat NUMERIC(12,2) DEFAULT 0,
  total NUMERIC(12,2) DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Index for fast number lookup (used by genSONumber)
CREATE INDEX IF NOT EXISTS idx_sale_orders_number ON sale_orders(number);

-- Auto-update updated_at
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_sale_orders_updated_at
  BEFORE UPDATE ON sale_orders
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- RLS
ALTER TABLE sale_orders ENABLE ROW LEVEL SECURITY;

-- Allow authenticated users to read
CREATE POLICY "Authenticated users can read sale_orders"
  ON sale_orders FOR SELECT
  USING (auth.role() = 'authenticated');

-- Allow authenticated users to insert
CREATE POLICY "Authenticated users can insert sale_orders"
  ON sale_orders FOR INSERT
  WITH CHECK (auth.role() = 'authenticated');

-- Allow authenticated users to update
CREATE POLICY "Authenticated users can update sale_orders"
  ON sale_orders FOR UPDATE
  USING (auth.role() = 'authenticated');

-- Allow authenticated users to delete
CREATE POLICY "Authenticated users can delete sale_orders"
  ON sale_orders FOR DELETE
  USING (auth.role() = 'authenticated');
