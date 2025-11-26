<template>
  <div class="min-h-screen bg-gray-50">
    <!-- Admin Header -->
    <header class="bg-portfolio-white border-b border-gray-200 sticky top-0 z-50">
      <div class="container mx-auto px-6 py-4">
        <div class="flex items-center justify-between">
          <div class="flex items-center space-x-4">
            <h1
              class="text-2xl font-bold bg-clip-text text-transparent bg-linear-to-r from-bright-pink via-blue-purple to-light-blue"
              style="font-family: 'Gendy', sans-serif;">
              Admin Dashboard
            </h1>
            <span class="px-3 py-1 bg-light-green/10 text-light-green text-xs font-medium rounded-full">
              Online
            </span>
          </div>

          <div class="flex items-center space-x-4">
            <NuxtLink to="/"
              class="px-4 py-2 bg-light-blue/10 text-light-blue rounded-lg text-sm font-medium hover:bg-light-blue/20 transition-all flex items-center space-x-2">
              <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                  d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6">
                </path>
              </svg>
              <span>View Site</span>
            </NuxtLink>
            <div class="text-right">
              <p class="text-sm font-medium text-gray-900">{{ user?.email }}</p>
              <p class="text-xs text-gray-500">Administrator</p>
            </div>
            <AppButton variant="danger" size="sm" rounded="lg" :loading="loggingOut" loading-text="Logging out..."
              @click="handleLogout">
              Logout
              <template #iconRight>
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                    d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1">
                  </path>
                </svg>
              </template>
            </AppButton>
          </div>
        </div>
      </div>
    </header>

    <!-- Main Content -->
    <main class="container mx-auto px-6 py-8">
      <!-- Quick Actions -->
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        <!-- Projects Card -->
        <NuxtLink to="/admin/projects"
          class="group bg-portfolio-white rounded-2xl p-8 shadow-md border border-gray-100 hover:shadow-xl hover:border-blue-purple/20 transition-all">
          <div class="flex items-center justify-between mb-6">
            <div
              class="w-16 h-16 bg-linear-to-br from-blue-purple to-light-blue rounded-2xl flex items-center justify-center group-hover:scale-110 transition-transform">
              <svg class="w-8 h-8 text-portfolio-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                  d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10" />
              </svg>
            </div>
            <div class="text-right">
              <div class="text-3xl font-bold text-blue-purple group-hover:text-bright-pink transition-colors">{{
                stats.projects || 0 }}</div>
              <div class="text-xs text-gray-500 mt-1">Total</div>
            </div>
          </div>
          <h3 class="text-xl font-bold text-gray-900 mb-2 group-hover:text-blue-purple transition-colors">Manage
            Projects
          </h3>
          <p class="text-sm text-gray-500">Add, edit, or remove portfolio projects</p>
        </NuxtLink>

        <!-- Featured Projects Card -->
        <NuxtLink to="/admin/featured-projects"
          class="group bg-portfolio-white rounded-2xl p-8 shadow-md border border-gray-100 hover:shadow-xl hover:border-light-green/20 transition-all">
          <div class="flex items-center justify-between mb-6">
            <div
              class="w-16 h-16 bg-linear-to-br from-light-green to-light-green/70 rounded-2xl flex items-center justify-center group-hover:scale-110 transition-transform">
              <svg class="w-8 h-8 text-portfolio-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                  d="M11.049 2.927c.3-.921 1.603-.921 1.902 0l1.519 4.674a1 1 0 00.95.69h4.915c.969 0 1.371 1.24.588 1.81l-3.976 2.888a1 1 0 00-.363 1.118l1.518 4.674c.3.922-.755 1.688-1.538 1.118l-3.976-2.888a1 1 0 00-1.176 0l-3.976 2.888c-.783.57-1.838-.197-1.538-1.118l1.518-4.674a1 1 0 00-.363-1.118l-3.976-2.888c-.784-.57-.38-1.81.588-1.81h4.914a1 1 0 00.951-.69l1.519-4.674z" />
              </svg>
            </div>
            <div class="text-right">
              <div class="text-3xl font-bold text-light-green group-hover:text-blue-purple transition-colors">{{
                stats.featured || 0 }}</div>
              <div class="text-xs text-gray-500 mt-1">Featured</div>
            </div>
          </div>
          <h3 class="text-xl font-bold text-gray-900 mb-2 group-hover:text-light-green transition-colors">Featured
            Projects
          </h3>
          <p class="text-sm text-gray-500">Select homepage featured projects</p>
        </NuxtLink>

        <!-- About Page Card -->
        <NuxtLink to="/admin/about"
          class="group bg-portfolio-white rounded-2xl p-8 shadow-md border border-gray-100 hover:shadow-xl hover:border-light-blue/20 transition-all">
          <div class="flex items-center justify-between mb-6">
            <div
              class="w-16 h-16 bg-linear-to-br from-light-blue to-light-blue/70 rounded-2xl flex items-center justify-center group-hover:scale-110 transition-transform">
              <svg class="w-8 h-8 text-portfolio-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                  d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
              </svg>
            </div>
            <div class="text-right">
              <div class="text-3xl font-bold text-light-blue group-hover:text-bright-pink transition-colors">4</div>
              <div class="text-xs text-gray-500 mt-1">Sections</div>
            </div>
          </div>
          <h3 class="text-xl font-bold text-gray-900 mb-2 group-hover:text-light-blue transition-colors">About Page</h3>
          <p class="text-sm text-gray-500">Edit about page content & timeline</p>
        </NuxtLink>

        <!-- Content Management Card -->
        <NuxtLink to="/admin/content"
          class="group bg-portfolio-white rounded-2xl p-8 shadow-md border border-gray-100 hover:shadow-xl hover:border-bright-pink/20 transition-all">
          <div class="flex items-center justify-between mb-6">
            <div
              class="w-16 h-16 bg-linear-to-br from-bright-pink to-lighter-pink rounded-2xl flex items-center justify-center group-hover:scale-110 transition-transform">
              <svg class="w-8 h-8 text-portfolio-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                  d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
              </svg>
            </div>
            <div class="text-right">
              <div class="text-3xl font-bold text-bright-pink group-hover:text-light-green transition-colors">3</div>
              <div class="text-xs text-gray-500 mt-1">Sections</div>
            </div>
          </div>
          <h3 class="text-xl font-bold text-gray-900 mb-2 group-hover:text-bright-pink transition-colors">Page Content
          </h3>
          <p class="text-sm text-gray-500">Edit homepage sections & text content</p>
        </NuxtLink>
      </div>
    </main>

    <!-- Confirm Dialog -->
    <ConfirmDialog :show="confirmDialog.showDialog.value" :message="confirmDialog.message.value"
      @confirm="confirmDialog.handleConfirm()" @cancel="confirmDialog.handleCancel()" />
  </div>
</template>

<script setup>
import ConfirmDialog from '~/components/ConfirmDialog.vue'
import { useConfirm } from '~/composables/useConfirm'

definePageMeta({
  middleware: 'admin',
  layout: false
})

const confirmDialog = useConfirm()

const supabase = useSupabaseClient()
const user = useSupabaseUser()
const loggingOut = ref(false)

// Stats
const stats = ref({
  projects: 0,
  featured: 0
})

// Fetch real stats
const fetchStats = async () => {
  // Get project count
  const { count: projectCount } = await supabase
    .from('projects')
    .select('*', { count: 'exact', head: true })

  // Get featured project count
  const { count: featuredCount } = await supabase
    .from('projects')
    .select('*', { count: 'exact', head: true })
    .eq('featured', true)

  stats.value.projects = projectCount || 0
  stats.value.featured = featuredCount || 0
}

// Logout with confirmation and animation
const logout = async () => {
  const confirmed = await confirmDialog.confirm('You will be logged out of the admin panel.')
  if (!confirmed) return

  loggingOut.value = true

  try {
    await new Promise(resolve => setTimeout(resolve, 500)) // Small delay for animation
    await supabase.auth.signOut()
    navigateTo('/admin/login')
  } catch (error) {
    console.error('Logout error:', error)
    loggingOut.value = false
  }
}

onMounted(() => {
  fetchStats()
})
</script>
