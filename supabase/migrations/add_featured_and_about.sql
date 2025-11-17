-- =====================================================
-- MIGRATION: Add Featured Projects & About Content
-- =====================================================
-- This migration adds:
-- 1. Featured columns to projects table
-- 2. About content table for managing about page
-- =====================================================

-- Add featured columns to projects table (if they don't exist)
DO $$
BEGIN
  -- Add featured column
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'projects' AND column_name = 'featured'
  ) THEN
    ALTER TABLE projects ADD COLUMN featured BOOLEAN DEFAULT false;
  END IF;

  -- Add featured_order column
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'projects' AND column_name = 'featured_order'
  ) THEN
    ALTER TABLE projects ADD COLUMN featured_order INTEGER;
  END IF;
END $$;

-- Create index for featured projects
CREATE INDEX IF NOT EXISTS idx_projects_featured ON projects(featured, featured_order);

-- =====================================================
-- ABOUT CONTENT TABLE
-- =====================================================

-- Create about_content table for managing about page sections
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

-- Policy: Anyone can view about content (SELECT)
CREATE POLICY "Public can view about content"
  ON about_content
  FOR SELECT
  TO public
  USING (true);

-- Policy: Only authenticated users (admin) can update about content
CREATE POLICY "Authenticated users can update about content"
  ON about_content
  FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

-- Policy: Only authenticated users (admin) can insert about content
CREATE POLICY "Authenticated users can insert about content"
  ON about_content
  FOR INSERT
  TO authenticated
  WITH CHECK (true);

-- =====================================================
-- DEFAULT ABOUT CONTENT (SEED DATA)
-- =====================================================

INSERT INTO about_content (content) VALUES (
  '{
    "hero": {
      "paragraphs": [
        "Hi! I''m Anna Ericyan, a passionate graphic designer with a love for creating visual stories that captivate and inspire.",
        "With years of experience in branding, print design, and digital illustration, I help businesses and individuals bring their creative visions to life through thoughtful, beautiful design.",
        "My approach combines creativity with strategy, ensuring every project not only looks amazing but also achieves its goals."
      ]
    },
    "skills": {
      "title": "What I Do",
      "description": "Specialized skills and services I offer to bring your vision to life",
      "items": [
        {
          "title": "Branding & Identity",
          "description": "Creating memorable brand identities with logos and visual guidelines"
        },
        {
          "title": "Print Design",
          "description": "Eye-catching posters, flyers, and business cards that leave lasting impressions"
        },
        {
          "title": "Digital Illustrations",
          "description": "Custom illustrations and digital artwork that captivate audiences"
        },
        {
          "title": "Packaging Design",
          "description": "Stunning product packaging that stands out on shelves and online"
        }
      ]
    },
    "experience": {
      "title": "Experience",
      "description": "My journey in design",
      "items": [
        {
          "title": "Senior Graphic Designer",
          "period": "2020 - Present",
          "description": "Leading creative projects and mentoring junior designers while delivering exceptional brand experiences."
        },
        {
          "title": "Freelance Designer",
          "period": "2018 - 2020",
          "description": "Worked with diverse clients creating branding, illustrations, and print materials."
        },
        {
          "title": "Junior Designer",
          "period": "2016 - 2018",
          "description": "Developed foundational skills in design, learned industry best practices, and contributed to team projects."
        }
      ]
    },
    "cta": {
      "title": "Let''s Create Together",
      "subtitle": "I''m always excited to work on new projects and collaborate with passionate people."
    }
  }'::jsonb
) ON CONFLICT DO NOTHING;

-- Create trigger for about_content if function exists
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_proc WHERE proname = 'update_updated_at_column') THEN
    DROP TRIGGER IF EXISTS update_about_content_updated_at ON about_content;
    CREATE TRIGGER update_about_content_updated_at
      BEFORE UPDATE ON about_content
      FOR EACH ROW
      EXECUTE FUNCTION update_updated_at_column();
  END IF;
END $$;
