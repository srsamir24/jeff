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
          <div v-if="footerLinks.length > 0" class="flex items-center space-x-3">
            <span class="text-sm text-light-blue/70">Follow:</span>
            <a v-for="link in footerLinks" :key="link.id" :href="link.url" target="_blank" rel="noopener noreferrer"
              class="group w-10 h-10 rounded-full bg-portfolio-white/10 hover:bg-bright-pink text-light-blue hover:text-portfolio-white flex items-center justify-center transition-all duration-300 hover:scale-110"
              :aria-label="link.name">
              <component :is="getSocialIcon(link.icon_type)" class="w-5 h-5" />
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
const supabase = useSupabaseClient()
const footerLinks = ref([])

// Fetch social links for footer
const fetchSocialLinks = async () => {
  try {
    const { data, error } = await supabase
      .from('social_links')
      .select('*')
      .eq('is_active', true)
      .contains('display_location', ['footer'])
      .order('sort_order', { ascending: true })

    if (!error && data) {
      footerLinks.value = data
    }
  } catch (err) {
    console.error('Error fetching footer social links:', err)
  }
}

// Social icon components
const getSocialIcon = (iconType) => {
  const icons = {
    instagram: () => h('svg', { fill: 'currentColor', viewBox: '0 0 24 24' }, [
      h('path', { d: 'M12 2.163c3.204 0 3.584.012 4.85.07 3.252.148 4.771 1.691 4.919 4.919.058 1.265.069 1.645.069 4.849 0 3.205-.012 3.584-.069 4.849-.149 3.225-1.664 4.771-4.919 4.919-1.266.058-1.644.07-4.85.07-3.204 0-3.584-.012-4.849-.07-3.26-.149-4.771-1.699-4.919-4.92-.058-1.265-.07-1.644-.07-4.849 0-3.204.013-3.583.07-4.849.149-3.227 1.664-4.771 4.919-4.919 1.266-.057 1.645-.069 4.849-.069z' })
    ]),
    behance: () => h('svg', { fill: 'currentColor', viewBox: '0 0 24 24' }, [
      h('path', { d: 'M22 7h-7v-2h7v2zm1.726 10c-.442 1.297-2.029 3-5.101 3-3.074 0-5.564-1.729-5.564-5.675 0-3.91 2.325-5.92 5.466-5.92 3.082 0 4.964 1.782 5.375 4.426.078.506.109 1.188.095 2.14h-8.027c.13 3.211 3.483 3.312 4.588 2.029h3.168z' })
    ]),
    dribbble: () => h('svg', { fill: 'currentColor', viewBox: '0 0 24 24' }, [
      h('path', { d: 'M12 0c-6.628 0-12 5.373-12 12s5.372 12 12 12 12-5.373 12-12-5.372-12-12-12zm9.885 11.441c-2.575-.422-4.943-.445-7.103-.073-.244-.563-.497-1.125-.767-1.68 2.31-1 4.165-2.358 5.548-4.082 1.35 1.594 2.197 3.619 2.322 5.835z' })
    ]),
    linkedin: () => h('svg', { fill: 'currentColor', viewBox: '0 0 24 24' }, [
      h('path', { d: 'M20.447 20.452h-3.554v-5.569c0-1.328-.027-3.037-1.852-3.037-1.853 0-2.136 1.445-2.136 2.939v5.667H9.351V9h3.414v1.561h.046c.477-.9 1.637-1.85 3.37-1.85 3.601 0 4.267 2.37 4.267 5.455v6.286zM5.337 7.433c-1.144 0-2.063-.926-2.063-2.065 0-1.138.92-2.063 2.063-2.063 1.14 0 2.064.925 2.064 2.063 0 1.139-.925 2.065-2.064 2.065zm1.782 13.019H3.555V9h3.564v11.452zM22.225 0H1.771C.792 0 0 .774 0 1.729v20.542C0 23.227.792 24 1.771 24h20.451C23.2 24 24 23.227 24 22.271V1.729C24 .774 23.2 0 22.222 0h.003z' })
    ]),
    twitter: () => h('svg', { fill: 'currentColor', viewBox: '0 0 24 24' }, [
      h('path', { d: 'M23.953 4.57a10 10 0 01-2.825.775 4.958 4.958 0 002.163-2.723c-.951.555-2.005.959-3.127 1.184a4.92 4.92 0 00-8.384 4.482C7.69 8.095 4.067 6.13 1.64 3.162a4.822 4.822 0 00-.666 2.475c0 1.71.87 3.213 2.188 4.096a4.904 4.904 0 01-2.228-.616v.06a4.923 4.923 0 003.946 4.827 4.996 4.996 0 01-2.212.085 4.936 4.936 0 004.604 3.417 9.867 9.867 0 01-6.102 2.105c-.39 0-.779-.023-1.17-.067a13.995 13.995 0 007.557 2.209c9.053 0 13.998-7.496 13.998-13.985 0-.21 0-.42-.015-.63A9.935 9.935 0 0024 4.59z' })
    ]),
    facebook: () => h('svg', { fill: 'currentColor', viewBox: '0 0 24 24' }, [
      h('path', { d: 'M24 12.073c0-6.627-5.373-12-12-12s-12 5.373-12 12c0 5.99 4.388 10.954 10.125 11.854v-8.385H7.078v-3.47h3.047V9.43c0-3.007 1.792-4.669 4.533-4.669 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.925-1.956 1.874v2.25h3.328l-.532 3.47h-2.796v8.385C19.612 23.027 24 18.062 24 12.073z' })
    ]),
    upwork: () => h('svg', { fill: 'currentColor', viewBox: '0 0 24 24' }, [
      h('path', { d: 'M18.561 13.158c-1.102 0-2.135-.467-3.074-1.227l.228-1.076.008-.042c.207-1.143.849-3.06 2.839-3.06 1.492 0 2.703 1.212 2.703 2.703-.001 1.489-1.212 2.702-2.704 2.702zm0-8.14c-2.539 0-4.51 1.649-5.31 4.366-1.22-1.834-2.148-4.036-2.687-5.892H7.828v7.112c-.002 1.406-1.141 2.546-2.547 2.548-1.405-.002-2.543-1.143-2.545-2.548V3.492H0v7.112c0 2.914 2.37 5.303 5.281 5.303 2.913 0 5.283-2.389 5.283-5.303v-1.19c.529 1.107 1.182 2.229 1.974 3.221l-1.673 7.873h2.797l1.213-5.71c1.063.679 2.285 1.109 3.686 1.109 3 0 5.439-2.452 5.439-5.45 0-3-2.439-5.439-5.439-5.439z' })
    ]),
    link: () => h('svg', { fill: 'none', stroke: 'currentColor', viewBox: '0 0 24 24' }, [
      h('path', { 'stroke-linecap': 'round', 'stroke-linejoin': 'round', 'stroke-width': '2', d: 'M13.828 10.172a4 4 0 00-5.656 0l-4 4a4 4 0 105.656 5.656l1.102-1.101m-.758-4.899a4 4 0 005.656 0l4-4a4 4 0 00-5.656-5.656l-1.1 1.1' })
    ])
  }
  return icons[iconType] || icons.link
}

onMounted(() => {
  fetchSocialLinks()
})
</script>
