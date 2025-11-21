-- Sample test data for projects table
-- Run this AFTER running 001_add_project_detail_fields.sql

-- Insert sample projects
INSERT INTO projects (title, description, full_description, client, year, category, role, image_url, tags, featured, featured_order, created_at)
VALUES
(
  'Modern Brand Identity',
  'Complete brand identity design including logo, color palette, and visual guidelines',
  'A comprehensive brand identity project that encompassed logo design, color palette selection, typography system, and complete visual guidelines. The goal was to create a modern, memorable brand that resonates with a young, tech-savvy audience while maintaining professional credibility. The final deliverables included a brand book, digital assets, and print materials.',
  'TechStart Inc.',
  '2024',
  'Branding & Identity',
  'Lead Designer',
  NULL,
  '[
    {"label": "Branding", "class": "bg-bright-pink/20 text-bright-pink"},
    {"label": "Logo Design", "class": "bg-blue-purple/20 text-blue-purple"}
  ]'::jsonb,
  true,
  1,
  NOW()
),
(
  'Product Packaging Design',
  'Eye-catching packaging design for organic food products',
  'Designed packaging for a new line of organic food products. The project involved creating a cohesive visual system across multiple product variants while ensuring shelf appeal and communicating the brand''s commitment to sustainability. Materials selection and printing specifications were carefully considered to align with the eco-friendly brand values.',
  'GreenLife Foods',
  '2023',
  'Packaging Design',
  'Senior Designer',
  NULL,
  '[
    {"label": "Packaging", "class": "bg-light-green/20 text-light-green"},
    {"label": "Print Design", "class": "bg-light-blue/20 text-light-blue"}
  ]'::jsonb,
  true,
  2,
  NOW() - INTERVAL '30 days'
),
(
  'Music Festival Poster Series',
  'Vibrant poster series for annual summer music festival',
  'Created a bold, vibrant poster series for a three-day summer music festival. The design needed to capture the energy and diversity of the lineup while being versatile enough to work across multiple formats including large-scale prints, social media graphics, and merchandise. The typography and color choices were inspired by the festival''s psychedelic rock heritage.',
  'Summer Sound Festival',
  '2024',
  'Print Design',
  'Art Director',
  NULL,
  '[
    {"label": "Print", "class": "bg-bright-pink/20 text-bright-pink"},
    {"label": "Typography", "class": "bg-blue-purple/20 text-blue-purple"},
    {"label": "Illustration", "class": "bg-light-green/20 text-light-green"}
  ]'::jsonb,
  true,
  3,
  NOW() - INTERVAL '15 days'
),
(
  'Mobile App UI Design',
  'User interface design for wellness and meditation app',
  'Designed a calming, intuitive user interface for a meditation and wellness mobile application. The design focused on creating a serene user experience with soft colors, breathing animations, and thoughtful micro-interactions. Extensive user testing helped refine the information architecture and navigation patterns to ensure the app felt peaceful rather than overwhelming.',
  'Mindful Moments App',
  '2024',
  'Digital Design',
  'UI/UX Designer',
  NULL,
  '[
    {"label": "UI Design", "class": "bg-light-blue/20 text-light-blue"},
    {"label": "Mobile", "class": "bg-blue-purple/20 text-blue-purple"}
  ]'::jsonb,
  true,
  4,
  NOW() - INTERVAL '7 days'
),
(
  'Restaurant Menu & Signage',
  'Complete menu design and interior signage system',
  'Comprehensive design system for a farm-to-table restaurant including menu layouts, table signage, wall graphics, and window displays. The design needed to reflect the rustic, authentic character of the restaurant while remaining legible and functional. Hand-lettering and earthy textures were combined with clean typography for a warm, inviting aesthetic.',
  'Harvest Kitchen',
  '2023',
  'Print Design',
  'Graphic Designer',
  NULL,
  '[
    {"label": "Print", "class": "bg-light-green/20 text-light-green"},
    {"label": "Typography", "class": "bg-bright-pink/20 text-bright-pink"}
  ]'::jsonb,
  false,
  NULL,
  NOW() - INTERVAL '60 days'
),
(
  'Social Media Campaign',
  'Visual campaign for environmental awareness initiative',
  'Designed a compelling social media campaign to raise awareness about ocean plastic pollution. The campaign included infographics, animated posts, story templates, and shareable content optimized for various social platforms. The visual strategy used powerful imagery and clear data visualization to drive engagement and encourage action.',
  'Ocean Guardians',
  '2024',
  'Digital Design',
  'Creative Lead',
  NULL,
  '[
    {"label": "Social Media", "class": "bg-light-blue/20 text-light-blue"},
    {"label": "Infographics", "class": "bg-light-green/20 text-light-green"}
  ]'::jsonb,
  false,
  NULL,
  NOW() - INTERVAL '45 days'
);

-- Note: If you have images, you can update the image_url column with actual URLs
-- Example:
-- UPDATE projects SET image_url = 'https://your-supabase-storage-url/project-image.jpg' WHERE title = 'Modern Brand Identity';
