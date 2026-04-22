<template>
  <div>
    <!-- About Hero / Philosophy Segment -->
    <section class="section-padding bg-paper dark:bg-charcoal transition-colors duration-300 relative overflow-hidden pt-36">
       <!-- Subtle Background Graphic Placeholder -->
       <div class="absolute inset-0 z-0 opacity-5 pointer-events-none">
          <div class="absolute top-[20%] left-[10%] w-[40vw] h-[40vw] rounded-full border border-charcoal/20" />
          <div class="absolute bottom-[10%] right-[5%] w-[30vw] h-[30vw] rounded-full border border-charcoal/20" />
       </div>

      <div class="max-w-7xl mx-auto relative z-10">
        <div class="flex flex-col lg:flex-row gap-20 items-start">
          <!-- Photo Container -->
          <div class="w-full lg:w-1/3 flex-shrink-0">
            <div class="aspect-[4/5] rounded-3xl overflow-hidden bg-charcoal/5 dark:bg-paper/5 shadow-[0_32px_64px_-16px_rgba(0,0,0,0.1)]">
              <img
                v-if="aboutContent.hero.image"
                :src="aboutContent.hero.image"
                alt="Anna Ericyan"
                class="w-full h-full object-cover transform hover:scale-105 transition-transform duration-1000 cubic-bezier(0.16, 1, 0.3, 1)"
              />
              <div v-else class="w-full h-full flex items-center justify-center opacity-20">
                <UIcon name="lucide:user" class="w-20 h-20" />
              </div>
            </div>
            <p class="text-overline mt-8 opacity-40">Creative Director & Designer</p>
          </div>

          <!-- Text content -->
          <div class="flex-1 space-y-12">
            <h1 class="text-6xl md:text-8xl font-bold tracking-tighter leading-[0.9]">
              Anna Ericyan.
            </h1>
            
            <div class="space-y-8 max-w-2xl">
               <p
                v-for="(paragraph, index) in aboutContent.hero.paragraphs"
                :key="index"
                class="font-body text-lg md:text-xl text-charcoal/70 dark:text-paper/70 leading-relaxed"
              >
                {{ paragraph }}
              </p>
              <p v-if="!aboutContent.hero.paragraphs?.length" class="font-body text-xl opacity-40 italic">
                Crafting visual stories that bridge the gap between brand and behavior.
              </p>
            </div>

            <!-- Focus Areas -->
            <div class="grid grid-cols-2 gap-8 pt-12 border-t border-charcoal/5 dark:border-paper/5">
               <div v-for="area in ['Visual Identity', 'Digital Strategy', 'Packaging Design', 'Art Direction']" :key="area" class="space-y-2">
                  <p class="text-overline opacity-40">Focus</p>
                  <p class="font-display font-semibold text-lg">{{ area }}</p>
               </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Experience / Journey Section -->
    <section class="section-padding bg-charcoal text-paper" data-theme="dark">
      <div class="max-w-7xl mx-auto">
        <div class="flex flex-col md:flex-row justify-between items-start mb-24 gap-12">
          <div class="max-w-xl">
             <p class="text-overline opacity-40 mb-4">Journey</p>
             <h2 class="text-5xl md:text-7xl font-bold tracking-tighter">Professional Path</h2>
          </div>
          <p class="md:max-w-xs font-body text-sm opacity-50 mt-4">
             Evolution through collaboration, exploration, and persistent craft.
          </p>
        </div>

        <div class="space-y-24">
          <div
            v-for="(item, index) in aboutContent.experience.items"
            :key="index"
            class="group flex flex-col md:flex-row gap-8 md:gap-24 relative"
          >
            <!-- Year -->
            <div class="md:w-32 flex-shrink-0">
               <span class="text-overline opacity-30 group-hover:opacity-100 transition-opacity">{{ item.period }}</span>
            </div>
            
            <!-- Content -->
            <div class="flex-1 space-y-4">
               <h3 class="text-3xl md:text-4xl font-semibold tracking-tighter">{{ item.title }}</h3>
               <p class="font-body text-lg opacity-60 leading-relaxed max-w-2xl">
                 {{ item.description }}
               </p>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Expertise Section -->
    <section class="section-padding bg-paper dark:bg-charcoal transition-colors duration-300">
      <div class="max-w-7xl mx-auto">
        <div class="text-center mb-20">
           <p class="text-overline mb-4 opacity-40">Expertise</p>
           <h2 class="text-5xl md:text-7xl font-bold tracking-tighter">Capabilities</h2>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-x-12 gap-y-16">
          <div
            v-for="(skill, index) in aboutContent.skills.items"
            :key="index"
            class="space-y-6"
          >
            <div class="w-10 h-10 rounded-full border border-charcoal/10 dark:border-paper/10 flex items-center justify-center">
               <span class="text-[10px] font-bold">{{ index + 1 }}</span>
            </div>
            <h3 class="font-display text-xl font-bold tracking-tight">
              {{ skill.title }}
            </h3>
            <p class="font-body text-sm text-charcoal/60 dark:text-paper/60 leading-relaxed">
              {{ skill.description }}
            </p>
          </div>
        </div>
      </div>
    </section>

    <!-- Let's Talk CTA -->
    <section class="section-padding bg-paper dark:bg-charcoal">
       <div class="max-w-7xl mx-auto text-center space-y-12">
          <h2 class="text-6xl md:text-8xl font-bold tracking-tighter italic">Ready to start?</h2>
          <NuxtLink to="/contact">
             <div class="inline-flex items-center gap-6 group cursor-pointer">
                <div class="w-20 h-20 md:w-32 md:h-32 rounded-full border border-charcoal/10 flex items-center justify-center group-hover:bg-charcoal group-hover:text-paper transition-all duration-700 cubic-bezier(0.16, 1, 0.3, 1)">
                   <UIcon name="lucide:arrow-right" class="w-8 h-8 md:w-12 md:h-12" />
                </div>
                <span class="text-2xl md:text-3xl font-display font-semibold tracking-tighter">Get in touch</span>
             </div>
          </NuxtLink>
       </div>
    </section>
  </div>
</template>

<script setup>
const supabase = useSupabaseClient()

useHead({
  title: 'About Me - Anna Ericyan',
  meta: [
    { name: 'description', content: 'Learn more about Anna Ericyan, a passionate graphic designer specializing in branding, illustration, and creative design.' }
  ]
})

const aboutContent = ref({
  hero: {
    image: '',
    paragraphs: []
  },
  skills: {
    title: "What I Do",
    description: "Specialized skills and services I offer to bring your vision to life",
    items: [
      { title: "Branding & Identity", description: "Memorable brand identities with logos and visual guidelines." },
      { title: "Print Design", description: "Posters, flyers, and business cards that leave lasting impressions." },
      { title: "Digital Illustrations", description: "Custom illustrations and digital artwork that captivate audiences." },
      { title: "Packaging Design", description: "Stunning product packaging that stands out on shelves and online." }
    ]
  },
  experience: {
    title: "Experience",
    description: "My journey in design",
    items: [
      {
        title: "Senior Graphic Designer",
        period: "2020 - Present",
        description: "Leading creative projects and mentoring junior designers while delivering exceptional brand experiences."
      },
      {
        title: "Freelance Designer",
        period: "2018 - 2020",
        description: "Worked with diverse clients creating branding, illustrations, and print materials."
      }
    ]
  },
  cta: {
    title: "Let's Create Together",
    subtitle: "I'm always excited to work on new projects and collaborate with passionate people."
  }
})

const contentFetched = ref(false)

const fetchContent = async () => {
  try {
    const { data, error } = await supabase
      .from('about_content')
      .select('*')
      .order('id', { ascending: false })
      .limit(1)
      .maybeSingle()

    if (!error && data?.content) {
      if (data.content.hero?.image) aboutContent.value.hero.image = data.content.hero.image
      if (data.content.hero?.paragraphs) aboutContent.value.hero.paragraphs = data.content.hero.paragraphs
      if (data.content.skills) Object.assign(aboutContent.value.skills, data.content.skills)
      if (data.content.experience) Object.assign(aboutContent.value.experience, data.content.experience)
      contentFetched.value = true
    }
  } catch (err) {
    console.error('Error fetching about content:', err)
  }
}

onMounted(() => {
  fetchContent()
})
</script>
