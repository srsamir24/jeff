<template>
  <div class="min-h-screen bg-portfolio-white">
    <!-- Hero Section -->
    <section class="relative overflow-hidden bg-gray-50 pt-32 pb-20">
      <!-- Animated background elements -->
      <div
        class="absolute top-0 right-0 w-[500px] h-[500px] bg-bright-pink/15 rounded-full blur-3xl translate-x-1/3 -translate-y-1/3 animate-blob">
      </div>
      <div
        class="absolute bottom-0 left-0 w-[500px] h-[500px] bg-light-blue/15 rounded-full blur-3xl -translate-x-1/3 translate-y-1/3 animate-blob animation-delay-2000">
      </div>
      <div
        class="absolute top-1/2 left-1/2 w-[400px] h-[400px] bg-light-green/10 rounded-full blur-3xl -translate-x-1/2 -translate-y-1/2 animate-blob animation-delay-4000">
      </div>

      <div class="container mx-auto px-6 relative z-10">
        <div class="text-center max-w-3xl mx-auto">
          <h1 class="text-5xl md:text-6xl lg:text-7xl font-bold mb-6">
            <span
              class="bg-clip-text text-transparent bg-linear-to-r from-bright-pink via-blue-purple to-light-blue animate-gradient">
              My Work
            </span>
          </h1>
          <p class="text-xl md:text-2xl text-gray-700 leading-relaxed font-medium">
            A curated collection of my favorite projects, showcasing creativity, passion, and attention to detail.
          </p>
        </div>
      </div>
    </section>

    <!-- Projects Grid -->
    <section class="py-20 bg-portfolio-white">
      <div class="container mx-auto px-6">
        <!-- Loading State -->
        <div v-if="loading" class="text-center py-20">
          <div class="relative inline-flex items-center justify-center">
            <div class="absolute w-16 h-16 bg-bright-pink/20 rounded-full animate-ping"></div>
            <div
              class="relative w-16 h-16 bg-linear-to-br from-bright-pink to-lighter-pink rounded-full animate-spin border-4 border-portfolio-white shadow-lg">
              <div class="absolute inset-2 bg-portfolio-white rounded-full"></div>
            </div>
          </div>
          <p class="text-gray-600 mt-6 text-lg font-medium">Loading amazing projects...</p>
        </div>

        <!-- Empty State -->
        <div v-else-if="projects.length === 0" class="text-center py-20">
          <div class="relative inline-flex items-center justify-center mb-8">
            <div class="absolute w-32 h-32 bg-light-blue/20 rounded-full blur-xl"></div>
            <div
              class="relative w-28 h-28 bg-linear-to-br from-light-blue/30 to-blue-purple/30 rounded-3xl flex items-center justify-center shadow-xl">
              <svg class="w-14 h-14 text-blue-purple" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                  d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10">
                </path>
              </svg>
            </div>
          </div>
          <h3 class="text-3xl font-bold text-gray-900 mb-3">No projects yet</h3>
          <p class="text-xl text-gray-600">Check back soon for amazing work!</p>
        </div>

        <!-- Projects Grid -->
        <div v-else class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8 lg:gap-10">
          <ProjectCard
            v-for="project in projects"
            :key="project.id"
            :project-id="project.id"
            :title="project.title"
            :description="project.description"
            :image-url="project.image_url"
            :gradient-class="project.gradient_class"
            :tags="project.tags"
          />
        </div>
      </div>
    </section>

    <!-- CTA Section -->
    <section class="relative py-24 overflow-hidden bg-gray-900">
      <!-- Gradient overlay -->
      <div class="absolute inset-0 bg-linear-to-br from-blue-purple/90 via-bright-pink/90 to-lighter-pink/90"></div>

      <!-- Animated background patterns -->
      <div
        class="absolute top-0 left-0 w-96 h-96 bg-portfolio-white/10 rounded-full blur-3xl -translate-x-1/2 -translate-y-1/2">
      </div>
      <div
        class="absolute bottom-0 right-0 w-96 h-96 bg-portfolio-white/10 rounded-full blur-3xl translate-x-1/2 translate-y-1/2">
      </div>

      <div class="container mx-auto px-6 text-center relative z-10">
        <h2 class="text-4xl md:text-5xl lg:text-6xl font-bold text-portfolio-white mb-6">
          Ready to Start Your Project?
        </h2>
        <p class="text-xl md:text-2xl text-portfolio-white/95 mb-10 max-w-2xl mx-auto leading-relaxed">
          Let's collaborate and create something beautiful together.
        </p>
        <div class="flex flex-col sm:flex-row gap-4 sm:gap-6 justify-center">
          <AppButton to="/contact" variant="secondary" size="xl">
            Get In Touch
            <template #iconRight>
              <svg class="w-5 h-5 group-hover:translate-x-1 transition-transform" fill="none" stroke="currentColor"
                viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 8l4 4m0 0l-4 4m4-4H3">
                </path>
              </svg>
            </template>
          </AppButton>

          <AppButton to="/" variant="outline" size="xl">
            Back to Home
          </AppButton>
        </div>
      </div>
    </section>
  </div>
</template>

<script setup>
const supabase = useSupabaseClient()

// SEO
useHead({
  title: 'My Work - Anna Ericyan',
  meta: [
    { name: 'description', content: 'Explore my portfolio of graphic design projects, branding work, and creative illustrations.' }
  ]
})

// State
const loading = ref(true)
const projects = ref([])

// Fetch projects
const fetchProjects = async () => {
  loading.value = true
  try {
    const { data, error} = await supabase
      .from('projects')
      .select('*')
      .order('created_at', { ascending: false })

    if (error) throw error
    projects.value = data || []
  } catch (error) {
    console.error('Error fetching projects:', error)
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchProjects()
})
</script>
