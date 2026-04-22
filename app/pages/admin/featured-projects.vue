<template>
  <NuxtLayout name="admin">
    <div class="max-w-7xl mx-auto">
      <!-- Header Area -->
      <div class="flex flex-col md:flex-row md:items-center justify-between gap-6 mb-12">
        <div>
          <h1 class="text-4xl font-bold tracking-tight text-white mb-2 font-display">Featured Projects</h1>
          <p class="text-white/40 font-medium">Curate the spotlight on your homepage (Max 4)</p>
        </div>
        <div class="flex items-center gap-3 px-6 py-3 bg-white/5 border border-white/10 rounded-full">
          <span class="text-xs font-bold text-white/40 uppercase tracking-widest">Active Slots</span>
          <div class="flex gap-1.5">
            <div v-for="i in 4" :key="i" 
              class="w-3 h-3 rounded-full transition-all duration-500"
              :class="i <= featuredCount ? 'bg-bright-pink shadow-[0_0_10px_rgba(255,51,102,0.5)]' : 'bg-white/10'">
            </div>
          </div>
        </div>
      </div>

      <!-- Loading State -->
      <div v-if="loading" class="flex flex-col items-center justify-center py-24">
        <div class="w-12 h-12 border-2 border-white/10 border-t-white rounded-full animate-spin mb-4"></div>
        <p class="text-white/40 font-medium animate-pulse">Organizing projects...</p>
      </div>

      <div v-else class="space-y-12">
        <!-- Featured Projects (Drag/Reorder Area) -->
        <section v-if="featuredProjects.length > 0">
          <h2 class="text-xs font-bold text-white/40 uppercase tracking-[0.2em] mb-6 ml-1">Showcase Order</h2>
          <div class="space-y-4">
            <div v-for="(project, index) in featuredProjects" :key="project.id"
              class="group relative bg-white/[0.03] border border-white/5 rounded-[2rem] p-6 hover:bg-white/[0.05] transition-all duration-500">
              <div class="flex items-center gap-6">
                <!-- Index Badge -->
                <div class="hidden sm:flex w-12 h-12 rounded-full bg-white/5 items-center justify-center text-white font-bold font-display text-xl group-hover:bg-bright-pink group-hover:text-white transition-all duration-500">
                  {{ index + 1 }}
                </div>

                <!-- Project Image -->
                <div class="w-24 h-24 rounded-2xl overflow-hidden bg-white/5 flex-shrink-0 border border-white/10">
                  <img v-if="project.image_url" :src="project.image_url" :alt="project.title"
                    class="w-full h-full object-cover grayscale opacity-60 group-hover:grayscale-0 group-hover:opacity-100 transition-all duration-700" />
                  <div v-else class="w-full h-full flex items-center justify-center opacity-20">
                    <svg class="w-8 h-8 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                        d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                    </svg>
                  </div>
                </div>

                <!-- Project Info -->
                <div class="flex-1 min-w-0">
                  <h3 class="text-xl font-bold text-white mb-1 font-display truncate">{{ project.title }}</h3>
                  <p class="text-white/40 text-sm line-clamp-1 truncate">{{ project.description }}</p>
                </div>

                <!-- Reorder Controls -->
                <div class="flex flex-col sm:flex-row items-center gap-2">
                  <div class="flex gap-1">
                    <button @click="moveUp(index)" :disabled="index === 0"
                      class="p-2.5 text-white/40 hover:text-white hover:bg-white/10 rounded-xl transition-all disabled:hidden" title="Move up">
                      <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M5 15l7-7 7 7"></path>
                      </svg>
                    </button>
                    <button @click="moveDown(index)" :disabled="index === featuredProjects.length - 1"
                      class="p-2.5 text-white/40 hover:text-white hover:bg-white/10 rounded-xl transition-all disabled:hidden" title="Move down">
                      <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M19 9l-7 7-7-7"></path>
                      </svg>
                    </button>
                  </div>
                  <button @click="toggleFeatured(project)"
                    class="px-6 py-3 bg-bright-pink/10 text-bright-pink rounded-full text-sm font-bold hover:bg-bright-pink hover:text-white transition-all duration-300">
                    Remove
                  </button>
                </div>
              </div>
            </div>
          </div>
        </section>

        <!-- Pool of Available Projects -->
        <section>
          <div class="flex items-center justify-between mb-6">
            <h2 class="text-xs font-bold text-white/40 uppercase tracking-[0.2em] ml-1">Available Projects</h2>
            <p v-if="featuredCount >= 4" class="text-bright-pink text-xs font-bold uppercase tracking-widest">Slots Full</p>
          </div>
          
          <div class="grid grid-cols-1 lg:grid-cols-2 gap-4">
            <div v-for="project in nonFeaturedProjects" :key="project.id"
              class="group bg-white/[0.02] border border-white/5 rounded-3xl p-5 hover:bg-white/[0.04] transition-all duration-500">
              <div class="flex items-center gap-5">
                <!-- Project Image (Small) -->
                <div class="w-16 h-16 rounded-xl overflow-hidden bg-white/5 flex-shrink-0">
                  <img v-if="project.image_url" :src="project.image_url" :alt="project.title"
                    class="w-full h-full object-cover grayscale opacity-40 group-hover:grayscale-0 group-hover:opacity-80 transition-all duration-500" />
                  <div v-else class="w-full h-full flex items-center justify-center opacity-10">
                    <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                        d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                    </svg>
                  </div>
                </div>

                <!-- Info -->
                <div class="flex-1 min-w-0">
                  <h4 class="font-bold text-white/80 group-hover:text-white transition-all font-display truncate">{{ project.title }}</h4>
                  <p class="text-white/20 text-xs truncate">{{ project.description }}</p>
                </div>

                <!-- Add Button -->
                <button @click="toggleFeatured(project)" :disabled="featuredCount >= 4"
                  class="p-2 rounded-xl bg-white/5 text-white/40 hover:bg-white hover:text-black transition-all duration-300 disabled:opacity-0 disabled:pointer-events-none">
                  <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M12 4v16m8-8H4"></path>
                  </svg>
                </button>
              </div>
            </div>
          </div>

          <!-- Empty State -->
          <div v-if="nonFeaturedProjects.length === 0" 
            class="flex flex-col items-center justify-center py-20 bg-white/[0.01] border border-dashed border-white/5 rounded-3xl">
            <p class="text-white/20 font-bold tracking-widest uppercase text-xs">All projects are currently showcased</p>
          </div>
        </section>
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
const toast = useAppToast()

// State
const projects = ref([])
const loading = ref(true)

// Computed
const featuredProjects = computed(() => {
  return projects.value
    .filter(p => p.featured)
    .sort((a, b) => (a.featured_order || 0) - (b.featured_order || 0))
})

const nonFeaturedProjects = computed(() => {
  return projects.value
    .filter(p => !p.featured)
    .sort((a, b) => new Date(b.created_at) - new Date(a.created_at))
})

const featuredCount = computed(() => featuredProjects.value.length)

// Fetch projects
const fetchProjects = async () => {
  loading.value = true
  const { data, error } = await supabase
    .from('projects')
    .select('*')
    .order('created_at', { ascending: false })

  if (error) {
    console.error('Error fetching projects:', error)
    toast.error('Failed to load projects')
  } else {
    projects.value = data || []
  }
  loading.value = false
}

// Toggle featured status
const toggleFeatured = async (project) => {
  const newFeaturedStatus = !project.featured

  // If adding to featured, check limit
  if (newFeaturedStatus && featuredCount.value >= 4) {
    toast.warning('You can only feature up to 4 projects. Remove one first.')
    return
  }

  try {
    let featured_order = null

    if (newFeaturedStatus) {
      // Adding to featured - set order to end of list
      featured_order = featuredCount.value
    }

    const { error } = await supabase
      .from('projects')
      .update({
        featured: newFeaturedStatus,
        featured_order: featured_order
      })
      .eq('id', project.id)

    if (error) throw error

    // If removing from featured, reorder remaining
    if (!newFeaturedStatus) {
      await reorderFeatured()
    }

    await fetchProjects()
    toast.success(newFeaturedStatus ? 'Project featured' : 'Project removed from featured')
  } catch (error) {
    console.error('Error updating featured status:', error)
    toast.error('Error updating project. Please try again.')
  }
}

// Move project up in featured list
const moveUp = async (index) => {
  if (index === 0) return

  const currentProject = featuredProjects.value[index]
  const previousProject = featuredProjects.value[index - 1]

  try {
    // Swap orders
    await supabase
      .from('projects')
      .update({ featured_order: index - 1 })
      .eq('id', currentProject.id)

    await supabase
      .from('projects')
      .update({ featured_order: index })
      .eq('id', previousProject.id)

    await fetchProjects()
  } catch (error) {
    console.error('Error reordering:', error)
    toast.error('Error reordering projects. Please try again.')
  }
}

// Move project down in featured list
const moveDown = async (index) => {
  if (index === featuredProjects.value.length - 1) return

  const currentProject = featuredProjects.value[index]
  const nextProject = featuredProjects.value[index + 1]

  try {
    // Swap orders
    await supabase
      .from('projects')
      .update({ featured_order: index + 1 })
      .eq('id', currentProject.id)

    await supabase
      .from('projects')
      .update({ featured_order: index })
      .eq('id', nextProject.id)

    await fetchProjects()
  } catch (error) {
    console.error('Error reordering:', error)
    toast.error('Error reordering projects. Please try again.')
  }
}

// Reorder featured projects after removal
const reorderFeatured = async () => {
  const featured = featuredProjects.value

  for (let i = 0; i < featured.length; i++) {
    await supabase
      .from('projects')
      .update({ featured_order: i })
      .eq('id', featured[i].id)
  }
}

// Load projects on mount
onMounted(() => {
  fetchProjects()
})
</script>
