-- =====================================================
-- SEED DATA FOR JEFF PORTFOLIO
-- =====================================================
-- This file contains sample data for testing.
-- Run this AFTER running schema.sql
-- =====================================================

-- =====================================================
-- DEFAULT PAGE CONTENT (HOMEPAGE)
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

-- =====================================================
-- DEFAULT ABOUT CONTENT
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

-- =====================================================
-- SAMPLE PROJECTS
-- =====================================================

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

-- Note: After uploading images to Supabase Storage, update the image_url column
-- Example:
-- UPDATE projects SET image_url = 'https://your-project.supabase.co/storage/v1/object/public/projects/project-1.jpg' 
-- WHERE title = 'Modern Brand Identity';
