-- Create the 'projects' bucket for project assets and about page images
INSERT INTO storage.buckets (id, name, public)
VALUES ('projects', 'projects', true)
ON CONFLICT (id) DO NOTHING;

-- Set up security policies for the 'projects' bucket

-- 1. Allow public access to view files
CREATE POLICY "Public Access Projects"
ON storage.objects FOR SELECT
TO public
USING ( bucket_id = 'projects' );

-- 2. Allow authenticated users to upload files
CREATE POLICY "Authenticated Upload Projects"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK ( bucket_id = 'projects' );

-- 3. Allow authenticated users to update their own files
CREATE POLICY "Authenticated Update Projects"
ON storage.objects FOR UPDATE
TO authenticated
USING ( bucket_id = 'projects' );

-- 4. Allow authenticated users to delete files
CREATE POLICY "Authenticated Delete Projects"
ON storage.objects FOR DELETE
TO authenticated
USING ( bucket_id = 'projects' );
