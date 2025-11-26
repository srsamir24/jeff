# 🚨 ACTION REQUIRED: SQL to Run in Supabase

## Instructions

Copy and paste the contents of these files into your **Supabase SQL Editor** in this order:

---

## 1️⃣ FIRST: Run Schema (Required)

**File:** `supabase/schema.sql`

**What it does:**

- Creates all database tables (`projects`, `page_content`, `about_content`)
- Sets up the `projects` storage bucket
- Configures Row Level Security (RLS) policies
- Creates indexes and triggers

**How to run:**

1. Open Supabase Dashboard
2. Go to **SQL Editor**
3. Click **New Query**
4. Copy the **entire contents** of `supabase/schema.sql`
5. Paste into the editor
6. Click **Run**

---

## 2️⃣ SECOND: Run Seed Data (Optional)

**File:** `supabase/seed.sql`

**What it does:**

- Adds sample homepage content
- Adds sample about page content
- Creates 6 sample projects for testing

**How to run:**

1. In Supabase SQL Editor
2. Click **New Query**
3. Copy the **entire contents** of `supabase/seed.sql`
4. Paste into the editor
5. Click **Run**

**Note:** This is optional and only for testing. Skip if you want to start with a clean database.

---

## ✅ Verification

After running the SQL, verify everything is set up:

### Check Tables:

1. Go to **Table Editor** in Supabase Dashboard
2. You should see:
   - `projects` table
   - `page_content` table
   - `about_content` table

### Check Storage:

1. Go to **Storage** in Supabase Dashboard
2. You should see:
   - `projects` bucket (public)

### Check Policies:

1. Go to **Authentication** → **Policies**
2. You should see RLS policies for:
   - `projects` table
   - `page_content` table
   - `about_content` table
   - `storage.objects` (for the projects bucket)

---

## 🗑️ Clean Up Old Files

After successfully running the SQL, you can delete these old folders:

- `migrations/` (entire folder)
- `supabase/migrations/` (entire folder)

Keep only:

- `supabase/schema.sql`
- `supabase/seed.sql`
- `supabase/README.md`

---

## ❓ Need Help?

If you encounter errors:

1. **Check for existing tables:** If tables already exist, you may need to drop them first or modify the SQL to use `CREATE TABLE IF NOT EXISTS`
2. **Check for existing policies:** The SQL includes `DROP POLICY IF EXISTS` statements to handle this
3. **Check permissions:** Make sure you're logged in as the project owner

The SQL files are designed to be idempotent (safe to run multiple times), but if you have existing data, back it up first!
