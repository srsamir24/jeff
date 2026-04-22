<template>
  <div class="work-page">
    <!-- Hero Section -->
    <section class="section-padding relative overflow-hidden flex flex-col justify-center min-h-[50vh]">
      <div class="container mx-auto relative z-10">
        <div class="max-w-4xl">
          <p class="text-overline mb-6">Case Studies</p>
          <h1 class="text-5xl md:text-8xl mb-8 leading-[0.9] lg:leading-[0.85]">
            Archive of <br/> 
            <span class="opacity-40">Selected work.</span>
          </h1>
          <p class="text-xl md:text-2xl opacity-60 max-w-2xl leading-relaxed">
            A curated selection of projects focusing on branding, 
            digital experiences, and experimental design.
          </p>
        </div>
      </div>
      
      <!-- Background Accents -->
      <div class="absolute -top-20 -right-20 w-[500px] h-[500px] bg-[var(--color-neon-teal)] opacity-[0.02] blur-[120px] rounded-full"></div>
    </section>

    <!-- Projects Grid -->
    <section class="section-padding pt-0 min-h-[40vh]">
      <div class="container mx-auto">
        <!-- Loading State -->
        <div v-if="loading" class="grid grid-cols-1 md:grid-cols-2 gap-x-12 gap-y-24">
          <div
            v-for="i in 4"
            :key="i"
            class="animate-pulse"
          >
            <div class="aspect-[16/10] bg-[var(--color-charcoal)] dark:bg-white/5 rounded-sm mb-6" />
            <div class="space-y-4">
              <div class="h-8 bg-[var(--color-charcoal)] dark:bg-white/5 rounded w-1/3" />
              <div class="h-4 bg-[var(--color-charcoal)] dark:bg-white/5 rounded w-full opacity-60" />
            </div>
          </div>
        </div>

        <!-- Empty State -->
        <div v-else-if="projects.length === 0" class="py-24 text-center">
          <p class="text-2xl opacity-40 font-light italic">The archive is currently being updated.</p>
        </div>

        <!-- Projects Grid -->
        <div v-else class="grid grid-cols-1 md:grid-cols-2 gap-x-12 gap-y-24 lg:gap-y-32">
          <ProjectCard
            v-for="project in projects"
            :key="project.id"
            :project-id="project.id"
            :title="project.title"
            :description="project.description"
            :image-url="project.image_url"
            :tags="project.tags"
          />
        </div>
      </div>
    </section>

    <!-- CTA Section -->
    <section class="section-padding border-t border-white/5">
      <div class="container mx-auto">
        <div class="max-w-4xl">
          <h2 class="text-4xl md:text-6xl mb-12 leading-tight">
            Interested in starting <br/>
            a conversation?
          </h2>
          <div class="flex flex-wrap gap-8 items-center">
            <AppButton to="/contact" size="lg">
              Get In Touch
              <template #iconRight>
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="group-hover:translate-x-1 transition-transform">
                  <line x1="5" y1="12" x2="19" y2="12"></line>
                  <polyline points="12 5 19 12 12 19"></polyline>
                </svg>
              </template>
            </AppButton>
            
            <NuxtLink to="/" class="text-overline hover:opacity-100 transition-opacity">Back to Home</NuxtLink>
          </div>
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
    const { data, error } = await supabase
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
