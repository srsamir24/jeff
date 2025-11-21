-- Add new columns to projects table for detail page

-- Add full description column
ALTER TABLE projects
ADD COLUMN IF NOT EXISTS full_description TEXT;

-- Add client column
ALTER TABLE projects
ADD COLUMN IF NOT EXISTS client VARCHAR(255);

-- Add year column
ALTER TABLE projects
ADD COLUMN IF NOT EXISTS year VARCHAR(10);

-- Add category column
ALTER TABLE projects
ADD COLUMN IF NOT EXISTS category VARCHAR(100);

-- Add role column
ALTER TABLE projects
ADD COLUMN IF NOT EXISTS role VARCHAR(100);

-- Add comment to columns
COMMENT ON COLUMN projects.full_description IS 'Detailed description shown on project detail page';
COMMENT ON COLUMN projects.client IS 'Client name for the project';
COMMENT ON COLUMN projects.year IS 'Year the project was completed';
COMMENT ON COLUMN projects.category IS 'Project category (e.g., Branding & Identity, Print Design)';
COMMENT ON COLUMN projects.role IS 'Role in the project (e.g., Lead Designer, Art Director)';
