<template>
  <nav class="fixed top-0 left-0 right-0 z-50 bg-portfolio-white/80 backdrop-blur-md border-b border-light-blue/20 transition-all duration-300" :class="{ 'shadow-lg': scrolled }">
    <div class="container mx-auto px-6 py-5">
      <div class="flex items-center justify-between">
        <!-- Logo / Brand -->
        <NuxtLink to="/" class="group flex items-center space-x-2">
          <div class="relative">
            <div class="w-10 h-10 rounded-full bg-linear-to-br from-bright-pink to-blue-purple flex items-center justify-center shadow-md group-hover:shadow-lg transition-all duration-300 group-hover:scale-110">
              <span class="text-portfolio-white font-bold text-lg">AE</span>
            </div>
          </div>
          <div class="hidden sm:block">
            <div class="text-xl font-bold text-blue-purple group-hover:text-bright-pink transition-colors tracking-tight">
              Anna Ericyan
            </div>
            <div class="text-xs text-gray-500 -mt-1 tracking-wide">Graphics Designer</div>
          </div>
        </NuxtLink>

        <!-- Desktop Navigation -->
        <ul class="hidden md:flex items-center space-x-1">
          <li>
            <a href="https://www.upwork.com" target="_blank" rel="noopener noreferrer" class="inline-flex items-center space-x-2 px-4 py-2 bg-light-green/10 text-light-green rounded-full text-xs font-medium hover:bg-light-green/20 transition-all">
              <span class="w-2 h-2 bg-light-green rounded-full animate-pulse"></span>
              <span>Available on Upwork</span>
            </a>
          </li>
          <li>
            <NuxtLink to="/" class="px-4 py-2 text-sm font-medium text-gray-700 hover:text-bright-pink hover:bg-bright-pink/5 rounded-lg transition-all duration-200">
              Home
            </NuxtLink>
          </li>
          <li>
            <NuxtLink to="/work" class="px-4 py-2 text-sm font-medium text-gray-700 hover:text-bright-pink hover:bg-bright-pink/5 rounded-lg transition-all duration-200">
              Work
            </NuxtLink>
          </li>
          <li>
            <NuxtLink to="/about" class="px-4 py-2 text-sm font-medium text-gray-700 hover:text-bright-pink hover:bg-bright-pink/5 rounded-lg transition-all duration-200">
              About
            </NuxtLink>
          </li>
          <li>
            <NuxtLink to="/contact" class="ml-2 px-6 py-2.5 text-sm font-semibold text-portfolio-white bg-blue-purple hover:bg-bright-pink rounded-full transition-all duration-300 shadow-md hover:shadow-lg hover:-translate-y-0.5">
              Let's Talk
            </NuxtLink>
          </li>
        </ul>

        <!-- Mobile Menu Button -->
        <button @click="toggleMobileMenu" class="md:hidden p-2 text-blue-purple hover:text-bright-pink transition-colors rounded-lg hover:bg-bright-pink/5">
          <svg v-if="!mobileMenuOpen" class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"></path>
          </svg>
          <svg v-else class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
          </svg>
        </button>
      </div>

      <!-- Mobile Menu -->
      <transition
        enter-active-class="transition duration-200 ease-out"
        enter-from-class="opacity-0 -translate-y-2"
        enter-to-class="opacity-100 translate-y-0"
        leave-active-class="transition duration-150 ease-in"
        leave-from-class="opacity-100 translate-y-0"
        leave-to-class="opacity-0 -translate-y-2"
      >
        <div v-if="mobileMenuOpen" class="md:hidden mt-4 pb-4 border-t border-light-blue/20 pt-4">
          <ul class="space-y-2">
            <li>
              <NuxtLink to="/" @click="toggleMobileMenu" class="block px-4 py-3 text-gray-700 hover:text-bright-pink hover:bg-bright-pink/5 rounded-lg transition-all font-medium">
                Home
              </NuxtLink>
            </li>
            <li>
              <NuxtLink to="/work" @click="toggleMobileMenu" class="block px-4 py-3 text-gray-700 hover:text-bright-pink hover:bg-bright-pink/5 rounded-lg transition-all font-medium">
                Work
              </NuxtLink>
            </li>
            <li>
              <NuxtLink to="/about" @click="toggleMobileMenu" class="block px-4 py-3 text-gray-700 hover:text-bright-pink hover:bg-bright-pink/5 rounded-lg transition-all font-medium">
                About
              </NuxtLink>
            </li>
            <li>
              <NuxtLink to="/contact" @click="toggleMobileMenu" class="block px-4 py-3 text-center text-portfolio-white bg-blue-purple hover:bg-bright-pink rounded-lg transition-all font-semibold shadow-md">
                Let's Talk
              </NuxtLink>
            </li>
          </ul>
        </div>
      </transition>
    </div>
  </nav>
  <!-- Spacer to prevent content from hiding under fixed nav -->
  <div class="h-20"></div>
</template>

<script setup>
const mobileMenuOpen = ref(false)
const scrolled = ref(false)

const toggleMobileMenu = () => {
  mobileMenuOpen.value = !mobileMenuOpen.value
}

const handleScroll = () => {
  scrolled.value = window.scrollY > 20
}

onMounted(() => {
  window.addEventListener('scroll', handleScroll)
})

onUnmounted(() => {
  window.removeEventListener('scroll', handleScroll)
})
</script>
