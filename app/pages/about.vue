<template>
  <div class="min-h-screen bg-portfolio-white">
    <!-- Hero Section -->
    <section
      class="relative overflow-hidden bg-linear-to-br from-portfolio-white via-light-green/10 to-lighter-pink/10 pt-24 md:pt-32 pb-12 md:pb-20">
      <!-- Animated background elements -->
      <div
        class="absolute top-0 left-0 w-96 h-96 bg-light-green/20 rounded-full blur-3xl -translate-x-1/2 -translate-y-1/2 animate-blob">
      </div>
      <div
        class="absolute bottom-0 right-0 w-96 h-96 bg-lighter-pink/20 rounded-full blur-3xl translate-x-1/2 translate-y-1/2 animate-blob animation-delay-2000">
      </div>

      <div class="container mx-auto px-6 relative z-10">
        <div class="flex flex-col lg:flex-row items-start gap-12">
          <!-- Professional Photo - Smaller Size -->
          <div class="lg:w-64 flex justify-center lg:justify-start">
            <div class="relative">
              <div class="w-64 h-64 rounded-2xl overflow-hidden shadow-xl bg-white ring-4 ring-white">
                <!-- Dynamic Image -->
                <img v-if="aboutContent.hero.image" :src="aboutContent.hero.image" alt="Anna Ericyan"
                  class="w-full h-full object-cover" />

                <!-- Placeholder -->
                <div v-else
                  class="w-full h-full bg-linear-to-br from-bright-pink/30 via-blue-purple/30 to-light-green/30 flex items-center justify-center">
                  <div class="text-center">
                    <div class="w-20 h-20 mx-auto bg-portfolio-white/80 rounded-full flex items-center justify-center mb-3">
                      <svg class="w-12 h-12 text-blue-purple" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                          d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                      </svg>
                    </div>
                    <p class="text-gray-700 text-sm font-medium">Photo</p>
                  </div>
                </div>
              </div>
              <!-- Decorative accent -->
              <div class="absolute -bottom-4 -right-4 w-24 h-24 bg-bright-pink/20 rounded-2xl -z-10"></div>
            </div>
          </div>

          <!-- Text Content -->
          <div class="flex-1 text-center lg:text-left">
            <h1 class="text-4xl md:text-5xl lg:text-6xl font-bold mb-4 md:mb-6">
              <span class="bg-clip-text text-transparent bg-linear-to-r from-bright-pink via-blue-purple to-light-blue">
                About Me
              </span>
            </h1>
            <div class="space-y-3 md:space-y-4 text-base md:text-lg text-gray-600 leading-relaxed">
              <p v-for="(paragraph, index) in aboutContent.hero.paragraphs" :key="index"
                class="text-sm md:text-base lg:text-lg">
                {{ paragraph }}
              </p>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Skills Section -->
    <section class="py-12 md:py-20 bg-gray-50">
      <div class="container mx-auto px-6">
        <div class="text-center mb-10 md:mb-16">
          <h2 class="text-3xl md:text-4xl lg:text-5xl font-bold mb-3 md:mb-4">
            <span class="bg-clip-text text-transparent bg-linear-to-r from-blue-purple to-bright-pink">
              {{ aboutContent.skills.title }}
            </span>
          </h2>
          <p class="text-base md:text-lg lg:text-xl text-gray-600 max-w-2xl mx-auto px-4">
            {{ aboutContent.skills.description }}
          </p>
        </div>

        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 md:gap-6 lg:gap-8">
          <div v-for="(skill, index) in aboutContent.skills.items" :key="index"
            :class="['group bg-portfolio-white rounded-2xl md:rounded-3xl p-5 md:p-8 shadow-md hover:shadow-2xl transition-all border border-gray-100', getSkillHoverBorder(index)]">
            <div
              :class="['w-12 h-12 md:w-16 md:h-16 rounded-xl md:rounded-2xl flex items-center justify-center mb-4 md:mb-6 group-hover:scale-110 transition-transform', getSkillBgClass(index)]">
              <svg class="w-6 h-6 md:w-8 md:h-8 text-portfolio-white" fill="none" stroke="currentColor"
                viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" :d="getSkillIcon(index)" />
              </svg>
            </div>
            <h3
              :class="['text-lg md:text-xl font-bold text-gray-900 mb-1 md:mb-2 transition-colors', getSkillTextClass(index)]">
              {{ skill.title }}
            </h3>
            <p class="text-sm md:text-base text-gray-600 leading-snug">{{ skill.description }}</p>
          </div>
        </div>
      </div>
    </section>

    <!-- Experience Timeline -->
    <section class="py-12 md:py-20 bg-portfolio-white">
      <div class="container mx-auto px-6">
        <div class="text-center mb-10 md:mb-16">
          <h2 class="text-3xl md:text-4xl lg:text-5xl font-bold mb-3 md:mb-4">
            <span class="bg-clip-text text-transparent bg-linear-to-r from-light-green to-light-blue">
              {{ aboutContent.experience.title }}
            </span>
          </h2>
          <p class="text-base md:text-lg lg:text-xl text-gray-600 px-4">{{ aboutContent.experience.description }}</p>
        </div>

        <div class="max-w-3xl mx-auto space-y-4 md:space-y-6 lg:space-y-8">
          <div v-for="(item, index) in aboutContent.experience.items" :key="index"
            class="flex gap-3 md:gap-4 lg:gap-6 group">
            <div class="flex-shrink-0">
              <div
                :class="['w-10 h-10 md:w-12 md:h-12 rounded-full flex items-center justify-center shadow-lg group-hover:scale-110 transition-transform', getExperienceBgClass(index)]">
                <span class="text-portfolio-white font-bold text-sm md:text-base">{{ index + 1 }}</span>
              </div>
            </div>
            <div class="flex-1 bg-gray-50 rounded-xl md:rounded-2xl p-4 md:p-6 hover:shadow-lg transition-all">
              <h3 class="text-lg md:text-xl font-bold text-gray-900 mb-1 md:mb-2">{{ item.title }}</h3>
              <p :class="['text-sm md:text-base font-semibold mb-2', getExperienceTextClass(index)]">{{ item.period }}
              </p>
              <p class="text-sm md:text-base text-gray-600 leading-snug">{{ item.description }}</p>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- CTA Section -->
    <section class="py-12 md:py-16 lg:py-20 bg-linear-to-br from-light-blue via-blue-purple to-bright-pink">
      <div class="container mx-auto px-6 text-center">
        <h2 class="text-3xl md:text-4xl lg:text-5xl font-bold text-portfolio-white mb-4 md:mb-6">
          {{ aboutContent.cta.title }}
        </h2>
        <p class="text-base md:text-lg lg:text-xl text-portfolio-white/90 mb-6 md:mb-8 max-w-2xl mx-auto px-4">
          {{ aboutContent.cta.subtitle }}
        </p>
        <div class="flex flex-col sm:flex-row gap-4 justify-center">
          <AppButton to="/work" variant="outline" size="lg"
            class="bg-portfolio-white/10 backdrop-blur-sm border-portfolio-white text-portfolio-white hover:bg-portfolio-white hover:text-blue-purple">
            View My Work
          </AppButton>
          <AppButton to="/contact" variant="secondary" size="lg" class=" text-bright-pink">
            Get In Touch
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
  title: 'About Me - Anna Ericyan',
  meta: [
    { name: 'description', content: 'Learn more about Anna Ericyan, a passionate graphic designer specializing in branding, illustration, and creative design.' }
  ]
})

// Default content (minimal to avoid flash)
const aboutContent = ref({
  hero: {
    image: '',
    paragraphs: []
  },
  skills: {
    title: "What I Do",
    description: "Specialized skills and services I offer to bring your vision to life",
    items: [
      {
        title: "Branding & Identity",
        description: "Creating memorable brand identities with logos and visual guidelines"
      },
      {
        title: "Print Design",
        description: "Eye-catching posters, flyers, and business cards that leave lasting impressions"
      },
      {
        title: "Digital Illustrations",
        description: "Custom illustrations and digital artwork that captivate audiences"
      },
      {
        title: "Packaging Design",
        description: "Stunning product packaging that stands out on shelves and online"
      }
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
      },
      {
        title: "Junior Designer",
        period: "2016 - 2018",
        description: "Developed foundational skills in design, learned industry best practices, and contributed to team projects."
      }
    ]
  },
  cta: {
    title: "Let's Create Together",
    subtitle: "I'm always excited to work on new projects and collaborate with passionate people."
  }
})

// Track if content has been fetched
const contentFetched = ref(false)

// Fetch content from database
const fetchContent = async () => {
  try {
    const { data, error } = await supabase
      .from('about_content')
      .select('*')
      .order('id', { ascending: false })
      .limit(1)
      .maybeSingle()

    if (error) {
      console.error('Supabase query error:', error)
      throw error
    }

    if (data && data.content) {
      console.log('Fetched about content from database:', data.content)

      // Always update image URL to reflect latest uploads
      if (data.content.hero?.image) {
        aboutContent.value.hero.image = data.content.hero.image
        console.log('Image URL updated to:', aboutContent.value.hero.image)
      } else {
        console.log('No image found in database')
      }

      // Only update text content on first load (prevents flash)
      if (!contentFetched.value) {
        if (data.content.hero?.paragraphs) {
          aboutContent.value.hero.paragraphs = data.content.hero.paragraphs
        }
        if (data.content.skills) {
          Object.assign(aboutContent.value.skills, data.content.skills)
        }
        if (data.content.experience) {
          Object.assign(aboutContent.value.experience, data.content.experience)
        }
        if (data.content.cta) {
          Object.assign(aboutContent.value.cta, data.content.cta)
        }
        contentFetched.value = true
      }
    }
  } catch (error) {
    console.error('Error fetching about content:', error)
    if (!contentFetched.value) {
      contentFetched.value = true
    }
  }
}

// Color cycling helper functions
const skillColors = [
  { bg: 'bg-linear-to-br from-bright-pink to-lighter-pink', hoverBorder: 'hover:border-bright-pink/20', hoverText: 'group-hover:text-bright-pink' },
  { bg: 'bg-linear-to-br from-light-green to-light-green/70', hoverBorder: 'hover:border-light-green/20', hoverText: 'group-hover:text-light-green' },
  { bg: 'bg-linear-to-br from-light-blue to-light-blue/70', hoverBorder: 'hover:border-light-blue/20', hoverText: 'group-hover:text-light-blue' },
  { bg: 'bg-linear-to-br from-blue-purple to-blue-purple/70', hoverBorder: 'hover:border-blue-purple/20', hoverText: 'group-hover:text-blue-purple' }
]

const skillIcons = [
  "M7 21a4 4 0 01-4-4V5a2 2 0 012-2h4a2 2 0 012 2v12a4 4 0 01-4 4zm0 0h12a2 2 0 002-2v-4a2 2 0 00-2-2h-2.343M11 7.343l1.657-1.657a2 2 0 012.828 0l2.829 2.829a2 2 0 010 2.828l-8.486 8.485M7 17h.01",
  "M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z",
  "M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z",
  "M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4"
]

const getSkillBgClass = (index) => {
  return skillColors[index % skillColors.length].bg
}

const getSkillHoverBorder = (index) => {
  return skillColors[index % skillColors.length].hoverBorder
}

const getSkillTextClass = (index) => {
  return skillColors[index % skillColors.length].hoverText
}

const getSkillIcon = (index) => {
  return skillIcons[index % skillIcons.length]
}

// Experience color cycling
const experienceColors = [
  { bg: 'bg-bright-pink', text: 'text-bright-pink' },
  { bg: 'bg-light-blue', text: 'text-light-blue' },
  { bg: 'bg-light-green', text: 'text-light-green' }
]

const getExperienceBgClass = (index) => {
  return experienceColors[index % experienceColors.length].bg
}

const getExperienceTextClass = (index) => {
  return experienceColors[index % experienceColors.length].text
}

// Fetch content on mount
onMounted(() => {
  fetchContent()
})
</script>
