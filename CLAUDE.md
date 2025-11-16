# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Nuxt 4 application with Vue 3 and Tailwind CSS 4. The project uses the `app/` directory structure (Nuxt 3+ convention).

## Development Commands

```bash
npm run dev       # Start development server (http://localhost:3000)
npm run build     # Build for production
npm run generate  # Generate static site
npm run preview   # Preview production build
```

## Architecture

### Directory Structure
- `app/` - Main application directory
  - `app.vue` - Root component (wraps NuxtPage)
  - `pages/` - File-based routing (e.g., pages/index.vue → /)
  - `assets/css/` - Global CSS files
  - `components/` - Vue components (auto-imported)
  - `layouts/` - Layout components
  - `plugins/` - Nuxt plugins

### Styling with Tailwind CSS 4
- Tailwind CSS 4 is integrated via `@tailwindcss/vite`
- Main CSS file: `app/assets/css/main.css` uses the new `@import 'tailwindcss'` syntax
- Tailwind content paths are configured in `tailwind.config.js` to scan the `app/` directory
- Global styles are registered in `nuxt.config.ts` via the `css` array

### Nuxt-Specific Features
- **Auto-imports**: Components, composables, and utilities are auto-imported (no explicit imports needed)
- **File-based routing**: Pages in `app/pages/` automatically create routes
- **TypeScript**: Generated types are in `.nuxt/` directory (created after `npm install`)
