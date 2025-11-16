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
        'light-green': '#a0dd88',
        'bright-pink': '#e64191',
        'lighter-pink': '#eda4c9',
        'light-blue': '#97d1f0',
        'blue-purple': '#6c69cf',
        'portfolio-white': '#fcfcfc',
      },
    },
  },
  plugins: [],
}
