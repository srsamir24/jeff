/** @type {import('tailwindcss').Config} */
export default {
  content: [
    './app/components/**/*.{js,vue,ts}',
    './app/layouts/**/*.vue',
    './app/pages/**/*.vue',
    './app/plugins/**/*.{js,ts}',
    './app/**/*.vue'
  ],
  theme: {
    extend: {
      colors: {
        // ── accent singles (used throughout components) ──
        'light-green':    '#00f5c4', // neon teal
        'lighter-pink':   '#b06bff', // electric violet
        'light-blue':     '#00e0ff', // cyan glow
        'portfolio-white':'#f8fffd', // crystal mint

        // ── keep old names so no template breaks — new values ──
        'blue-purple':  '#b06bff', // electric violet (was blue, now purple)
        'bright-pink':  '#00d4a8', // neon teal accent

        // ── full neon-teal scale ──
        'neon-teal': {
          50:  '#e6fff9',
          100: '#b3ffe9',
          200: '#66ffd5',
          300: '#1affc0',
          400: '#00f5c4',
          500: '#00d4a8',
          600: '#00a882',
          700: '#007d61',
          800: '#005242',
          900: '#002f26',
          950: '#00150f',
        },

        // ── full electric-violet scale ──
        'electric-violet': {
          50:  '#f5eeff',
          100: '#e8d4ff',
          200: '#d0aaff',
          300: '#b87dff',
          400: '#a050ff',
          500: '#8b2eff',
          600: '#7316e0',
          700: '#5b0fb8',
          800: '#440a8a',
          900: '#2d0663',
          950: '#16023a',
        },
      },
    },
  },
  plugins: [],
}
