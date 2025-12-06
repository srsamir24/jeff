# Image Upload Fix for VizBlock Editor

## Problem
Images were not uploading correctly in the admin CRUD interface for the vizblock layout editor. This was caused by:

1. **Duplicate storage buckets**: Multiple SQL migration files were creating different buckets (`project-assets` and `projects`)
2. **Policy conflicts**: Different migration files were creating policies with the same names, causing conflicts
3. **Missing configuration**: The bucket wasn't configured with proper file size limits and MIME type restrictions

## Solution

The fix consolidates all storage bucket configuration into a single, properly configured `projects` bucket with unique policy names.

## How to Apply the Fix

### Option 1: Fresh Database Setup

If you're setting up a fresh database, run:

```sql
-- Run this in your Supabase SQL Editor
-- File: supabase/schema.sql
```

This will create the complete database schema including the properly configured storage bucket.

### Option 2: Fix Existing Database (RECOMMENDED)

If you already have a database with projects, run the migration file:

```sql
-- Run this in your Supabase SQL Editor
-- File: supabase/migrations/fix_storage_buckets.sql
```

**✅ SAFE**: This migration will NOT delete your existing files! It only:
1. Updates the bucket configuration (file size limits, MIME types)
2. Drops and recreates the storage policies with unique names
3. Preserves all your existing uploaded images

### Option 3: Manual Fix via Supabase Dashboard

1. **Go to Supabase Storage** in your project dashboard
2. **Check if `projects` bucket exists**:
   - If it doesn't exist, create it with these settings:
     - Name: `projects`
     - Public bucket: `true`
     - File size limit: `50MB`
     - Allowed MIME types: `image/jpeg, image/jpg, image/png, image/gif, image/webp, image/svg+xml`

3. **Delete conflicting policies**:
   - Go to Storage → Policies
   - Delete any old policies for the `projects` bucket

4. **Create new policies** (copy from `fix_storage_buckets.sql`):
   - `projects_public_read` - Allow public read access
   - `projects_auth_insert` - Allow authenticated users to upload
   - `projects_auth_update` - Allow authenticated users to update
   - `projects_auth_delete` - Allow authenticated users to delete

## Verification

After applying the fix, verify it's working:

1. **Check bucket exists**:
```sql
SELECT * FROM storage.buckets WHERE id = 'projects';
```

2. **Check policies**:
```sql
SELECT policyname, cmd, qual
FROM pg_policies
WHERE tablename = 'objects'
AND schemaname = 'storage';
```

3. **Test upload**:
   - Go to your admin interface (`/admin/projects`)
   - Try uploading an image to a project
   - Check the browser console for any errors

## Files Modified

- ✅ [supabase/schema.sql](supabase/schema.sql) - Updated with correct storage configuration
- ✅ [supabase/migrations/fix_storage_buckets.sql](supabase/migrations/fix_storage_buckets.sql) - New migration file to fix existing databases
- ℹ️ [supabase/migrations/storage_bucket.sql](supabase/migrations/storage_bucket.sql) - Old file (creates `project-assets` bucket - can be ignored)
- ℹ️ [supabase/migrations/projects_bucket.sql](supabase/migrations/projects_bucket.sql) - Old file (creates `projects` bucket with old policies - can be ignored)

## Code Components Using Storage

All these components use the `useSupabaseStorage` composable which uploads to the `projects` bucket:

- [app/composables/useSupabaseStorage.ts](app/composables/useSupabaseStorage.ts:16) - Main storage composable
- [app/pages/admin/projects.vue](app/pages/admin/projects.vue:314-322) - Project thumbnail uploads
- [app/components/viz/blocks/VizImageBlock.vue](app/components/viz/blocks/VizImageBlock.vue:26) - Image block uploads
- [app/components/viz/blocks/VizGalleryBlock.vue](app/components/viz/blocks/VizGalleryBlock.vue:39) - Gallery image uploads
- [app/components/viz/blocks/VizSplitBlock.vue](app/components/viz/blocks/VizSplitBlock.vue:87) - Split block image uploads

## Troubleshooting

### Upload fails with "permission denied"
- Check that you're logged in as an admin user
- Verify the `projects_auth_insert` policy exists
- Check browser console for detailed error messages

### Images don't display after upload
- Check the `projects_public_read` policy exists
- Verify the bucket is set to public
- Check the image URL in the database

### "Bucket not found" error
- Run the migration to create the bucket
- Verify bucket exists: `SELECT * FROM storage.buckets WHERE id = 'projects';`

## Next Steps

After fixing the storage:

1. Test image uploads in the admin interface
2. Test vizblock image uploads in the project content editor
3. Verify images display correctly on the public site
4. Consider setting up a CDN for better performance (optional)
