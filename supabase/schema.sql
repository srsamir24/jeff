-- =====================================================
-- PROJECTS TABLE
-- =====================================================

-- Create projects table
CREATE TABLE IF NOT EXISTS projects (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  image_url TEXT,
  tags JSONB DEFAULT '[]'::jsonb,
  featured BOOLEAN DEFAULT false,
  featured_order INTEGER,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE projects ENABLE ROW LEVEL SECURITY;

-- =====================================================
-- RLS POLICIES FOR PROJECTS
-- =====================================================

-- Policy: Anyone can view projects (SELECT)
CREATE POLICY "Public can view projects"
  ON projects
  FOR SELECT
  TO public
  USING (true);

-- Policy: Only authenticated users (admin) can insert projects
CREATE POLICY "Authenticated users can insert projects"
  ON projects
  FOR INSERT
  TO authenticated
  WITH CHECK (true);

-- Policy: Only authenticated users (admin) can update projects
CREATE POLICY "Authenticated users can update projects"
  ON projects
  FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

-- Policy: Only authenticated users (admin) can delete projects
CREATE POLICY "Authenticated users can delete projects"
  ON projects
  FOR DELETE
  TO authenticated
  USING (true);

-- =====================================================
-- STORAGE BUCKET FOR PROJECT IMAGES
-- =====================================================

-- Create storage bucket for project images (run this in Supabase Dashboard > Storage)
-- Or use this SQL:
INSERT INTO storage.buckets (id, name, public)
VALUES ('projects', 'projects', true)
ON CONFLICT (id) DO NOTHING;

-- =====================================================
-- RLS POLICIES FOR STORAGE
-- =====================================================

-- Policy: Anyone can view images (SELECT)
CREATE POLICY "Public can view project images"
  ON storage.objects
  FOR SELECT
  TO public
  USING (bucket_id = 'projects');

-- Policy: Only authenticated users can upload images (INSERT)
CREATE POLICY "Authenticated users can upload project images"
  ON storage.objects
  FOR INSERT
  TO authenticated
  WITH CHECK (bucket_id = 'projects');

-- Policy: Only authenticated users can update images
CREATE POLICY "Authenticated users can update project images"
  ON storage.objects
  FOR UPDATE
  TO authenticated
  USING (bucket_id = 'projects');

-- Policy: Only authenticated users can delete images
CREATE POLICY "Authenticated users can delete project images"
  ON storage.objects
  FOR DELETE
  TO authenticated
  USING (bucket_id = 'projects');

-- =====================================================
-- INDEXES FOR BETTER PERFORMANCE
-- =====================================================

CREATE INDEX IF NOT EXISTS idx_projects_created_at ON projects(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_projects_featured ON projects(featured, featured_order);

-- =====================================================
-- TRIGGER TO AUTO-UPDATE updated_at
-- =====================================================

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_projects_updated_at
  BEFORE UPDATE ON projects
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- PAGE CONTENT TABLE (FOR EDITABLE HOMEPAGE CONTENT)
-- =====================================================

-- Create page_content table for managing homepage sections
CREATE TABLE IF NOT EXISTS page_content (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  section_key TEXT UNIQUE NOT NULL, -- e.g., 'hero', 'services', 'stats', 'cta'
  content JSONB NOT NULL, -- Flexible JSON structure for each section
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE page_content ENABLE ROW LEVEL SECURITY;

-- =====================================================
-- RLS POLICIES FOR PAGE CONTENT
-- =====================================================

-- Policy: Anyone can view page content (SELECT)
CREATE POLICY "Public can view page content"
  ON page_content
  FOR SELECT
  TO public
  USING (true);

-- Policy: Only authenticated users (admin) can update page content
CREATE POLICY "Authenticated users can update page content"
  ON page_content
  FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

-- Policy: Only authenticated users (admin) can insert page content
CREATE POLICY "Authenticated users can insert page content"
  ON page_content
  FOR INSERT
  TO authenticated
  WITH CHECK (true);

-- =====================================================
-- DEFAULT PAGE CONTENT (SEED DATA)
-- =====================================================

-- Hero Section
INSERT INTO page_content (section_key, content) VALUES (
  'hero',
  '{
    "title": "Graphic Designer & Visual Storyteller",
    "subtitle": "Transforming ideas into stunning visual experiences with creativity and precision",
    "ctaText": "View My Work",
    "ctaLink": "/work"
  }'::jsonb
) ON CONFLICT (section_key) DO NOTHING;

-- Services Section
INSERT INTO page_content (section_key, content) VALUES (
  'services',
  '{
    "title": "What I Do",
    "subtitle": "Specialized design services tailored to bring your vision to life",
    "services": [
      {
        "title": "Branding & Identity",
        "description": "Creating memorable brand identities with logos, color palettes, and comprehensive visual guidelines.",
        "iconBgClass": "bg-linear-to-br from-bright-pink to-lighter-pink",
        "hoverBorderClass": "hover:border-bright-pink/20",
        "hoverTextClass": "group-hover:text-bright-pink"
      },
      {
        "title": "Print Design",
        "description": "Eye-catching posters, flyers, brochures, and business cards that leave lasting impressions.",
        "iconBgClass": "bg-linear-to-br from-light-green to-light-green/70",
        "hoverBorderClass": "hover:border-light-green/20",
        "hoverTextClass": "group-hover:text-light-green"
      },
      {
        "title": "Digital Illustrations",
        "description": "Custom illustrations, social media graphics, and digital artwork that captivate audiences.",
        "iconBgClass": "bg-linear-to-br from-light-blue to-light-blue/70",
        "hoverBorderClass": "hover:border-light-blue/20",
        "hoverTextClass": "group-hover:text-light-blue"
      },
      {
        "title": "Packaging Design",
        "description": "Stunning product packaging and label designs that stand out on shelves and online.",
        "iconBgClass": "bg-linear-to-br from-blue-purple to-blue-purple/70",
        "hoverBorderClass": "hover:border-blue-purple/20",
        "hoverTextClass": "group-hover:text-blue-purple"
      }
    ]
  }'::jsonb
) ON CONFLICT (section_key) DO NOTHING;

-- Stats Section
INSERT INTO page_content (section_key, content) VALUES (
  'stats',
  '{
    "stats": [
      {"value": "150+", "label": "Projects Completed", "colorClass": "text-blue-purple"},
      {"value": "50+", "label": "Happy Clients", "colorClass": "text-bright-pink"},
      {"value": "5+", "label": "Years Experience", "colorClass": "text-light-green"},
      {"value": "15+", "label": "Awards Won", "colorClass": "text-light-blue"}
    ]
  }'::jsonb
) ON CONFLICT (section_key) DO NOTHING;

-- CTA Section
INSERT INTO page_content (section_key, content) VALUES (
  'cta',
  '{
    "title": "Ready to Bring Your Vision to Life?",
    "subtitle": "Let''s collaborate to create something extraordinary that resonates with your audience and elevates your brand.",
    "primaryButtonText": "Start a Project",
    "primaryButtonLink": "/contact",
    "secondaryButtonText": "View Portfolio",
    "secondaryButtonLink": "/work"
  }'::jsonb
) ON CONFLICT (section_key) DO NOTHING;

-- Trigger for page_content
CREATE TRIGGER update_page_content_updated_at
  BEFORE UPDATE ON page_content
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- ABOUT CONTENT TABLE (FOR EDITABLE ABOUT PAGE)
-- =====================================================

-- Create about_content table for managing about page sections
CREATE TABLE IF NOT EXISTS about_content (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  content JSONB NOT NULL, -- Flexible JSON structure for about page
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE about_content ENABLE ROW LEVEL SECURITY;

-- =====================================================
-- RLS POLICIES FOR ABOUT CONTENT
-- =====================================================

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

-- Trigger for about_content
CREATE TRIGGER update_about_content_updated_at
  BEFORE UPDATE ON about_content
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();
