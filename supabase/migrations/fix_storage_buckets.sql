-- =====================================================
-- FIX: Consolidated Storage Bucket Configuration
-- =====================================================
-- This migration ensures the 'projects' bucket exists with proper policies
-- Run this to fix any storage bucket issues
-- =====================================================

-- NOTE: We do NOT delete the bucket to preserve existing files!
-- Instead, we update the bucket configuration and fix the policies

-- Update or create the 'projects' bucket with proper configuration
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'projects',
  'projects',
  true,  -- Public bucket for easy image access
  52428800,  -- 50MB limit
  ARRAY['image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/webp', 'image/svg+xml']
)
ON CONFLICT (id) DO UPDATE SET
  public = EXCLUDED.public,
  file_size_limit = EXCLUDED.file_size_limit,
  allowed_mime_types = EXCLUDED.allowed_mime_types;

-- Drop ALL existing storage policies for 'projects' bucket to avoid conflicts
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
-- Drop the new policy names too (in case they exist from a previous run)
DROP POLICY IF EXISTS "projects_public_read" ON storage.objects;
DROP POLICY IF EXISTS "projects_auth_insert" ON storage.objects;
DROP POLICY IF EXISTS "projects_auth_update" ON storage.objects;
DROP POLICY IF EXISTS "projects_auth_delete" ON storage.objects;

-- Create NEW storage policies for 'projects' bucket
-- 1. Allow public read access (anyone can view images)
CREATE POLICY "projects_public_read"
ON storage.objects FOR SELECT
TO public
USING (bucket_id = 'projects');

-- 2. Allow authenticated users to upload (admin only)
CREATE POLICY "projects_auth_insert"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'projects');

-- 3. Allow authenticated users to update their files
CREATE POLICY "projects_auth_update"
ON storage.objects FOR UPDATE
TO authenticated
USING (bucket_id = 'projects')
WITH CHECK (bucket_id = 'projects');

-- 4. Allow authenticated users to delete files
CREATE POLICY "projects_auth_delete"
ON storage.objects FOR DELETE
TO authenticated
USING (bucket_id = 'projects');

-- =====================================================
-- VERIFICATION QUERIES (Run these to check setup)
-- =====================================================
-- Check bucket exists:
-- SELECT * FROM storage.buckets WHERE id = 'projects';

-- Check policies:
-- SELECT * FROM pg_policies WHERE tablename = 'objects' AND schemaname = 'storage';
