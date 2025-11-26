-- Create social_links table for managing social media and external links
CREATE TABLE IF NOT EXISTS social_links (
  id BIGSERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  url TEXT NOT NULL,
  icon_type TEXT NOT NULL, -- 'instagram', 'behance', 'dribbble', 'linkedin', 'twitter', 'upwork', 'custom'
  display_location TEXT[] DEFAULT ARRAY['footer'], -- where to display: 'footer', 'nav', 'both'
  sort_order INTEGER DEFAULT 0,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Add some default social links
INSERT INTO social_links (name, url, icon_type, display_location, sort_order, is_active) VALUES
  ('Instagram', 'https://instagram.com/annaericyan', 'instagram', ARRAY['footer'], 1, true),
  ('Behance', 'https://behance.net/annaericyan', 'behance', ARRAY['footer'], 2, true),
  ('Dribbble', 'https://dribbble.com/annaericyan', 'dribbble', ARRAY['footer'], 3, true),
  ('Upwork', 'https://www.upwork.com', 'upwork', ARRAY['nav'], 4, true)
ON CONFLICT DO NOTHING;

-- Create index for faster queries
CREATE INDEX IF NOT EXISTS idx_social_links_active ON social_links(is_active);
CREATE INDEX IF NOT EXISTS idx_social_links_sort ON social_links(sort_order);

-- Enable RLS
ALTER TABLE social_links ENABLE ROW LEVEL SECURITY;

-- Policy for public read access
CREATE POLICY "Public can view active social links"
  ON social_links
  FOR SELECT
  TO public
  USING (is_active = true);

-- Policy for authenticated users to manage
CREATE POLICY "Authenticated users can manage social links"
  ON social_links
  FOR ALL
  TO authenticated
  USING (true)
  WITH CHECK (true);
