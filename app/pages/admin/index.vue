<template>
  <NuxtLayout name="admin">
    <div class="space-y-16 animate-fade-in">
      <!-- Welcome Header -->
      <div class="space-y-4">
        <h2 class="text-5xl font-bold tracking-tighter" style="font-family: 'Space Grotesk', sans-serif;">
          Welcome back, <span class="text-white/40">{{ user?.email?.split('@')[0] }}</span>
        </h2>
        <p class="text-white/30 text-sm uppercase tracking-[0.3em]">System Overview & Statistics</p>
      </div>

      <!-- Stats Grid -->
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        <!-- Projects Stat -->
        <NuxtLink to="/admin/projects" class="group relative p-12 bg-white/5 overflow-hidden transition-all duration-700 hover:bg-white/[0.08]">
          <div class="relative z-10 flex flex-col h-full justify-between">
            <span class="text-[10px] uppercase tracking-[0.4em] text-white/30 group-hover:text-white/50 transition-colors duration-500">Total Projects</span>
            <div class="mt-8">
              <span class="text-7xl font-bold tracking-tighter group-hover:scale-110 block origin-left transition-transform duration-700" style="font-family: 'Space Grotesk', sans-serif;">
                {{ stats.projects || 0 }}
              </span>
            </div>
            <div class="mt-8 flex items-center gap-2 text-[10px] uppercase tracking-widest text-white/20 group-hover:text-white transition-colors duration-500">
              Manage Repository <span class="group-hover:translate-x-2 transition-transform duration-500">→</span>
            </div>
          </div>
          <!-- Decorative element -->
          <div class="absolute -right-8 -bottom-8 w-32 h-32 bg-white/[0.02] rounded-full blur-3xl group-hover:bg-white/[0.05] transition-all duration-700"></div>
        </NuxtLink>

        <!-- Featured Stat -->
        <NuxtLink to="/admin/featured-projects" class="group relative p-12 bg-white/5 overflow-hidden transition-all duration-700 hover:bg-white/[0.08]">
          <div class="relative z-10 flex flex-col h-full justify-between">
            <span class="text-[10px] uppercase tracking-[0.4em] text-white/30 group-hover:text-white/50 transition-colors duration-500">Featured Showcase</span>
            <div class="mt-8">
              <span class="text-7xl font-bold tracking-tighter group-hover:scale-110 block origin-left transition-transform duration-700" style="font-family: 'Space Grotesk', sans-serif;">
                {{ stats.featured || 0 }}
              </span>
            </div>
            <div class="mt-8 flex items-center gap-2 text-[10px] uppercase tracking-widest text-white/20 group-hover:text-white transition-colors duration-500">
              Refine Gallery <span class="group-hover:translate-x-2 transition-transform duration-500">→</span>
            </div>
          </div>
          <div class="absolute -right-8 -bottom-8 w-32 h-32 bg-white/[0.02] rounded-full blur-3xl group-hover:bg-white/[0.05] transition-all duration-700"></div>
        </NuxtLink>

        <!-- Social Links Stat -->
        <NuxtLink to="/admin/social-links" class="group relative p-12 bg-white/5 overflow-hidden transition-all duration-700 hover:bg-white/[0.08]">
          <div class="relative z-10 flex flex-col h-full justify-between">
            <span class="text-[10px] uppercase tracking-[0.4em] text-white/30 group-hover:text-white/50 transition-colors duration-500">Social Connections</span>
            <div class="mt-8">
              <span class="text-7xl font-bold tracking-tighter group-hover:scale-110 block origin-left transition-transform duration-700" style="font-family: 'Space Grotesk', sans-serif;">
                {{ stats.socialLinks || 0 }}
              </span>
            </div>
            <div class="mt-8 flex items-center gap-2 text-[10px] uppercase tracking-widest text-white/20 group-hover:text-white transition-colors duration-500">
              Update Links <span class="group-hover:translate-x-2 transition-transform duration-500">→</span>
            </div>
          </div>
          <div class="absolute -right-8 -bottom-8 w-32 h-32 bg-white/[0.02] rounded-full blur-3xl group-hover:bg-white/[0.05] transition-all duration-700"></div>
        </NuxtLink>
      </div>

      <!-- Secondary Actions -->
      <div class="grid grid-cols-1 md:grid-cols-2 gap-6 pt-8">
        <NuxtLink to="/admin/about" class="group p-8 border border-white/5 hover:border-white/20 transition-all duration-500 rounded-sm">
          <div class="flex items-center justify-between">
            <div class="space-y-1">
              <h4 class="text-base font-bold tracking-tight">Biography & Narrative</h4>
              <p class="text-white/30 text-xs">Update your professional story and timeline.</p>
            </div>
            <span class="text-white/10 group-hover:text-white transition-colors duration-500">→</span>
          </div>
        </NuxtLink>

        <NuxtLink to="/admin/content" class="group p-8 border border-white/5 hover:border-white/20 transition-all duration-500 rounded-sm">
          <div class="flex items-center justify-between">
            <div class="space-y-1">
              <h4 class="text-base font-bold tracking-tight">Editorial Content</h4>
              <p class="text-white/30 text-xs">Manage headlines and home page narrative.</p>
            </div>
            <span class="text-white/10 group-hover:text-white transition-colors duration-500">→</span>
          </div>
        </NuxtLink>
      </div>
    </div>
  </NuxtLayout>
</template>

<script setup>
definePageMeta({
  middleware: 'admin',
  layout: false
})

const supabase = useSupabaseClient()
const user = useSupabaseUser()

const stats = ref({
  projects: 0,
  featured: 0,
  socialLinks: 0
})

const fetchStats = async () => {
  const { count: projectCount } = await supabase
    .from('projects')
    .select('*', { count: 'exact', head: true })

  const { count: featuredCount } = await supabase
    .from('projects')
    .select('*', { count: 'exact', head: true })
    .eq('featured', true)

  const { count: socialLinksCount } = await supabase
    .from('social_links')
    .select('*', { count: 'exact', head: true })

  stats.value.projects = projectCount || 0
  stats.value.featured = featuredCount || 0
  stats.value.socialLinks = socialLinksCount || 0
}

onMounted(() => {
  fetchStats()
})
</script>

<style scoped>
.animate-fade-in {
  animation: fadeIn 1s cubic-bezier(0.16, 1, 0.3, 1) forwards;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(20px); }
  to { opacity: 1; transform: translateY(0); }
}
</style>

