<template>
  <div>
    <!-- Hero (Preserved per User Request) -->
    <Hero :subtitle="heroSubtitle" />

    <!-- Selected Work Section -->
    <section class="section-padding bg-paper dark:bg-charcoal transition-colors duration-300">
      <div class="max-w-7xl mx-auto">
        <div class="flex flex-col md:flex-row md:items-end justify-between mb-20 gap-8">
          <div>
            <p class="text-overline mb-4">
              Portfolio
            </p>
            <h2 class="text-5xl md:text-7xl font-bold tracking-tighter">
              Selected Work
            </h2>
          </div>
          <NuxtLink
            to="/work"
            class="group flex items-center gap-3 text-sm font-semibold uppercase tracking-widest opacity-60 hover:opacity-100 transition-all"
          >
            Explore Projects
            <UIcon name="lucide:arrow-right" class="w-5 h-5 transition-transform group-hover:translate-x-1" />
          </NuxtLink>
        </div>

        <!-- Projects Grid -->
        <div v-if="loadingProjects" class="grid grid-cols-1 md:grid-cols-2 gap-12">
          <div
            v-for="i in 2"
            :key="i"
            class="aspect-[16/10] bg-charcoal/5 dark:bg-paper/5 animate-pulse"
          />
        </div>

        <div v-else-if="featuredProjects.length > 0" class="space-y-24">
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

        <div v-else class="text-center py-20 opacity-30">
          <UIcon name="lucide:folder-open" class="w-16 h-16 mx-auto mb-6" />
          <p class="font-display">No featured projects to display.</p>
        </div>
      </div>
    </section>

    <!-- More Projects - Horizontal Scroll -->
    <MoreProjects />

    <!-- Material Thinking - Interactive 3D Cylinder -->
    <MaterialThinking />

    <!-- About Segment (Mini Philosophy) -->
    <section class="section-padding bg-background-dark text-paper overflow-hidden relative" data-theme="dark">
      <div class="max-w-7xl mx-auto relative z-10">
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-24 items-center">
          <div class="space-y-12">
            <p class="text-overline opacity-40">The Vision</p>
            <h2 class="text-5xl md:text-7xl font-bold tracking-tighter leading-[0.9]">
              Design is not decoration. It is clarity made visible.
            </h2>
            <p class="font-body text-lg md:text-xl opacity-60 leading-relaxed max-w-xl">
              I'm Anna Ericyan, a graphic designer dedicated to crafting visual stories that bridge the gap between brand and behavior. I believe in aesthetics driven by purpose.
            </p>
            
            <div class="flex flex-wrap gap-x-8 gap-y-4 pt-4">
              <div v-for="skill in ['Branding', 'Illustration', 'Strategy', 'Packaging']" :key="skill" class="text-overline opacity-60">
                · {{ skill }}
              </div>
            </div>

            <NuxtLink to="/about">
              <AppButton variant="ghost" size="lg" class="!text-paper hover:!bg-paper/10 mt-8">
                Read Philosophy
                <template #iconRight>
                  <UIcon name="lucide:arrow-right" class="w-4 h-4" />
                </template>
              </AppButton>
            </NuxtLink>
          </div>

          <!-- Interaction Placeholder for Premium Feel -->
          <div class="relative aspect-square md:aspect-auto md:h-[600px] bg-paper/5 rounded-3xl flex items-center justify-center group overflow-hidden">
             <div class="absolute inset-0 bg-gradient-to-tr from-neon-teal/10 to-electric-violet/10 opacity-50" />
             <div class="relative z-10 text-center space-y-4">
                <UIcon name="lucide:mouse-pointer-2" class="w-12 h-12 opacity-20 group-hover:scale-125 transition-transform duration-700" />
                <p class="text-overline opacity-20">Creative Studio</p>
             </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Contact Segment -->
    <section class="section-padding bg-paper transition-colors duration-300">
      <div class="max-w-7xl mx-auto text-center">
        <p class="text-overline mb-8">Get in Touch</p>
        <h2 class="text-6xl md:text-8xl font-bold tracking-tighter mb-12">
          Let's create<br/>something amazing.
        </h2>
        <NuxtLink to="/contact">
           <div class="inline-flex items-center gap-6 group cursor-pointer">
              <div class="w-20 h-20 md:w-32 md:h-32 rounded-full border border-charcoal/10 flex items-center justify-center group-hover:bg-charcoal group-hover:text-paper transition-all duration-700 cubic-bezier(0.16, 1, 0.3, 1)">
                 <UIcon name="lucide:arrow-up-right" class="w-8 h-8 md:w-12 md:h-12" />
              </div>
              <span class="text-2xl md:text-3xl font-display font-semibold tracking-tighter">Start a project</span>
           </div>
        </NuxtLink>
      </div>
    </section>
  </div>
</template>

<script setup>
const supabase = useSupabaseClient()

const heroSubtitle = ref('Transforming ideas into stunning visual experiences with creativity and precision')
const featuredProjects = ref([])
const loadingProjects = ref(true)

const fetchFeaturedProjects = async () => {
  try {
    const { data, error } = await supabase
      .from('projects')
      .select('*')
      .eq('featured', true)
      .order('featured_order', { ascending: true })
      .limit(2)

    if (!error && data) featuredProjects.value = data
  } catch (err) {
    console.error('Error fetching featured projects:', err)
  } finally {
    loadingProjects.value = false
  }
}

onMounted(() => {
  fetchFeaturedProjects()
})
</script>
