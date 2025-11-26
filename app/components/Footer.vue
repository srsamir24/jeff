<template>
  <footer
    class="relative bg-linear-to-br from-blue-purple to-blue-purple/90 text-portfolio-white mt-auto overflow-hidden">
    <!-- Decorative background -->
    <div class="absolute top-0 right-0 w-96 h-96 bg-bright-pink/10 rounded-full blur-3xl"></div>
    <div class="absolute bottom-0 left-0 w-96 h-96 bg-light-green/10 rounded-full blur-3xl"></div>

    <div class="container mx-auto px-6 py-16 relative z-10">
      <div class="grid grid-cols-1 md:grid-cols-4 gap-12 mb-12">
        <!-- Brand Section -->
        <div class="md:col-span-2 space-y-6">
          <div>
            <h3
              class="text-3xl font-bold bg-clip-text text-transparent bg-linear-to-r from-bright-pink via-lighter-pink to-light-blue mb-2"
              style="font-family: 'Ibrand','Gendy', sans-serif;">
              Anna Ericyan
            </h3>
            <p class="text-light-blue text-sm">Graphics Designer</p>
          </div>
          <p class="text-light-blue/90 leading-relaxed max-w-md">
            Transforming ideas into stunning visual experiences. Let's create something beautiful together that tells
            your unique story.
          </p>
          <!-- Social Links -->
          <div class="flex items-center space-x-3">
            <span class="text-sm text-light-blue/70">Follow:</span>
            <a href="https://instagram.com/annaericyan" target="_blank" rel="noopener noreferrer"
              class="group w-10 h-10 rounded-full bg-portfolio-white/10 hover:bg-bright-pink text-light-blue hover:text-portfolio-white flex items-center justify-center transition-all duration-300 hover:scale-110"
              aria-label="Instagram">
              <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24">
                <path
                  d="M12 2.163c3.204 0 3.584.012 4.85.07 3.252.148 4.771 1.691 4.919 4.919.058 1.265.069 1.645.069 4.849 0 3.205-.012 3.584-.069 4.849-.149 3.225-1.664 4.771-4.919 4.919-1.266.058-1.644.07-4.85.07-3.204 0-3.584-.012-4.849-.07-3.26-.149-4.771-1.699-4.919-4.92-.058-1.265-.07-1.644-.07-4.849 0-3.204.013-3.583.07-4.849.149-3.227 1.664-4.771 4.919-4.919 1.266-.057 1.645-.069 4.849-.069z" />
              </svg>
            </a>
            <a href="https://behance.net/annaericyan" target="_blank" rel="noopener noreferrer"
              class="group w-10 h-10 rounded-full bg-portfolio-white/10 hover:bg-bright-pink text-light-blue hover:text-portfolio-white flex items-center justify-center transition-all duration-300 hover:scale-110"
              aria-label="Behance">
              <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24">
                <path
                  d="M22 7h-7v-2h7v2zm1.726 10c-.442 1.297-2.029 3-5.101 3-3.074 0-5.564-1.729-5.564-5.675 0-3.91 2.325-5.92 5.466-5.92 3.082 0 4.964 1.782 5.375 4.426.078.506.109 1.188.095 2.14h-8.027c.13 3.211 3.483 3.312 4.588 2.029h3.168z" />
              </svg>
            </a>
            <a href="https://dribbble.com/annaericyan" target="_blank" rel="noopener noreferrer"
              class="group w-10 h-10 rounded-full bg-portfolio-white/10 hover:bg-bright-pink text-light-blue hover:text-portfolio-white flex items-center justify-center transition-all duration-300 hover:scale-110"
              aria-label="Dribbble">
              <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24">
                <path
                  d="M12 0c-6.628 0-12 5.373-12 12s5.372 12 12 12 12-5.373 12-12-5.372-12-12-12zm9.885 11.441c-2.575-.422-4.943-.445-7.103-.073-.244-.563-.497-1.125-.767-1.68 2.31-1 4.165-2.358 5.548-4.082 1.35 1.594 2.197 3.619 2.322 5.835z" />
              </svg>
            </a>
          </div>
        </div>

        <!-- Quick Links -->
        <div>
          <h4 class="text-lg font-semibold mb-6 text-portfolio-white">Navigation</h4>
          <ul class="space-y-3">
            <li>
              <NuxtLink to="/"
                class="text-light-blue/90 hover:text-lighter-pink transition-colors inline-flex items-center group">
                <svg class="w-4 h-4 mr-2 opacity-0 group-hover:opacity-100 -ml-6 group-hover:ml-0 transition-all"
                  fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
                </svg>
                Home
              </NuxtLink>
            </li>
            <li>
              <NuxtLink to="/work"
                class="text-light-blue/90 hover:text-lighter-pink transition-colors inline-flex items-center group">
                <svg class="w-4 h-4 mr-2 opacity-0 group-hover:opacity-100 -ml-6 group-hover:ml-0 transition-all"
                  fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
                </svg>
                Work
              </NuxtLink>
            </li>
            <li>
              <NuxtLink to="/about"
                class="text-light-blue/90 hover:text-lighter-pink transition-colors inline-flex items-center group">
                <svg class="w-4 h-4 mr-2 opacity-0 group-hover:opacity-100 -ml-6 group-hover:ml-0 transition-all"
                  fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
                </svg>
                About
              </NuxtLink>
            </li>
            <li>
              <NuxtLink to="/contact"
                class="text-light-blue/90 hover:text-lighter-pink transition-colors inline-flex items-center group">
                <svg class="w-4 h-4 mr-2 opacity-0 group-hover:opacity-100 -ml-6 group-hover:ml-0 transition-all"
                  fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
                </svg>
                Contact
              </NuxtLink>
            </li>
          </ul>
        </div>

        <!-- Contact Info -->
        <div>
          <h4 class="text-lg font-semibold mb-6 text-portfolio-white">Get in Touch</h4>
          <ul class="space-y-3 text-light-blue/90 text-sm">
            <li class="flex items-start space-x-3">
              <svg class="w-5 h-5 mt-0.5 text-bright-pink shrink-0" fill="none" stroke="currentColor"
                viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                  d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z">
                </path>
              </svg>
              <a href="mailto:hello@annaericyan.com" class="hover:text-lighter-pink transition-colors">
                hello@annaericyan.com
              </a>
            </li>
            <li class="flex items-start space-x-3">
              <svg class="w-5 h-5 mt-0.5 text-bright-pink shrink-0" fill="none" stroke="currentColor"
                viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                  d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"></path>
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                  d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"></path>
              </svg>
              <span>Based in Your City</span>
            </li>
          </ul>
        </div>
      </div>

      <!-- Bottom Bar -->
      <div class="border-t border-light-blue/20 pt-8">
        <div class="flex flex-col md:flex-row justify-between items-center space-y-4 md:space-y-0">
          <p class="text-light-blue/70 text-sm">
            &copy; {{ new Date().getFullYear() }} Anna Ericyan. All rights reserved.
          </p>
          <div class="flex items-center space-x-6 text-sm text-light-blue/70">
            <span>Made by Zellap.com</span>
          </div>
        </div>
      </div>
    </div>
  </footer>
</template>

<script setup>
</script>
