-- =====================================================
-- COMPLETE DATABASE SCHEMA FOR JEFF PORTFOLIO
-- =====================================================
-- This is the consolidated schema that combines all migrations.
-- Run this in your Supabase SQL Editor to set up the complete database.
-- =====================================================

-- =====================================================
-- HELPER FUNCTION: Auto-update updated_at timestamp
-- =====================================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- PROJECTS TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS projects (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  full_description TEXT,
  image_url TEXT,
  tags JSONB DEFAULT '[]'::jsonb,
  content_blocks JSONB DEFAULT '[]'::jsonb,
  client VARCHAR(255),
  year VARCHAR(10),
  category VARCHAR(100),
  role VARCHAR(100),
  featured BOOLEAN DEFAULT false,
  featured_order INTEGER,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Add comments to columns
COMMENT ON COLUMN projects.full_description IS 'Detailed description shown on project detail page';
COMMENT ON COLUMN projects.client IS 'Client name for the project';
COMMENT ON COLUMN projects.year IS 'Year the project was completed';
COMMENT ON COLUMN projects.category IS 'Project category (e.g., Branding & Identity, Print Design)';
COMMENT ON COLUMN projects.role IS 'Role in the project (e.g., Lead Designer, Art Director)';
COMMENT ON COLUMN projects.content_blocks IS 'Flexible content blocks (text, images, galleries, videos, quotes, etc.) for project detail pages';

-- Enable Row Level Security
ALTER TABLE projects ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Public can view projects" ON projects;
DROP POLICY IF EXISTS "Authenticated users can insert projects" ON projects;
DROP POLICY IF EXISTS "Authenticated users can update projects" ON projects;
DROP POLICY IF EXISTS "Authenticated users can delete projects" ON projects;

-- RLS Policies for projects
CREATE POLICY "Public can view projects"
  ON projects FOR SELECT TO public USING (true);

CREATE POLICY "Authenticated users can insert projects"
  ON projects FOR INSERT TO authenticated WITH CHECK (true);

CREATE POLICY "Authenticated users can update projects"
  ON projects FOR UPDATE TO authenticated USING (true) WITH CHECK (true);

CREATE POLICY "Authenticated users can delete projects"
  ON projects FOR DELETE TO authenticated USING (true);

-- Indexes for better performance
CREATE INDEX IF NOT EXISTS idx_projects_created_at ON projects(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_projects_featured ON projects(featured, featured_order);

-- Trigger to auto-update updated_at
DROP TRIGGER IF EXISTS update_projects_updated_at ON projects;
CREATE TRIGGER update_projects_updated_at
  BEFORE UPDATE ON projects
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- PAGE CONTENT TABLE (FOR EDITABLE HOMEPAGE CONTENT)
-- =====================================================
CREATE TABLE IF NOT EXISTS page_content (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  section_key TEXT UNIQUE NOT NULL,
  content JSONB NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE page_content ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Public can view page content" ON page_content;
DROP POLICY IF EXISTS "Authenticated users can update page content" ON page_content;
DROP POLICY IF EXISTS "Authenticated users can insert page content" ON page_content;

-- RLS Policies for page_content
CREATE POLICY "Public can view page content"
  ON page_content FOR SELECT TO public USING (true);

CREATE POLICY "Authenticated users can update page content"
  ON page_content FOR UPDATE TO authenticated USING (true) WITH CHECK (true);

CREATE POLICY "Authenticated users can insert page content"
  ON page_content FOR INSERT TO authenticated WITH CHECK (true);

-- Trigger for page_content
DROP TRIGGER IF EXISTS update_page_content_updated_at ON page_content;
CREATE TRIGGER update_page_content_updated_at
  BEFORE UPDATE ON page_content
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- ABOUT CONTENT TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS about_content (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  content JSONB NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE about_content ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Public can view about content" ON about_content;
DROP POLICY IF EXISTS "Authenticated users can update about content" ON about_content;
DROP POLICY IF EXISTS "Authenticated users can insert about content" ON about_content;

-- RLS Policies for about_content
CREATE POLICY "Public can view about content"
  ON about_content FOR SELECT TO public USING (true);

CREATE POLICY "Authenticated users can update about content"
  ON about_content FOR UPDATE TO authenticated USING (true) WITH CHECK (true);

CREATE POLICY "Authenticated users can insert about content"
  ON about_content FOR INSERT TO authenticated WITH CHECK (true);

-- Trigger for about_content
DROP TRIGGER IF EXISTS update_about_content_updated_at ON about_content;
CREATE TRIGGER update_about_content_updated_at
  BEFORE UPDATE ON about_content
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- STORAGE BUCKETS
-- =====================================================
-- Create the 'projects' bucket for project assets
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'projects',
  'projects',
  true,  -- Public bucket for easy image access
  52428800,  -- 50MB limit
  ARRAY['image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/webp', 'image/svg+xml']
)
ON CONFLICT (id) DO UPDATE SET
  public = true,
  file_size_limit = 52428800,
  allowed_mime_types = ARRAY['image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/webp', 'image/svg+xml'];

-- Drop ALL existing storage policies to avoid conflicts
DROP POLICY IF EXISTS "Public Access Projects" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated Upload Projects" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated Update Projects" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated Delete Projects" ON storage.objects;
DROP POLICY IF EXISTS "Public Access" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated Upload" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated Update" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated Delete" ON storage.objects;
DROP POLICY IF EXISTS "Public can view project images" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can upload project images" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can update project images" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can delete project images" ON storage.objects;
DROP POLICY IF EXISTS "projects_public_read" ON storage.objects;
DROP POLICY IF EXISTS "projects_auth_insert" ON storage.objects;
DROP POLICY IF EXISTS "projects_auth_update" ON storage.objects;
DROP POLICY IF EXISTS "projects_auth_delete" ON storage.objects;

-- Storage policies for 'projects' bucket with unique names
CREATE POLICY "projects_public_read"
  ON storage.objects FOR SELECT TO public
  USING (bucket_id = 'projects');

CREATE POLICY "projects_auth_insert"
  ON storage.objects FOR INSERT TO authenticated
  WITH CHECK (bucket_id = 'projects');

CREATE POLICY "projects_auth_update"
  ON storage.objects FOR UPDATE TO authenticated
  USING (bucket_id = 'projects')
  WITH CHECK (bucket_id = 'projects');

CREATE POLICY "projects_auth_delete"
  ON storage.objects FOR DELETE TO authenticated
  USING (bucket_id = 'projects');
