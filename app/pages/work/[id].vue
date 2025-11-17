<template>
  <div class="min-h-screen bg-portfolio-white">
    <!-- Loading State -->
    <div v-if="loading" class="min-h-screen flex items-center justify-center">
      <div class="text-center">
        <div class="relative inline-flex items-center justify-center">
          <div class="absolute w-20 h-20 bg-bright-pink/20 rounded-full animate-ping"></div>
          <div class="relative w-20 h-20 bg-linear-to-br from-bright-pink to-lighter-pink rounded-full animate-spin border-4 border-portfolio-white shadow-lg">
            <div class="absolute inset-2 bg-portfolio-white rounded-full"></div>
          </div>
        </div>
        <p class="text-gray-600 mt-6 text-lg font-medium">Loading project...</p>
      </div>
    </div>

    <!-- Project Not Found -->
    <div v-else-if="!project" class="min-h-screen flex items-center justify-center">
      <div class="text-center">
        <div class="w-32 h-32 mx-auto bg-light-blue/20 rounded-3xl flex items-center justify-center mb-8">
          <svg class="w-16 h-16 text-blue-purple" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.172 16.172a4 4 0 015.656 0M9 10h.01M15 10h.01M12 12h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
          </svg>
        </div>
        <h1 class="text-4xl font-bold text-gray-900 mb-4">Project Not Found</h1>
        <p class="text-xl text-gray-600 mb-8">Sorry, this project doesn't exist or has been removed.</p>
        <AppButton to="/work" variant="secondary" size="lg">
          Back to Projects
        </AppButton>
      </div>
    </div>

    <!-- Project Details -->
    <div v-else>
      <!-- Hero Section -->
      <section class="relative overflow-hidden bg-gray-50 pt-32 pb-16">
        <!-- Back Button -->
        <div class="container mx-auto px-6 mb-8">
          <NuxtLink to="/work" class="inline-flex items-center gap-2 text-blue-purple hover:text-bright-pink transition-colors group">
            <svg class="w-5 h-5 group-hover:-translate-x-1 transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"></path>
            </svg>
            <span class="font-semibold">Back to Projects</span>
          </NuxtLink>
        </div>

        <div class="container mx-auto px-6 relative z-10">
          <div class="max-w-4xl mx-auto text-center">
            <h1 class="text-4xl md:text-5xl lg:text-6xl font-bold mb-6">
              <span class="bg-clip-text text-transparent bg-linear-to-r from-bright-pink via-blue-purple to-light-blue animate-gradient">
                {{ project.title }}
              </span>
            </h1>
            <p class="text-xl md:text-2xl text-gray-700 leading-relaxed font-medium mb-8">
              {{ project.description }}
            </p>

            <!-- Tags -->
            <div class="flex flex-wrap justify-center gap-3">
              <span
                v-for="tag in project.tags"
                :key="tag.label"
                :class="['px-4 py-2 text-sm rounded-full font-semibold shadow-md', tag.class]"
              >
                {{ tag.label }}
              </span>
            </div>
          </div>
        </div>
      </section>

      <!-- Project Image -->
      <section class="py-16 bg-portfolio-white">
        <div class="container mx-auto px-6">
          <div class="max-w-6xl mx-auto">
            <div class="relative aspect-video rounded-3xl overflow-hidden shadow-2xl">
              <img
                v-if="project.image_url"
                :src="project.image_url"
                :alt="project.title"
                class="w-full h-full object-cover"
              />
              <div
                v-else
                :class="['w-full h-full', project.gradient_class || 'bg-linear-to-br from-blue-purple to-light-blue']"
              ></div>
            </div>
          </div>
        </div>
      </section>

      <!-- Project Details Section -->
      <section class="py-16 bg-gray-50">
        <div class="container mx-auto px-6">
          <div class="max-w-4xl mx-auto">
            <div class="bg-portfolio-white rounded-3xl p-8 md:p-12 shadow-lg">
              <h2 class="text-3xl font-bold text-gray-900 mb-6">
                <span class="bg-clip-text text-transparent bg-linear-to-r from-bright-pink to-blue-purple">
                  Project Details
                </span>
              </h2>

              <div class="prose prose-lg max-w-none">
                <p class="text-gray-700 leading-relaxed text-lg">
                  {{ project.full_description || project.description }}
                </p>

                <!-- Additional project details can go here -->
                <div class="mt-8 grid grid-cols-1 md:grid-cols-2 gap-6">
                  <div v-if="project.client" class="bg-gray-50 rounded-2xl p-6">
                    <h3 class="text-sm font-semibold text-gray-500 uppercase mb-2">Client</h3>
                    <p class="text-xl font-bold text-gray-900">{{ project.client }}</p>
                  </div>

                  <div v-if="project.year" class="bg-gray-50 rounded-2xl p-6">
                    <h3 class="text-sm font-semibold text-gray-500 uppercase mb-2">Year</h3>
                    <p class="text-xl font-bold text-gray-900">{{ project.year }}</p>
                  </div>

                  <div v-if="project.category" class="bg-gray-50 rounded-2xl p-6">
                    <h3 class="text-sm font-semibold text-gray-500 uppercase mb-2">Category</h3>
                    <p class="text-xl font-bold text-gray-900">{{ project.category }}</p>
                  </div>

                  <div v-if="project.role" class="bg-gray-50 rounded-2xl p-6">
                    <h3 class="text-sm font-semibold text-gray-500 uppercase mb-2">Role</h3>
                    <p class="text-xl font-bold text-gray-900">{{ project.role }}</p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- CTA Section -->
      <section class="relative py-24 overflow-hidden bg-gray-900">
        <!-- Gradient overlay -->
        <div class="absolute inset-0 bg-linear-to-br from-blue-purple/90 via-bright-pink/90 to-light-green/90"></div>

        <div class="container mx-auto px-6 text-center relative z-10">
          <h2 class="text-4xl md:text-5xl font-bold text-portfolio-white mb-6">
            Like What You See?
          </h2>
          <p class="text-xl text-portfolio-white/95 mb-10 max-w-2xl mx-auto">
            Let's work together on your next project
          </p>
          <div class="flex flex-col sm:flex-row gap-4 justify-center">
            <AppButton
              to="/contact"
              size="xl"
              class="bg-portfolio-white text-bright-pink hover:bg-portfolio-white/90 hover:shadow-[0_0_50px_rgba(255,255,255,0.5)] shadow-2xl border-0"
            >
              Get In Touch
            </AppButton>
            <AppButton
              to="/work"
              variant="outline"
              size="xl"
              class="bg-portfolio-white/10 backdrop-blur-sm border-portfolio-white text-portfolio-white hover:bg-portfolio-white hover:text-blue-purple"
            >
              View More Projects
            </AppButton>
          </div>
        </div>
      </section>
    </div>
  </div>
</template>

<script setup>
const route = useRoute()
const supabase = useSupabaseClient()

// State
const loading = ref(true)
const project = ref(null)

// Fetch project details
const fetchProject = async () => {
  loading.value = true

  try {
    const { data, error } = await supabase
      .from('projects')
      .select('*')
      .eq('id', route.params.id)
      .eq('published', true)
      .single()

    if (error) throw error
    project.value = data
  } catch (error) {
    console.error('Error fetching project:', error)
    project.value = null
  } finally {
    loading.value = false
  }
}

// SEO
useHead(() => ({
  title: project.value ? `${project.value.title} - Anna Ericyan` : 'Project - Anna Ericyan',
  meta: [
    {
      name: 'description',
      content: project.value?.description || 'View project details'
    }
  ]
}))

onMounted(() => {
  fetchProject()
})
</script>
