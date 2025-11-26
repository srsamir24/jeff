# Database Migrations

This folder contains all SQL migrations for the Jeff Portfolio project.

## 📁 Structure

```
supabase/
├── schema.sql          # Complete database schema (run this first)
├── seed.sql            # Sample data for testing (run this second)
└── README.md           # This file
```

## 🚀 Setup Instructions

### First Time Setup

1. **Run the Schema** (in Supabase SQL Editor):

   ```sql
   -- Copy and paste the entire contents of schema.sql
   ```

   This creates:

   - `projects` table with all fields
   - `page_content` table for homepage sections
   - `about_content` table for about page
   - `projects` storage bucket
   - All RLS policies and triggers

2. **Run the Seed Data** (optional, for testing):
   ```sql
   -- Copy and paste the entire contents of seed.sql
   ```
   This adds:
   - Sample homepage content
   - Sample about page content
   - 6 sample projects

### Storage Bucket

The `projects` bucket is created automatically by the schema. You can upload images to it via:

- Supabase Dashboard → Storage → projects bucket
- Or programmatically via the Supabase client

**Public URL format:**

```
https://[your-project-ref].supabase.co/storage/v1/object/public/projects/[filename]
```

## 📊 Database Tables

### `projects`

Main table for portfolio projects.

**Key Fields:**

- `id` (UUID) - Primary key
- `title` (TEXT) - Project title
- `description` (TEXT) - Short description
- `full_description` (TEXT) - Detailed description
- `image_url` (TEXT) - Cover image URL
- `content_blocks` (JSONB) - Flexible content blocks for project pages
- `client`, `year`, `category`, `role` - Project metadata
- `featured` (BOOLEAN) - Whether to show on homepage
- `featured_order` (INTEGER) - Order on homepage
- `tags` (JSONB) - Project tags with styling

**Content Blocks Structure:**

```json
[
  {
    "type": "hero",
    "content": {
      "title": "Project Title",
      "subtitle": "Description"
    }
  },
  {
    "type": "text",
    "content": {
      "html": "<h3>Section</h3><p>Content...</p>"
    }
  },
  {
    "type": "image",
    "content": {
      "src": "https://..."
    }
  },
  {
    "type": "gallery",
    "content": {
      "images": ["url1", "url2", "url3"]
    }
  },
  {
    "type": "split",
    "content": {
      "title": "Feature",
      "body": "<p>Description</p>",
      "src": "https://...",
      "reverse": false
    }
  },
  {
    "type": "quote",
    "content": {
      "text": "Quote text",
      "author": "Author name"
    }
  },
  {
    "type": "video",
    "content": {
      "url": "https://youtube.com/..."
    }
  }
]
```

### `page_content`

Editable homepage sections.

**Section Keys:**

- `hero` - Hero section
- `services` - Services grid
- `stats` - Statistics section
- `cta` - Call-to-action section

### `about_content`

Editable about page content (single row with JSONB).

## 🔒 Security (RLS Policies)

All tables have Row Level Security enabled:

**Public Access:**

- ✅ Anyone can view (SELECT) all content

**Authenticated Users Only:**

- ✅ Can create (INSERT) new records
- ✅ Can update (UPDATE) existing records
- ✅ Can delete (DELETE) records

**Storage (projects bucket):**

- ✅ Public read access
- ✅ Authenticated users can upload/update/delete

## 🗑️ Old Migrations (Deprecated)

The following folders contain old migration files that have been consolidated:

- `migrations/` - Old local migrations (can be deleted)
- `supabase/migrations/` - Old individual migration files (can be deleted)

**All migrations have been consolidated into `schema.sql` and `seed.sql`.**

## 🔄 Making Changes

If you need to modify the database:

1. Make changes in Supabase SQL Editor
2. Update `schema.sql` to reflect the changes
3. Document the changes in this README

## 📝 Notes

- The `content_blocks` field uses JSONB for maximum flexibility
- All timestamps use `TIMESTAMP WITH TIME ZONE`
- The `updated_at` field is automatically updated via trigger
- Storage bucket is public for easy image serving
