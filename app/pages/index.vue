<template>
  <Hero :subtitle="heroContent.subtitle" />

  <!-- Featured Work Section -->
  <section class="py-20 bg-portfolio-white">
    <div class="container mx-auto px-6">
      <div class="text-center mb-12">
        <span class="inline-block px-4 py-1.5 bg-bright-pink/10 text-bright-pink rounded-full text-sm font-medium mb-4">
          Portfolio
        </span>
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
        <ProjectCard v-for="project in featuredProjects" :key="project.id" :project-id="project.id"
          :title="project.title" :description="project.description" :image-url="project.image_url"
          :tags="project.tags" />
      </div>

      <!-- Empty State -->
      <div v-else class="text-center py-12">
        <p class="text-gray-500">No projects to display yet.</p>
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
  <section class="py-20 bg-linear-to-b from-light-blue/5 to-portfolio-white">
    <div class="container mx-auto px-6">
      <div class="text-center mb-12">
        <span class="inline-block px-4 py-1.5 bg-blue-purple/10 text-blue-purple rounded-full text-sm font-medium mb-4">
          Services
        </span>
        <h2 class="text-4xl md:text-5xl font-bold text-gray-900 mb-4">
          What I Do
        </h2>
        <p class="text-xl text-gray-600 max-w-2xl mx-auto">
          Specialized design services tailored to bring your vision to life
        </p>
      </div>

      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        <ServiceCard title="Branding & Identity"
          description="Creating memorable brand identities with logos, color palettes, and comprehensive visual guidelines."
          icon-bg-class="bg-linear-to-br from-bright-pink to-lighter-pink"
          hover-border-class="hover:border-bright-pink/20" hover-text-class="group-hover:text-bright-pink">
          <template #icon>
            <svg class="w-8 h-8 text-portfolio-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                d="M7 21a4 4 0 01-4-4V5a2 2 0 012-2h4a2 2 0 012 2v12a4 4 0 01-4 4zm0 0h12a2 2 0 002-2v-4a2 2 0 00-2-2h-2.343M11 7.343l1.657-1.657a2 2 0 012.828 0l2.829 2.829a2 2 0 010 2.828l-8.486 8.485M7 17h.01" />
            </svg>
          </template>
        </ServiceCard>

        <ServiceCard title="Print Design"
          description="Eye-catching posters, flyers, brochures, and business cards that leave lasting impressions."
          icon-bg-class="bg-linear-to-br from-light-green to-light-green/70"
          hover-border-class="hover:border-light-green/20" hover-text-class="group-hover:text-light-green">
          <template #icon>
            <svg class="w-8 h-8 text-portfolio-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
            </svg>
          </template>
        </ServiceCard>

        <ServiceCard title="Digital Illustrations"
          description="Custom illustrations, social media graphics, and digital artwork that captivate audiences."
          icon-bg-class="bg-linear-to-br from-light-blue to-light-blue/70"
          hover-border-class="hover:border-light-blue/20" hover-text-class="group-hover:text-light-blue">
          <template #icon>
            <svg class="w-8 h-8 text-portfolio-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
            </svg>
          </template>
        </ServiceCard>

        <ServiceCard title="Packaging Design"
          description="Stunning product packaging and label designs that stand out on shelves and online."
          icon-bg-class="bg-linear-to-br from-blue-purple to-blue-purple/70"
          hover-border-class="hover:border-blue-purple/20" hover-text-class="group-hover:text-blue-purple">
          <template #icon>
            <svg class="w-8 h-8 text-portfolio-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4" />
            </svg>
          </template>
        </ServiceCard>
      </div>
    </div>
  </section>

  <!-- Stats Section -->
  <section class="py-16 bg-portfolio-white">
    <div class="container mx-auto px-6">
      <div class="grid grid-cols-2 md:grid-cols-4 gap-8">
        <StatCard v-for="(stat, index) in statsContent.stats" :key="index" :value="stat.value" :label="stat.label"
          :color-class="stat.colorClass" />
      </div>
    </div>
  </section>

  <!-- CTA Section -->
  <section class="relative py-20 bg-linear-to-br from-blue-purple to-blue-purple/90 overflow-hidden">
    <div class="absolute top-0 right-0 w-96 h-96 bg-bright-pink/20 rounded-full blur-3xl"></div>
    <div class="absolute bottom-0 left-0 w-96 h-96 bg-light-green/20 rounded-full blur-3xl"></div>

    <div class="container mx-auto px-6 text-center relative z-10">
      <h2 class="text-4xl md:text-5xl font-bold text-portfolio-white mb-6">
        {{ ctaContent.title || 'Ready to Bring Your Vision to Life?' }}
      </h2>
      <p class="text-xl text-light-blue mb-10 max-w-2xl mx-auto">
        {{ ctaContent.subtitle || "Let's collaborate to create something extraordinary that resonates with your audience and elevates your brand." }}
      </p>
      <div class="flex flex-col sm:flex-row gap-4 sm:gap-6 justify-center">
        <AppButton :to="ctaContent.primaryButtonLink || '/contact'" variant="secondary" size="xl">
          {{ ctaContent.primaryButtonText || 'Start a Project' }}
          <template #iconRight>
            <svg class="w-5 h-5 group-hover:translate-x-1 transition-transform" fill="none" stroke="currentColor"
              viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 8l4 4m0 0l-4 4m4-4H3"></path>
            </svg>
          </template>
        </AppButton>

        <AppButton :to="ctaContent.secondaryButtonLink || '/work'" variant="outline" size="xl">
          {{ ctaContent.secondaryButtonText || 'View Portfolio' }}
        </AppButton>
      </div>
    </div>
  </section>
</template>

<script setup>
const supabase = useSupabaseClient()

// Fetch featured projects (latest 3)
const featuredProjects = ref([])
const loadingProjects = ref(true)

// Page content
const heroContent = ref({
  subtitle: '',
  ctaText: '',
  ctaLink: ''
})

const statsContent = ref({
  stats: []
})

const ctaContent = ref({
  title: '',
  subtitle: '',
  primaryButtonText: '',
  primaryButtonLink: '',
  secondaryButtonText: '',
  secondaryButtonLink: ''
})

const fetchFeaturedProjects = async () => {
  loadingProjects.value = true
  const { data, error } = await supabase
    .from('projects')
    .select('*')
    .eq('featured', true)
    .order('featured_order', { ascending: true })
    .limit(4)

  if (error) {
    console.error('Error fetching projects:', error)
  } else {
    featuredProjects.value = data || []
  }
  loadingProjects.value = false
}

const fetchPageContent = async () => {
  const { data, error } = await supabase
    .from('page_content')
    .select('*')

  if (error) {
    console.error('Error fetching page content:', error)
    return
  }

  // Map content to refs
  data.forEach(section => {
    if (section.section_key === 'hero') {
      heroContent.value = section.content
    } else if (section.section_key === 'stats') {
      statsContent.value = section.content
    } else if (section.section_key === 'cta') {
      ctaContent.value = section.content
    }
  })
}

onMounted(() => {
  fetchFeaturedProjects()
  fetchPageContent()
})
</script>
