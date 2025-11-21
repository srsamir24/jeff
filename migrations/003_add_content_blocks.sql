-- Add content_blocks column to projects table for flexible content management

ALTER TABLE projects
ADD COLUMN IF NOT EXISTS content_blocks JSONB DEFAULT '[]'::jsonb;

COMMENT ON COLUMN projects.content_blocks IS 'Flexible content blocks (text, images, image grids) for project detail pages';

-- Example content_blocks structure:
-- [
--   { "type": "text", "content": "Project description text..." },
--   { "type": "image", "url": "https://...", "caption": "Image caption" },
--   { "type": "image_grid", "columns": 2, "images": [
--       { "url": "https://...", "caption": "..." },
--       { "url": "https://...", "caption": "..." }
--     ]
--   }
-- ]
