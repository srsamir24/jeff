<template>
  <nav
    class="fixed top-0 left-0 right-0 z-50 bg-portfolio-white/80 backdrop-blur-md border-b border-light-blue/20 transition-all duration-300"
    :class="{ 'shadow-lg': scrolled }">
    <div class="container mx-auto px-6 py-5">
      <div class="flex items-center justify-between">
        <!-- Logo / Brand -->
        <NuxtLink to="/" class="group">
          <div
            class="text-2xl sm:text-3xl font-bold bg-clip-text text-transparent bg-linear-to-r from-bright-pink via-blue-purple to-light-blue group-hover:scale-105 transition-transform duration-300"
            style="font-family: 'Ibrand','Gendy', sans-serif;">
            Anna Ericyan
          </div>
        </NuxtLink>

        <!-- Desktop Navigation -->
        <div class="hidden md:flex items-center gap-8">
          <ul class="flex items-center space-x-1">
            <li>
              <NuxtLink to="/"
                class="px-4 py-2 text-sm font-medium text-gray-700 hover:text-bright-pink hover:bg-bright-pink/5 rounded-lg transition-all duration-200">
                Home
              </NuxtLink>
            </li>
            <li>
              <NuxtLink to="/work"
                class="px-4 py-2 text-sm font-medium text-gray-700 hover:text-bright-pink hover:bg-bright-pink/5 rounded-lg transition-all duration-200">
                Work
              </NuxtLink>
            </li>
            <li>
              <NuxtLink to="/about"
                class="px-4 py-2 text-sm font-medium text-gray-700 hover:text-bright-pink hover:bg-bright-pink/5 rounded-lg transition-all duration-200">
                About
              </NuxtLink>
            </li>
          </ul>

          <div class="flex items-center gap-2">
            <a href="https://www.upwork.com" target="_blank" rel="noopener noreferrer"
              class="inline-flex items-center space-x-1.5 px-3 py-1.5 bg-light-green/40 text-light-green rounded-full text-xs font-bold hover:bg-light-green/50 transition-all shadow-md border border-light-green/30">
              <span class="w-2 h-2 bg-light-green rounded-full animate-pulse"></span>
              <span>Upwork</span>
            </a>
            <NuxtLink v-if="user" to="/admin"
              class="inline-flex items-center space-x-1.5 px-3 py-1.5 bg-blue-purple/30 text-blue-purple rounded-full text-xs font-bold hover:bg-blue-purple/40 transition-all shadow-md border border-blue-purple/30">
              <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"></path>
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
              </svg>
              <span>Admin</span>
            </NuxtLink>
          </div>

          <AppButton
            to="/contact"
            variant="secondary"
            size="sm"
          >
            Let's Talk
          </AppButton>
        </div>

        <!-- Mobile Menu Button -->
        <button @click="toggleMobileMenu"
          class="md:hidden p-2 text-blue-purple hover:text-bright-pink transition-colors rounded-lg hover:bg-bright-pink/5">
          <svg v-if="!mobileMenuOpen" class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"></path>
          </svg>
          <svg v-else class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
          </svg>
        </button>
      </div>

      <!-- Mobile Menu -->
      <transition enter-active-class="transition duration-200 ease-out" enter-from-class="opacity-0 -translate-y-2"
        enter-to-class="opacity-100 translate-y-0" leave-active-class="transition duration-150 ease-in"
        leave-from-class="opacity-100 translate-y-0" leave-to-class="opacity-0 -translate-y-2">
        <div v-if="mobileMenuOpen" class="md:hidden mt-4 pb-4 border-t border-light-blue/20 pt-4">
          <ul class="space-y-2">
            <li>
              <NuxtLink to="/" @click="toggleMobileMenu"
                class="block px-4 py-3 text-gray-700 hover:text-bright-pink hover:bg-bright-pink/5 rounded-lg transition-all font-medium">
                Home
              </NuxtLink>
            </li>
            <li>
              <NuxtLink to="/work" @click="toggleMobileMenu"
                class="block px-4 py-3 text-gray-700 hover:text-bright-pink hover:bg-bright-pink/5 rounded-lg transition-all font-medium">
                Work
              </NuxtLink>
            </li>
            <li>
              <NuxtLink to="/about" @click="toggleMobileMenu"
                class="block px-4 py-3 text-gray-700 hover:text-bright-pink hover:bg-bright-pink/5 rounded-lg transition-all font-medium">
                About
              </NuxtLink>
            </li>
            <li>
              <a href="https://www.upwork.com" target="_blank" rel="noopener noreferrer"
                class="flex items-center justify-center space-x-2 px-4 py-3 bg-light-green/10 text-light-green rounded-lg hover:bg-light-green/20 transition-all font-medium">
                <span class="w-2 h-2 bg-light-green rounded-full animate-pulse"></span>
                <span>Available on Upwork</span>
              </a>
            </li>
            <li v-if="user">
              <NuxtLink to="/admin" @click="toggleMobileMenu"
                class="flex items-center justify-center space-x-2 px-4 py-3 bg-light-blue/10 text-light-blue rounded-lg hover:bg-light-blue/20 transition-all font-medium">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"></path>
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
                </svg>
                <span>Admin Dashboard</span>
              </NuxtLink>
            </li>
            <li class="flex justify-center">
              <AppButton
                to="/contact"
                variant="primary"
                size="md"
                @click="toggleMobileMenu"
              >
                Let's Talk
              </AppButton>
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
const user = useSupabaseUser()
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
