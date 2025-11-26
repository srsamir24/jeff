<template>
  <Hero :subtitle="heroSubtitle" />

  <!-- Featured Work Section -->
  <section class="py-20 bg-portfolio-white">
    <div class="container mx-auto px-6">
      <div class="text-center mb-12">
        <h2 class="text-4xl md:text-5xl font-bold text-gray-900 mb-4">
          Featured Work
        </h2>
        <p class="text-xl text-gray-600 max-w-2xl mx-auto">
          A curated selection of my recent design projects that showcase creativity and attention to detail
        </p>
      </div>

      <!-- Loading State -->
      <div v-if="loadingProjects" class="text-center py-12">
        <div class="inline-block animate-spin rounded-full h-12 w-12 border-b-2 border-blue-purple"></div>
      </div>

      <!-- Projects Grid -->
      <div v-else-if="featuredProjects.length > 0"
        class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-2 xl:grid-cols-4 gap-8">
        <ProjectCard
          v-for="project in featuredProjects"
          :key="project.id"
          :project-id="project.id"
          :title="project.title"
          :description="project.description"
          :image-url="project.image_url"
          :tags="project.tags"
        />
      </div>

      <!-- Empty State -->
      <div v-else class="text-center py-12">
        <p class="text-gray-500">No featured projects to display yet.</p>
      </div>

      <div class="text-center mt-12">
        <AppButton to="/work" variant="primary" size="lg">
          View All Projects
          <template #iconRight>
            <svg class="w-5 h-5 group-hover:translate-x-1 transition-transform" fill="none" stroke="currentColor"
              viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 8l4 4m0 0l-4 4m4-4H3"></path>
            </svg>
          </template>
        </AppButton>
      </div>
    </div>
  </section>

  <!-- Services Section -->
  <section v-if="servicesContent.services && servicesContent.services.length > 0" class="py-20 bg-linear-to-b from-light-blue/5 to-portfolio-white">
    <div class="container mx-auto px-6">
      <div class="text-center mb-12">
        <h2 class="text-4xl md:text-5xl font-bold text-gray-900 mb-4">
          {{ servicesContent.title || 'What I Do' }}
        </h2>
        <p class="text-xl text-gray-600 max-w-2xl mx-auto">
          {{ servicesContent.subtitle || 'Specialized design services tailored to bring your vision to life' }}
        </p>
      </div>

      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        <ServiceCard
          v-for="(service, index) in servicesContent.services"
          :key="index"
          :title="service.title"
          :description="service.description"
          :icon-bg-class="service.iconBgClass"
          :hover-border-class="service.hoverBorderClass"
          :hover-text-class="service.hoverTextClass"
        >
          <template #icon>
            <svg class="w-8 h-8 text-portfolio-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" :d="getServiceIcon(index)" />
            </svg>
          </template>
        </ServiceCard>
      </div>
    </div>
  </section>

  <!-- Stats Section -->
  <section v-if="statsContent.stats && statsContent.stats.length > 0" class="py-16 bg-portfolio-white">
    <div class="container mx-auto px-6">
      <div class="grid grid-cols-2 md:grid-cols-4 gap-8">
        <StatCard
          v-for="(stat, index) in statsContent.stats"
          :key="index"
          :value="stat.value"
          :label="stat.label"
          :color-class="stat.colorClass"
        />
      </div>
    </div>
  </section>
</template>

<script setup>
const supabase = useSupabaseClient()

// Hero content
const heroSubtitle = ref('Transforming ideas into stunning visual experiences with creativity and precision')

// Featured projects
const featuredProjects = ref([])
const loadingProjects = ref(true)

// Services content
const servicesContent = ref({ title: '', subtitle: '', services: [] })

// Stats content
const statsContent = ref({ stats: [] })

// Fetch flags
const contentFetched = ref(false)
const projectsFetched = ref(false)

// Service icons (matching the original design)
const serviceIcons = [
  "M7 21a4 4 0 01-4-4V5a2 2 0 012-2h4a2 2 0 012 2v12a4 4 0 01-4 4zm0 0h12a2 2 0 002-2v-4a2 2 0 00-2-2h-2.343M11 7.343l1.657-1.657a2 2 0 012.828 0l2.829 2.829a2 2 0 010 2.828l-8.486 8.485M7 17h.01",
  "M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z",
  "M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z",
  "M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4"
]

const getServiceIcon = (index) => {
  return serviceIcons[index % serviceIcons.length]
}

// Fetch all page content (hero, services, stats)
const fetchPageContent = async () => {
  if (contentFetched.value) return

  try {
    const { data, error } = await supabase
      .from('page_content')
      .select('*')
      .in('section_key', ['hero', 'services', 'stats'])

    if (!error && data) {
      data.forEach(section => {
        if (section.section_key === 'hero' && section.content?.subtitle) {
          heroSubtitle.value = section.content.subtitle
        } else if (section.section_key === 'services' && section.content) {
          servicesContent.value = section.content
        } else if (section.section_key === 'stats' && section.content) {
          statsContent.value = section.content
        }
      })
    }

    contentFetched.value = true
  } catch (err) {
    console.error('Error fetching page content:', err)
    contentFetched.value = true
  }
}

// Fetch featured projects
const fetchFeaturedProjects = async () => {
  if (projectsFetched.value) {
    loadingProjects.value = false
    return
  }

  loadingProjects.value = true

  try {
    const { data, error } = await supabase
      .from('projects')
      .select('*')
      .eq('featured', true)
      .order('featured_order', { ascending: true })
      .limit(4)

    if (!error && data) {
      featuredProjects.value = data
    }

    projectsFetched.value = true
  } catch (err) {
    console.error('Error fetching featured projects:', err)
    projectsFetched.value = true
  } finally {
    loadingProjects.value = false
  }
}

onMounted(() => {
  fetchPageContent()
  fetchFeaturedProjects()
})
</script>
