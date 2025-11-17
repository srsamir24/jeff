<template>
  <div class="min-h-screen bg-gray-50">
    <!-- Admin Header -->
    <header class="bg-portfolio-white border-b border-gray-200 sticky top-0 z-50">
      <div class="container mx-auto px-6 py-4">
        <div class="flex items-center space-x-4">
          <NuxtLink to="/admin" class="text-gray-500 hover:text-blue-purple">
            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"></path>
            </svg>
          </NuxtLink>
          <h1 class="text-2xl font-bold text-gray-900">Featured Projects</h1>
          <span class="text-sm text-gray-500">(Select up to 4 for homepage)</span>
        </div>
      </div>
    </header>

    <!-- Main Content -->
    <main class="container mx-auto px-6 py-8">
      <!-- Loading State -->
      <div v-if="loading" class="text-center py-12">
        <div class="inline-block animate-spin rounded-full h-12 w-12 border-b-2 border-blue-purple"></div>
        <p class="text-gray-500 mt-4">Loading projects...</p>
      </div>

      <!-- Instructions -->
      <div v-else class="mb-8 bg-light-blue/10 border border-light-blue/30 rounded-2xl p-6">
        <h2 class="text-lg font-bold text-gray-900 mb-2">How it works</h2>
        <p class="text-gray-700">
          Toggle projects to mark them as featured. The first 4 featured projects will appear on the homepage in the "My Work" section.
          Drag and drop to reorder them.
        </p>
        <p class="text-sm text-gray-600 mt-2">
          Currently featured: <span class="font-bold text-blue-purple">{{ featuredCount }}</span> / 4
        </p>
      </div>

      <!-- Projects List -->
      <div v-if="!loading" class="space-y-4">
        <!-- Featured Projects -->
        <div v-if="featuredProjects.length > 0" class="mb-8">
          <h3 class="text-xl font-bold text-gray-900 mb-4">Featured Projects (Drag to reorder)</h3>
          <div class="space-y-3">
            <div
              v-for="(project, index) in featuredProjects"
              :key="project.id"
              class="group bg-portfolio-white rounded-2xl p-6 shadow-md hover:shadow-xl transition-all border-2 border-bright-pink/30"
            >
              <div class="flex items-center gap-4">
                <!-- Drag Handle -->
                <div class="cursor-move text-gray-400 hover:text-blue-purple">
                  <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 8h16M4 16h16"></path>
                  </svg>
                </div>

                <!-- Order Badge -->
                <div class="w-10 h-10 rounded-full bg-bright-pink flex items-center justify-center text-portfolio-white font-bold">
                  {{ index + 1 }}
                </div>

                <!-- Project Image -->
                <div class="w-20 h-20 rounded-lg overflow-hidden bg-gray-100 flex-shrink-0">
                  <img v-if="project.image_url" :src="project.image_url" :alt="project.title" class="w-full h-full object-cover" />
                  <div v-else class="w-full h-full flex items-center justify-center">
                    <svg class="w-8 h-8 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                    </svg>
                  </div>
                </div>

                <!-- Project Info -->
                <div class="flex-1">
                  <h4 class="text-lg font-bold text-gray-900">{{ project.title }}</h4>
                  <p class="text-sm text-gray-600 line-clamp-1">{{ project.description }}</p>
                </div>

                <!-- Actions -->
                <div class="flex items-center gap-2">
                  <!-- Move Up -->
                  <button
                    v-if="index > 0"
                    @click="moveUp(index)"
                    class="p-2 text-light-blue hover:bg-light-blue/10 rounded-lg transition-all"
                    title="Move up"
                  >
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 15l7-7 7 7"></path>
                    </svg>
                  </button>

                  <!-- Move Down -->
                  <button
                    v-if="index < featuredProjects.length - 1"
                    @click="moveDown(index)"
                    class="p-2 text-light-blue hover:bg-light-blue/10 rounded-lg transition-all"
                    title="Move down"
                  >
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path>
                    </svg>
                  </button>

                  <!-- Remove from Featured -->
                  <button
                    @click="toggleFeatured(project)"
                    class="px-4 py-2 bg-bright-pink/10 text-bright-pink rounded-lg text-sm font-medium hover:bg-bright-pink/20 transition-all"
                  >
                    Remove
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Other Projects -->
        <div>
          <h3 class="text-xl font-bold text-gray-900 mb-4">
            {{ featuredProjects.length > 0 ? 'Other Projects' : 'All Projects' }}
          </h3>
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div
              v-for="project in nonFeaturedProjects"
              :key="project.id"
              class="bg-portfolio-white rounded-2xl p-6 shadow-md hover:shadow-lg transition-all border border-gray-200"
            >
              <div class="flex items-center gap-4">
                <!-- Project Image -->
                <div class="w-16 h-16 rounded-lg overflow-hidden bg-gray-100 flex-shrink-0">
                  <img v-if="project.image_url" :src="project.image_url" :alt="project.title" class="w-full h-full object-cover" />
                  <div v-else class="w-full h-full flex items-center justify-center">
                    <svg class="w-6 h-6 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                    </svg>
                  </div>
                </div>

                <!-- Project Info -->
                <div class="flex-1">
                  <h4 class="font-bold text-gray-900">{{ project.title }}</h4>
                  <p class="text-sm text-gray-600 line-clamp-1">{{ project.description }}</p>
                </div>

                <!-- Add to Featured -->
                <button
                  @click="toggleFeatured(project)"
                  :disabled="featuredCount >= 4"
                  class="px-4 py-2 bg-light-green/10 text-light-green rounded-lg text-sm font-medium hover:bg-light-green/20 transition-all disabled:opacity-50 disabled:cursor-not-allowed"
                >
                  Add
                </button>
              </div>
            </div>
          </div>

          <!-- Empty State -->
          <div v-if="nonFeaturedProjects.length === 0" class="text-center py-12 bg-portfolio-white rounded-2xl">
            <p class="text-gray-500">All projects are featured!</p>
          </div>
        </div>
      </div>
    </main>
  </div>
</template>

<script setup>
definePageMeta({
  middleware: 'admin',
  layout: false
})

const supabase = useSupabaseClient()

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
    alert('You can only feature up to 4 projects. Remove one first.')
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
  } catch (error) {
    console.error('Error updating featured status:', error)
    alert('Error updating project. Please try again.')
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
    alert('Error reordering projects. Please try again.')
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
    alert('Error reordering projects. Please try again.')
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
