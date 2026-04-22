<template>
  <nav
    ref="navRef"
    :class="[
      'fixed top-0 left-0 right-0 z-[100] h-16 flex items-center justify-between px-6 md:px-12 transition-all duration-300',
      isDarkSection ? 'bg-zinc-900/80 text-paper border-b border-paper/5' : 'bg-paper/80 text-charcoal border-b border-charcoal/5',
      'backdrop-blur-xl'
    ]"
  >
    <!-- Logo -->
    <NuxtLink
      to="/"
      class="font-hero text-2xl tracking-tighter hover:opacity-70 transition-opacity"
      :class="isDarkSection ? 'text-paper' : 'text-charcoal'"
    >
      Anna Ericyan
    </NuxtLink>

    <!-- Desktop menu -->
    <div class="hidden md:flex items-center gap-10">
      <NuxtLink
        v-for="link in mainLinks"
        :key="link.to"
        :to="link.to"
        class="font-display text-[13px] font-medium uppercase tracking-[0.05em] transition-all hover:opacity-100"
        :class="[
          isActive(link.to) ? 'opacity-100' : 'opacity-60',
          isDarkSection ? 'text-paper' : 'text-charcoal'
        ]"
      >
        {{ link.label }}
      </NuxtLink>

      <!-- Admin Link if logged in -->
      <NuxtLink
        v-if="user"
        to="/admin"
        class="font-display text-[13px] font-medium uppercase tracking-[0.05em] opacity-60 hover:opacity-100"
        :class="isDarkSection ? 'text-paper' : 'text-charcoal'"
      >
        Dashboard
      </NuxtLink>

      <!-- Social Links from DB -->
      <a
        v-for="link in navLinks"
        :key="link.id"
        :href="link.url"
        target="_blank"
        rel="noopener noreferrer"
        class="font-display text-[13px] font-medium uppercase tracking-[0.05em] opacity-60 hover:opacity-100"
        :class="isDarkSection ? 'text-paper' : 'text-charcoal'"
      >
        {{ link.name }}
      </a>
    </div>

    <!-- Right Side Actions -->
    <div class="flex items-center gap-6">
      <!-- Theme Toggle -->
      <ClientOnly>
        <button
          class="w-9 h-9 rounded-full border flex items-center justify-center transition-all hover:bg-ice/20"
          :class="isDarkSection ? 'border-paper/10' : 'border-charcoal/10'"
          @click="toggleColorMode"
        >
          <UIcon
            :name="isDark ? 'lucide:sun' : 'lucide:moon'"
            class="w-4 h-4"
            :class="isDarkSection ? 'text-paper' : 'text-charcoal'"
          />
        </button>
      </ClientOnly>

      <!-- Let's Talk Button -->
      <NuxtLink
        to="/contact"
        class="hidden md:block font-display text-[13px] font-semibold uppercase tracking-wider py-2 px-6 rounded-full transition-all"
        :class="isDarkSection ? 'bg-paper text-charcoal hover:bg-ice' : 'bg-charcoal text-paper hover:opacity-90'"
      >
        Let's Talk
      </NuxtLink>

      <!-- Mobile Toggle -->
      <button
        class="md:hidden p-2"
        @click="mobileMenuOpen = !mobileMenuOpen"
      >
        <UIcon
          :name="mobileMenuOpen ? 'lucide:x' : 'lucide:menu'"
          class="w-6 h-6"
          :class="isDarkSection ? 'text-paper' : 'text-charcoal'"
        />
      </button>
    </div>

    <!-- Mobile Menu Overlay -->
    <div
      v-if="mobileMenuOpen"
      class="fixed inset-0 top-16 z-[90] md:hidden px-6 py-12 flex flex-col gap-8 backdrop-blur-2xl"
      :class="isDarkSection ? 'bg-zinc-900/95 text-paper' : 'bg-paper/95 text-charcoal'"
    >
      <NuxtLink
        v-for="link in [...mainLinks, ...(user ? [{to:'/admin', label:'Dashboard'}] : [])]"
        :key="link.to"
        :to="link.to"
        class="font-display text-3xl font-bold tracking-tighter"
        @click="mobileMenuOpen = false"
      >
        {{ link.label }}
      </NuxtLink>
      
      <div class="h-px w-full opacity-10" :class="isDarkSection ? 'bg-paper' : 'bg-charcoal'" />
      
      <div class="flex flex-col gap-4">
        <a
          v-for="link in navLinks"
          :key="link.id"
          :href="link.url"
          target="_blank"
          class="font-display text-sm uppercase tracking-widest opacity-60"
        >
          {{ link.name }}
        </a>
      </div>

      <NuxtLink
        to="/contact"
        class="mt-auto py-5 text-center rounded-xl font-display font-bold uppercase tracking-widest"
        :class="isDarkSection ? 'bg-paper text-charcoal' : 'bg-charcoal text-paper'"
        @click="mobileMenuOpen = false"
      >
        Start a Project
      </NuxtLink>
    </div>
  </nav>
</template>

<script setup>
const supabase = useSupabaseClient()
const user = useSupabaseUser()
const colorMode = useColorMode()
const route = useRoute()

const mobileMenuOpen = ref(false)
const navLinks = ref([])
const isDarkSection = ref(false)
const navRef = ref(null)

const isDark = computed(() => colorMode.value === 'dark')

const toggleColorMode = () => {
  colorMode.preference = isDark.value ? 'light' : 'dark'
}

const mainLinks = [
  { to: '/', label: 'Work' },
  { to: '/work', label: 'Projects' },
  { to: '/about', label: 'About' },
]

const isActive = (path) => {
  if (path === '/' && route.path !== '/') return false
  return route.path.startsWith(path)
}

const fetchNavLinks = async () => {
  try {
    const { data, error } = await supabase
      .from('social_links')
      .select('*')
      .eq('is_active', true)
      .contains('display_location', ['nav'])
      .order('sort_order', { ascending: true })

    if (!error && data) navLinks.value = data
  } catch (err) {
    console.error('Error fetching nav social links:', err)
  }
}

// Premium Theme Switching Logic based on Scroll position
onMounted(() => {
  fetchNavLinks()

  // Intersection Observer to detect if we are over a dark section
  const observer = new IntersectionObserver(
    (entries) => {
      let darkVisibility = 0
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          darkVisibility += entry.intersectionRatio
        }
      })
      isDarkSection.value = darkVisibility > 0.1
    },
    { threshold: Array.from({ length: 20 }, (_, i) => (i + 1) / 20) }
  )

  // Give it a bit of time for DOM to stabilize
  setTimeout(() => {
    document.querySelectorAll('[data-theme="dark"]').forEach(el => observer.observe(el))
  }, 1000)

  onUnmounted(() => observer.disconnect())
})
</script>

<style scoped>
/* Force gendy for logo if font-hero used */
.font-hero {
  font-family: 'Gendy', serif !important;
}
</style>
