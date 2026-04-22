import tailwindcss from '@tailwindcss/vite'

export default defineNuxtConfig({
  compatibilityDate: '2025-07-15',
  devtools: { enabled: true },
  css: ['~/assets/css/main.css'],

  app: {
    head: {
      link: [
        { rel: 'icon', type: 'image/svg+xml', href: '/favicon.svg' }
      ]
    }
  },

  modules: ['@nuxt/ui', '@nuxtjs/supabase'],

  // Nuxt UI handles colorMode — the classSuffix default is '' which pairs
  // correctly with Tailwind's darkMode: 'class' strategy.
  // Setting storage to 'cookie' means the server can read the user's
  // preference on first render and avoid any SSR/client mismatch.
  colorMode: {
    preference: 'dark',
    fallback: 'dark',
    storageKey: 'nuxt-color-mode',
    storage: 'cookie',
    classSuffix: ''
  },

  ui: {
    colorMode: true
  },

  supabase: {
    redirectOptions: {
      login: '/login',
      callback: '/confirm',
      exclude: ['/', '/work', '/work/*', '/about', '/contact'],
    },
    types: false
  },

  vite: {
    plugins: [
      tailwindcss()
    ]
  }
})
