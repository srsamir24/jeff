<template>
  <NuxtLayout name="admin">
    <div class="max-w-4xl mx-auto">
      <!-- Header Area -->
      <div class="flex flex-col md:flex-row md:items-center justify-between gap-6 mb-12">
        <div>
          <h1 class="text-4xl font-bold tracking-tight text-white mb-2 font-display">Manage About</h1>
          <p class="text-white/40 font-medium">Curate your professional story and background</p>
        </div>
        <button @click="saveAllContent" :disabled="saving"
          class="group flex items-center justify-center gap-2 px-8 py-4 bg-white text-black rounded-full font-bold hover:bg-bright-pink hover:text-white transition-all duration-300 disabled:opacity-50">
          <span v-if="!saving" class="flex items-center gap-2">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M5 13l4 4L19 7"></path>
            </svg>
            Save All Changes
          </span>
          <span v-else class="flex items-center gap-2">
            <div class="w-4 h-4 border-2 border-black/20 border-t-black rounded-full animate-spin"></div>
            Saving...
          </span>
        </button>
      </div>

      <!-- Loading State -->
      <div v-if="loading" class="flex flex-col items-center justify-center py-24">
        <div class="w-12 h-12 border-2 border-white/10 border-t-white rounded-full animate-spin mb-4"></div>
        <p class="text-white/40 font-medium animate-pulse">Retrieving content...</p>
      </div>

      <!-- Content Editor -->
      <div v-else class="space-y-12 pb-12">
        <!-- Hero Section -->
        <section class="bg-white/[0.02] backdrop-blur-3xl rounded-[32px] p-8 md:p-12 transition-all duration-500 hover:bg-white/[0.04]">
          <div class="flex items-center gap-4 mb-10">
            <span class="text-[10px] uppercase tracking-[0.4em] text-white/20 font-bold">Step 1</span>
            <h2 class="text-2xl font-bold font-display">Hero Section</h2>
          </div>

          <div class="space-y-10">
            <!-- Profile Image -->
            <div>
              <label class="text-overline block mb-4">Profile Image</label>
              <div class="flex flex-col sm:flex-row items-center gap-8">
                <div class="relative w-40 h-40 bg-white/5 rounded-full overflow-hidden">
                  <img v-if="aboutContent.hero.image" :src="aboutContent.hero.image"
                    class="w-full h-full object-cover grayscale hover:grayscale-0 transition-all duration-700" />
                  <div v-else class="w-full h-full flex items-center justify-center text-white/10">
                    <svg class="w-16 h-16" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1"
                        d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                    </svg>
                  </div>
                  <!-- Loading Overlay -->
                  <div v-if="uploadingImage" class="absolute inset-0 bg-black/60 flex items-center justify-center backdrop-blur-sm">
                    <div class="w-6 h-6 border-2 border-white/20 border-t-white rounded-full animate-spin"></div>
                  </div>
                </div>
                <div class="flex flex-col items-center sm:items-start gap-4">
                  <button @click="$refs.fileInput.click()" :disabled="uploadingImage"
                    class="px-6 py-2 bg-white/5 hover:bg-white/10 text-white rounded-full text-xs font-bold tracking-widest uppercase transition-all">
                    {{ aboutContent.hero.image ? 'Replace Photo' : 'Upload Photo' }}
                  </button>
                  <p class="text-[10px] text-white/20 tracking-wider">RECOMMENDED: SQUARE IMAGE, MIN 800PX</p>
                  <input type="file" ref="fileInput" class="hidden" accept="image/*" @change="handleImageUpload">
                </div>
              </div>
            </div>

            <!-- Bio Paragraphs -->
            <div>
              <label class="text-overline block mb-4">About Me Narrative</label>
              <div class="space-y-4">
                <div v-for="(paragraph, index) in aboutContent.hero.paragraphs" :key="index" class="group relative">
                  <textarea v-model="aboutContent.hero.paragraphs[index]" rows="3"
                    class="w-full px-6 py-4 bg-white/[0.03] rounded-2xl text-white/80 placeholder:text-white/10 focus:ring-1 focus:ring-white/20 focus:bg-white/[0.05] transition-all resize-none outline-none border-none"
                    :placeholder="`Enter paragraph ${index + 1}...`"></textarea>
                  <button v-if="aboutContent.hero.paragraphs.length > 1" @click="removeParagraph(index)"
                    class="absolute top-4 right-4 p-2 text-white/20 hover:text-bright-pink hover:bg-bright-pink/10 rounded-xl transition-all opacity-0 group-hover:opacity-100">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                    </svg>
                  </button>
                </div>
                <button @click="addParagraph"
                  class="flex items-center gap-2 px-6 py-3 text-xs font-bold uppercase tracking-widest text-white/40 hover:text-white transition-colors">
                  <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"></path>
                  </svg>
                  Add Paragraph
                </button>
              </div>
            </div>
          </div>
        </section>

        <!-- Skills Section -->
        <section class="bg-white/[0.02] backdrop-blur-3xl rounded-[32px] p-8 md:p-12 transition-all duration-500 hover:bg-white/[0.04]">
          <div class="flex items-center gap-4 mb-10">
            <span class="text-[10px] uppercase tracking-[0.4em] text-white/20 font-bold">Step 2</span>
            <h2 class="text-2xl font-bold font-display">Specializations</h2>
          </div>

          <div class="space-y-10">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
              <div>
                <label class="text-overline block mb-4">Section Title</label>
                <input v-model="aboutContent.skills.title" type="text"
                  class="w-full px-6 py-4 bg-white/[0.03] rounded-2xl text-white focus:ring-1 focus:ring-white/20 outline-none border-none"
                  placeholder="What I Do" />
              </div>
              <div>
                <label class="text-overline block mb-4">Description</label>
                <input v-model="aboutContent.skills.description" type="text"
                  class="w-full px-6 py-4 bg-white/[0.03] rounded-2xl text-white focus:ring-1 focus:ring-white/20 outline-none border-none"
                  placeholder="Service summary..." />
              </div>
            </div>

            <div>
              <label class="text-overline block mb-6">Expertise Items</label>
              <div class="grid grid-cols-1 gap-4">
                <div v-for="(skill, index) in aboutContent.skills.items" :key="index"
                  class="group relative bg-white/[0.03] rounded-[24px] p-6 hover:bg-white/[0.06] transition-all">
                  <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div class="space-y-2">
                       <label class="text-[9px] uppercase tracking-[0.2em] text-white/20 font-bold ml-1">Title</label>
                       <input v-model="skill.title" type="text"
                        class="w-full px-4 py-3 bg-white/5 rounded-xl text-white font-bold outline-none border-none focus:bg-white/10 transition-all"
                        placeholder="Skill Name" />
                    </div>
                    <div class="space-y-2">
                      <label class="text-[9px] uppercase tracking-[0.2em] text-white/20 font-bold ml-1">Detail</label>
                      <input v-model="skill.description" type="text"
                        class="w-full px-4 py-3 bg-white/5 rounded-xl text-white/60 outline-none border-none focus:bg-white/10 transition-all"
                        placeholder="Concise description" />
                    </div>
                  </div>
                  <button @click="removeSkill(index)"
                    class="absolute -top-2 -right-2 p-2 bg-charcoal text-white/40 hover:text-bright-pink rounded-full shadow-xl transition-all opacity-0 group-hover:opacity-100 scale-90 group-hover:scale-100">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                    </svg>
                  </button>
                </div>
              </div>
              <button @click="addSkill"
                class="mt-8 flex items-center gap-2 px-6 py-3 text-xs font-bold uppercase tracking-widest text-white/40 hover:text-white transition-colors">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"></path>
                </svg>
                Add Expertise
              </button>
            </div>
          </div>
        </section>

        <!-- Experience Section -->
        <section class="bg-white/[0.02] backdrop-blur-3xl rounded-[32px] p-8 md:p-12 transition-all duration-500 hover:bg-white/[0.04]">
          <div class="flex items-center gap-4 mb-10">
            <span class="text-[10px] uppercase tracking-[0.4em] text-white/20 font-bold">Step 3</span>
            <h2 class="text-2xl font-bold font-display">Journey & Milestones</h2>
          </div>

          <div class="space-y-10">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
              <div>
                <label class="text-overline block mb-4">Section Title</label>
                <input v-model="aboutContent.experience.title" type="text"
                  class="w-full px-6 py-4 bg-white/[0.03] rounded-2xl text-white focus:ring-1 focus:ring-white/20 outline-none border-none"
                  placeholder="Experience" />
              </div>
              <div>
                <label class="text-overline block mb-4">Description</label>
                <input v-model="aboutContent.experience.description" type="text"
                  class="w-full px-6 py-4 bg-white/[0.03] rounded-2xl text-white focus:ring-1 focus:ring-white/20 outline-none border-none"
                  placeholder="Journey overview..." />
              </div>
            </div>

            <div>
              <label class="text-overline block mb-6">Timeline Events</label>
              <div class="space-y-6">
                <div v-for="(item, index) in aboutContent.experience.items" :key="index"
                  class="group relative bg-white/[0.03] rounded-[24px] p-8 hover:bg-white/[0.06] transition-all">
                  <div class="grid grid-cols-1 md:grid-cols-2 gap-8 mb-6">
                    <div class="space-y-2">
                      <label class="text-[9px] uppercase tracking-[0.2em] text-white/20 font-bold ml-1">Position / Role</label>
                      <input v-model="item.title" type="text"
                        class="w-full px-4 py-3 bg-white/5 rounded-xl text-white font-bold outline-none border-none focus:bg-white/10 transition-all"
                        placeholder="e.g. Senior Designer" />
                    </div>
                    <div class="space-y-2">
                      <label class="text-[9px] uppercase tracking-[0.2em] text-white/20 font-bold ml-1">Period</label>
                      <input v-model="item.period" type="text"
                        class="w-full px-4 py-3 bg-white/5 rounded-xl text-white/60 outline-none border-none focus:bg-white/10 transition-all"
                        placeholder="e.g. 2020 — Present" />
                    </div>
                  </div>
                  <div class="space-y-2">
                    <label class="text-[9px] uppercase tracking-[0.2em] text-white/20 font-bold ml-1">Responsibilities</label>
                    <textarea v-model="item.description" rows="2"
                      class="w-full px-4 py-3 bg-white/5 rounded-xl text-white/60 outline-none border-none focus:bg-white/10 transition-all resize-none"
                      placeholder="Detail your impact..."></textarea>
                  </div>
                  <button @click="removeExperience(index)"
                    class="absolute -top-2 -right-2 p-2 bg-charcoal text-white/40 hover:text-bright-pink rounded-full shadow-xl transition-all opacity-0 group-hover:opacity-100 scale-90 group-hover:scale-100">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                    </svg>
                  </button>
                </div>
              </div>
              <button @click="addExperience"
                class="mt-8 flex items-center gap-2 px-6 py-3 text-xs font-bold uppercase tracking-widest text-white/40 hover:text-white transition-colors">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"></path>
                </svg>
                Add Timeline Item
              </button>
            </div>
          </div>
        </section>

        <!-- CTA Section -->
        <section class="bg-white/[0.02] backdrop-blur-3xl rounded-[32px] p-8 md:p-12 transition-all duration-500 hover:bg-white/[0.04]">
          <div class="flex items-center gap-4 mb-10">
            <span class="text-[10px] uppercase tracking-[0.4em] text-white/20 font-bold">Step 4</span>
            <h2 class="text-2xl font-bold font-display">Call to Action</h2>
          </div>

          <div class="space-y-8">
            <div class="space-y-2">
              <label class="text-overline block">Main Title</label>
              <input v-model="aboutContent.cta.title" type="text"
                class="w-full px-6 py-4 bg-white/[0.03] rounded-2xl text-white text-xl font-bold focus:ring-1 focus:ring-white/20 outline-none border-none"
                placeholder="Let's Create Together" />
            </div>
            <div class="space-y-2">
              <label class="text-overline block">Engagement Message</label>
              <textarea v-model="aboutContent.cta.subtitle" rows="3"
                class="w-full px-6 py-4 bg-white/[0.03] rounded-2xl text-white/60 focus:ring-1 focus:ring-white/20 outline-none border-none resize-none"
                placeholder="I'm always excited to work on new projects..."></textarea>
            </div>
          </div>
        </section>

        <!-- Final Save -->
        <div class="flex justify-center pt-8">
          <button @click="saveAllContent" :disabled="saving"
            class="group relative inline-flex items-center justify-center px-10 py-5 font-bold text-white transition-all duration-300 font-display">
            <!-- Animated Background -->
            <div class="absolute inset-0 bg-white rounded-full transition-transform duration-500 group-hover:scale-105"></div>
            <div class="absolute inset-[2px] bg-charcoal rounded-full transition-colors duration-500 group-hover:bg-bright-pink"></div>
            
            <span class="relative z-10 flex items-center gap-3">
              <span v-if="!saving" class="flex items-center gap-3">
                 Confirm All Changes
                 <svg class="w-5 h-5 group-hover:translate-x-1 transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                   <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14 5l7 7m0 0l-7 7m7-7H3"></path>
                 </svg>
              </span>
              <span v-else class="flex items-center gap-2">
                <div class="w-4 h-4 border-2 border-white/20 border-t-white rounded-full animate-spin"></div>
                Saving to Database...
              </span>
            </span>
          </button>
        </div>
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

// State
const loading = ref(true)
const saving = ref(false)
const uploadingImage = ref(false)

const aboutContent = ref({
  hero: {
    image: '',
    paragraphs: [
      "Hi! I'm Anna Ericyan, a passionate graphic designer with a love for creating visual stories that captivate and inspire.",
      "With years of experience in branding, print design, and digital illustration, I help businesses and individuals bring their creative visions to life through thoughtful, beautiful design.",
      "My approach combines creativity with strategy, ensuring every project not only looks amazing but also achieves its goals."
    ]
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

// Fetch content
const fetchContent = async () => {
  loading.value = true
  try {
    const { data, error } = await supabase
      .from('about_content')
      .select('*')
      .order('id', { ascending: false })
      .limit(1)
      .maybeSingle()

    if (error) {
      console.error('Error fetching about content:', error)
      throw error
    }

    if (data) {
      aboutContent.value = data.content
      console.log('Admin fetched content:', data.content)
    }
  } catch (error) {
    console.error('Error fetching about content:', error)
  } finally {
    loading.value = false
  }
}

// Save content
const saveAllContent = async () => {
  saving.value = true
  try {
    // Check if content exists - get the latest one
    const { data: existing } = await supabase
      .from('about_content')
      .select('id')
      .order('id', { ascending: false })
      .limit(1)
      .maybeSingle()

    console.log('Saving content:', aboutContent.value)

    if (existing) {
      // Update existing (latest record)
      const { error } = await supabase
        .from('about_content')
        .update({ content: aboutContent.value })
        .eq('id', existing.id)

      if (error) throw error
      console.log('Content updated successfully')
    } else {
      // Insert new
      const { error } = await supabase
        .from('about_content')
        .insert([{ content: aboutContent.value }])

      if (error) throw error
      console.log('Content inserted successfully')
    }

    useAppToast().success('Changes saved successfully!')
  } catch (error) {
    console.error('Error saving content:', error)
    useAppToast().error('Error saving changes. Please try again.')
  } finally {
    saving.value = false
  }
}

// Helper functions
const addParagraph = () => {
  aboutContent.value.hero.paragraphs.push('')
}

const removeParagraph = (index) => {
  aboutContent.value.hero.paragraphs.splice(index, 1)
}

const addSkill = () => {
  aboutContent.value.skills.items.push({
    title: '',
    description: ''
  })
}

const removeSkill = (index) => {
  aboutContent.value.skills.items.splice(index, 1)
}

const addExperience = () => {
  aboutContent.value.experience.items.push({
    title: '',
    period: '',
    description: ''
  })
}

const removeExperience = (index) => {
  aboutContent.value.experience.items.splice(index, 1)
}

const handleImageUpload = async (e) => {
  const file = e.target.files[0]
  if (!file) return

  uploadingImage.value = true
  try {
    const { uploadFile } = useSupabaseStorage()
    const publicUrl = await uploadFile(file, `about-${Date.now()}-${file.name}`)
    console.log('Image uploaded successfully, URL:', publicUrl)
    aboutContent.value.hero.image = publicUrl
    console.log('aboutContent.hero.image set to:', aboutContent.value.hero.image)
    useAppToast().success('Image uploaded successfully')
  } catch (error) {
    console.error('Error uploading image:', error)
    useAppToast().error('Failed to upload image. Please try again.')
  } finally {
    uploadingImage.value = false
    e.target.value = '' // Reset input
  }
}

// Load content on mount
onMounted(() => {
  fetchContent()
})
</script>
