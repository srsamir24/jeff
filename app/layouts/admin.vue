<template>
  <div class="min-h-screen bg-[var(--bg-color)] font-body text-[var(--text-color)] selection:bg-[var(--ui-primary)]/20 transition-colors duration-500">
    <!-- Desktop Sidebar -->
    <aside
      class="hidden lg:flex fixed inset-y-0 left-0 w-72 flex-col z-[100] border-r border-[var(--admin-border)] backdrop-blur-3xl bg-[var(--admin-header-bg)] transition-[transform,colors] duration-500"
      :class="sidebarCollapsed ? '-translate-x-full' : 'translate-x-0'"
    >
      <!-- Sidebar Header -->
      <div class="p-8 border-b border-[var(--admin-border)] flex items-start justify-between gap-2">
        <NuxtLink to="/admin" class="group flex flex-col gap-1">
          <h1 class="text-xl font-bold tracking-tighter font-display">
            ANNA ERICYAN
          </h1>
          <span class="text-[9px] uppercase tracking-[0.5em] text-[var(--admin-muted)] font-medium group-hover:text-[var(--ui-primary)] transition-colors duration-500">Dashboard</span>
        </NuxtLink>
        <button
          @click="sidebarCollapsed = true"
          class="shrink-0 w-8 h-8 -mr-1 flex items-center justify-center rounded-lg text-[var(--admin-muted)] hover:text-[var(--text-color)] hover:bg-[var(--admin-nav-hover)] transition-colors"
          title="Hide sidebar"
        >
          <Icon name="i-heroicons-chevron-double-left" class="w-5 h-5" />
        </button>
      </div>

      <!-- Navigation -->
      <nav class="flex-1 px-4 py-8 space-y-1 overflow-y-auto">
        <NuxtLink
          v-for="link in adminLinks"
          :key="link.to"
          :to="link.to"
          class="group flex items-center gap-4 px-4 py-3 rounded-xl transition-all duration-500 relative overflow-hidden"
          :class="isActive(link.to) ? 'bg-[var(--admin-nav-active)] text-[var(--text-color)]' : 'text-[var(--admin-muted)] hover:bg-[var(--admin-nav-hover)] hover:text-[var(--text-color)]'"
        >
          <Icon :name="link.icon" class="w-5 h-5 transition-transform duration-500 group-hover:scale-110" />
          <span class="text-[10px] uppercase tracking-[0.3em] font-medium">{{ link.label }}</span>
          
          <div 
            v-if="isActive(link.to)"
            class="absolute left-0 top-1/4 bottom-1/4 w-1 bg-[var(--ui-primary)] rounded-full shadow-[0_0_15px_var(--ui-primary)]"
          ></div>
        </NuxtLink>
      </nav>

      <!-- Sidebar Footer -->
      <div class="p-6 space-y-2 border-t border-[var(--admin-border)]">
        <!-- Theme Toggle -->
        <button 
          @click="toggleTheme" 
          class="w-full group flex items-center gap-4 px-4 py-3 rounded-xl hover:bg-[var(--admin-nav-hover)] transition-all duration-500"
        >
          <Icon :name="colorMode.value === 'dark' ? 'i-heroicons-moon' : 'i-heroicons-sun'" class="w-5 h-5 text-[var(--admin-muted)] group-hover:text-[var(--ui-primary)] transition-colors" />
          <span class="text-[10px] uppercase tracking-widest text-[var(--admin-muted)] group-hover:text-[var(--text-color)] transition-colors">
            {{ colorMode.value === 'dark' ? 'Dark Mode' : 'Light Mode' }}
          </span>
        </button>

        <NuxtLink to="/" class="group flex items-center gap-4 px-4 py-3 rounded-xl hover:bg-[var(--admin-nav-hover)] transition-all duration-500">
          <Icon name="i-heroicons-arrow-top-right-on-square" class="w-5 h-5 text-[var(--admin-muted)] group-hover:text-[var(--text-color)]" />
          <span class="text-[10px] uppercase tracking-widest text-[var(--admin-muted)] group-hover:text-[var(--text-color)] transition-colors">Live Site</span>
        </NuxtLink>

        <button 
          @click="handleLogout" 
          :disabled="loggingOut" 
          class="w-full group flex items-center gap-4 px-4 py-3 rounded-xl hover:bg-red-500/10 transition-all duration-500 text-left"
        >
          <Icon :name="loggingOut ? 'i-heroicons-arrow-path' : 'i-heroicons-arrow-left-on-rectangle'" 
            class="w-5 h-5 text-[var(--admin-muted)] group-hover:text-red-500 transition-colors"
            :class="{ 'animate-spin': loggingOut }"
          />
          <span class="text-[10px] uppercase tracking-widest text-[var(--admin-muted)] group-hover:text-red-500 transition-colors">
            {{ loggingOut ? 'Exiting...' : 'Sign Out' }}
          </span>
        </button>
      </div>
    </aside>

    <!-- Mobile Header -->
    <header class="lg:hidden fixed top-0 left-0 right-0 h-16 z-[90] border-b border-[var(--admin-border)] backdrop-blur-xl bg-[var(--admin-header-bg)] flex items-center justify-between px-6 transition-colors duration-500">
      <NuxtLink to="/admin" class="flex flex-col">
        <h1 class="text-sm font-bold tracking-tighter font-display">ANNA ERICYAN</h1>
        <span class="text-[8px] uppercase tracking-[0.3em] text-[var(--admin-muted)]">Dashboard</span>
      </NuxtLink>
      
      <div class="flex items-center gap-4">
        <button 
          @click="toggleTheme"
          class="w-10 h-10 flex items-center justify-center rounded-full bg-[var(--admin-nav-hover)] border border-[var(--admin-border)] hover:bg-[var(--admin-nav-active)] transition-all duration-300"
        >
          <Icon :name="colorMode.value === 'dark' ? 'i-heroicons-moon' : 'i-heroicons-sun'" class="w-5 h-5 text-[var(--text-color)]" />
        </button>

        <button 
          @click="isMobileMenuOpen = !isMobileMenuOpen"
          class="w-10 h-10 flex items-center justify-center rounded-full bg-[var(--admin-nav-hover)] border border-[var(--admin-border)] hover:bg-[var(--admin-nav-active)] transition-all duration-300"
        >
          <Icon :name="isMobileMenuOpen ? 'i-heroicons-x-mark' : 'i-heroicons-bars-3-bottom-right'" class="w-5 h-5 text-[var(--text-color)]" />
        </button>
      </div>
    </header>

    <!-- Mobile Menu Overlay -->
    <Transition
      enter-active-class="transition-opacity duration-300"
      enter-from-class="opacity-0"
      enter-to-class="opacity-100"
      leave-active-class="transition-opacity duration-300"
      leave-from-class="opacity-100"
      leave-to-class="opacity-0"
    >
      <div v-if="isMobileMenuOpen" class="lg:hidden fixed inset-0 z-[95] bg-black/40 backdrop-blur-sm" @click="isMobileMenuOpen = false"></div>
    </Transition>

    <!-- Mobile Menu Drawer -->
    <Transition
      enter-active-class="transition-transform duration-500 ease-out"
      enter-from-class="-translate-x-full"
      enter-to-class="translate-x-0"
      leave-active-class="transition-transform duration-500 ease-in"
      leave-from-class="translate-x-0"
      leave-to-class="-translate-x-full"
    >
      <aside v-if="isMobileMenuOpen" class="lg:hidden fixed inset-y-0 left-0 w-[280px] z-[100] bg-[var(--bg-color)] border-r border-[var(--admin-border)] flex flex-col shadow-2xl transition-colors duration-500">
        <div class="p-8 border-b border-[var(--admin-border)]">
          <h1 class="text-xl font-bold tracking-tighter font-display">ANNA ERICYAN</h1>
        </div>

        <nav class="flex-1 px-4 py-8 space-y-2 overflow-y-auto font-body">
          <NuxtLink
            v-for="link in adminLinks"
            :key="link.to"
            :to="link.to"
            @click="isMobileMenuOpen = false"
            class="flex items-center gap-4 px-4 py-4 rounded-xl transition-all duration-300"
            :class="isActive(link.to) ? 'bg-[var(--admin-nav-active)] text-[var(--text-color)] border-l-4 border-[var(--ui-primary)]' : 'text-[var(--admin-muted)]'"
          >
            <Icon :name="link.icon" class="w-5 h-5" />
            <span class="text-[10px] uppercase tracking-[0.3em] font-medium">{{ link.label }}</span>
          </NuxtLink>
        </nav>

        <div class="p-6 space-y-4 border-t border-[var(--admin-border)] bg-[var(--admin-nav-hover)]">
          <NuxtLink to="/" @click="isMobileMenuOpen = false" class="flex items-center gap-4 px-4 py-3 rounded-xl text-[var(--admin-muted)] hover:text-[var(--text-color)] transition-colors">
            <Icon name="i-heroicons-arrow-top-right-on-square" class="w-5 h-5" />
            <span class="text-[10px] uppercase tracking-widest">Live Site</span>
          </NuxtLink>
          <button @click="handleLogout" class="w-full flex items-center gap-4 px-4 py-3 rounded-xl text-red-500/60 hover:text-red-500 transition-colors">
            <Icon name="i-heroicons-arrow-left-on-rectangle" class="w-5 h-5" />
            <span class="text-[10px] uppercase tracking-widest">Sign Out</span>
          </button>
        </div>
      </aside>
    </Transition>

    <!-- Floating reopen button (desktop, when sidebar hidden) -->
    <button
      v-if="sidebarCollapsed"
      @click="sidebarCollapsed = false"
      class="hidden lg:flex fixed top-6 left-6 z-[110] w-11 h-11 items-center justify-center rounded-full border border-[var(--admin-border)] bg-[var(--admin-header-bg)] backdrop-blur-xl text-[var(--admin-muted)] hover:text-[var(--text-color)] hover:bg-[var(--admin-nav-active)] shadow-lg transition-all duration-300"
      title="Show sidebar"
    >
      <Icon name="i-heroicons-bars-3" class="w-5 h-5" />
    </button>

    <!-- Main Content -->
    <main class="transition-all duration-500 pt-16 lg:pt-0" :class="sidebarCollapsed ? 'lg:pl-0' : 'lg:pl-72'">
      <div class="p-6 md:p-12 max-w-[1400px] mx-auto min-h-screen">
        <div class="bg-[var(--admin-card-bg)] border border-[var(--admin-border)] rounded-3xl p-8 md:p-12 backdrop-blur-sm min-h-[calc(100vh-6rem)] shadow-sm transition-colors duration-500">
          <slot />
        </div>
      </div>
    </main>

    <!-- Global Components -->
    <ConfirmDialog 
      :show="confirmDialog.showDialog.value" 
      :message="confirmDialog.message.value"
      @confirm="confirmDialog.handleConfirm()" 
      @cancel="confirmDialog.handleCancel()" 
    />
  </div>
</template>

<script setup>
import { useConfirm } from '~/composables/useConfirm'

const route = useRoute()
const supabase = useSupabaseClient()
const colorMode = useColorMode()
const confirmDialog = useConfirm()

const loggingOut = ref(false)
const isMobileMenuOpen = ref(false)
const sidebarCollapsed = ref(false)

// Persist the collapsed preference across navigations/reloads
onMounted(() => {
  sidebarCollapsed.value = localStorage.getItem('admin-sidebar-collapsed') === '1'
})
watch(sidebarCollapsed, (v) => {
  localStorage.setItem('admin-sidebar-collapsed', v ? '1' : '0')
})

const adminLinks = [
  { to: '/admin/studio', label: 'AI Studio', icon: 'i-heroicons-sparkles' },
  { to: '/admin/projects', label: 'Projects', icon: 'i-heroicons-rectangle-stack' },
  { to: '/admin/featured-projects', label: 'Featured', icon: 'i-heroicons-star' },
  { to: '/admin/about', label: 'About', icon: 'i-heroicons-user' },
  { to: '/admin/social-links', label: 'Social', icon: 'i-heroicons-share' },
  { to: '/admin/content', label: 'Content', icon: 'i-heroicons-document-text' }
]

const isActive = (path) => {
  if (path === '/admin' && route.path !== '/admin') return false
  return route.path.startsWith(path)
}

const toggleTheme = () => {
  colorMode.preference = colorMode.value === 'dark' ? 'light' : 'dark'
}

const handleLogout = async () => {
  const confirmed = await confirmDialog.confirm('Are you sure you want to sign out?')
  if (!confirmed) return

  loggingOut.value = true
  try {
    const { error } = await supabase.auth.signOut()
    if (error) throw error
    navigateTo('/login')
  } catch (error) {
    console.error('Logout error:', error)
  } finally {
    loggingOut.value = false
    isMobileMenuOpen.value = false
  }
}

// Close mobile menu on route change
watch(() => route.path, () => {
  isMobileMenuOpen.value = false
})
</script>

<style>
/* Global scrollbar for premium feel */
::-webkit-scrollbar {
  width: 4px;
}
::-webkit-scrollbar-track {
  background: transparent;
}
::-webkit-scrollbar-thumb {
  background: var(--admin-border);
  border-radius: 10px;
}
::-webkit-scrollbar-thumb:hover {
  background: var(--admin-muted);
}

/* Ensure borders are visible despite the global rule if we use specific classes */
.border-visible {
  border-color: var(--admin-border) !important;
}
</style>
