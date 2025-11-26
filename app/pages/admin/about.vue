<template>
  <div class="min-h-screen bg-gray-50">
    <!-- Admin Header -->
    <header class="bg-portfolio-white border-b border-gray-200 sticky top-0 z-50">
      <div class="container mx-auto px-6 py-4">
        <div class="flex items-center justify-between">
          <div class="flex items-center space-x-4">
            <NuxtLink to="/admin" class="text-gray-500 hover:text-blue-purple">
              <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18">
                </path>
              </svg>
            </NuxtLink>
            <h1 class="text-2xl font-bold text-gray-900">Manage About Page</h1>
          </div>
          <button @click="saveAllContent" :disabled="saving"
            class="px-6 py-3 bg-blue-purple text-portfolio-white rounded-lg font-semibold hover:bg-bright-pink transition-all disabled:opacity-50">
            {{ saving ? 'Saving...' : 'Save All Changes' }}
          </button>
        </div>
      </div>
    </header>

    <!-- Main Content -->
    <main class="container mx-auto px-6 py-8 max-w-5xl">
      <!-- Loading State -->
      <div v-if="loading" class="text-center py-12">
        <div class="inline-block animate-spin rounded-full h-12 w-12 border-b-2 border-blue-purple"></div>
        <p class="text-gray-500 mt-4">Loading content...</p>
      </div>

      <!-- Content Editor -->
      <div v-else class="space-y-8">
        <!-- Hero Section -->
        <div class="bg-portfolio-white rounded-2xl p-8 shadow-md">
          <h2 class="text-2xl font-bold text-gray-900 mb-6 flex items-center gap-2">
            <span
              class="w-8 h-8 bg-bright-pink/10 text-bright-pink rounded-lg flex items-center justify-center text-sm font-bold">1</span>
            Hero Section
          </h2>

          <div class="space-y-6">
            <!-- Profile Image -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">Profile Image</label>
              <div class="flex items-center gap-6">
                <div class="relative w-32 h-32 bg-gray-100 rounded-full overflow-hidden border-2 border-gray-200">
                  <img v-if="aboutContent.hero.image" :src="aboutContent.hero.image"
                    class="w-full h-full object-cover" />
                  <div v-else class="w-full h-full flex items-center justify-center text-gray-400">
                    <svg class="w-12 h-12" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                        d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                    </svg>
                  </div>
                  <!-- Loading Overlay -->
                  <div v-if="uploadingImage" class="absolute inset-0 bg-black/50 flex items-center justify-center">
                    <div class="animate-spin rounded-full h-6 w-6 border-b-2 border-white"></div>
                  </div>
                </div>
                <div>
                  <button @click="$refs.fileInput.click()" :disabled="uploadingImage"
                    class="px-4 py-2 bg-white border border-gray-300 rounded-lg text-sm font-medium text-gray-700 hover:bg-gray-50 transition-all mb-2">
                    {{ aboutContent.hero.image ? 'Change Photo' : 'Upload Photo' }}
                  </button>
                  <p class="text-xs text-gray-500">Recommended: Square image, at least 400x400px</p>
                  <input type="file" ref="fileInput" class="hidden" accept="image/*" @change="handleImageUpload">
                </div>
              </div>
            </div>

            <!-- Bio Paragraphs -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">About Me Paragraphs</label>
              <div class="space-y-4">
                <div v-for="(paragraph, index) in aboutContent.hero.paragraphs" :key="index" class="relative">
                  <textarea v-model="aboutContent.hero.paragraphs[index]" rows="3"
                    class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-purple focus:border-transparent"
                    :placeholder="`Paragraph ${index + 1}`"></textarea>
                  <button v-if="aboutContent.hero.paragraphs.length > 1" @click="removeParagraph(index)"
                    class="absolute top-2 right-2 p-2 text-bright-pink hover:bg-bright-pink/10 rounded-lg transition-all">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12">
                      </path>
                    </svg>
                  </button>
                </div>
                <button @click="addParagraph"
                  class="px-4 py-2 bg-light-green/10 text-light-green rounded-lg font-medium hover:bg-light-green/20 transition-all">
                  + Add Paragraph
                </button>
              </div>
            </div>
          </div>
        </div>

        <!-- Skills Section -->
        <div class="bg-portfolio-white rounded-2xl p-8 shadow-md">
          <h2 class="text-2xl font-bold text-gray-900 mb-6 flex items-center gap-2">
            <span
              class="w-8 h-8 bg-light-blue/10 text-light-blue rounded-lg flex items-center justify-center text-sm font-bold">2</span>
            Skills Section
          </h2>

          <div class="space-y-6">
            <!-- Section Title & Description -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Section Title</label>
                <input v-model="aboutContent.skills.title" type="text"
                  class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-purple focus:border-transparent"
                  placeholder="What I Do" />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Section Description</label>
                <input v-model="aboutContent.skills.description" type="text"
                  class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-purple focus:border-transparent"
                  placeholder="Specialized skills and services..." />
              </div>
            </div>

            <!-- Skills List -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-4">Skills</label>
              <div class="space-y-4">
                <div v-for="(skill, index) in aboutContent.skills.items" :key="index"
                  class="border border-gray-200 rounded-xl p-4">
                  <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <input v-model="skill.title" type="text" placeholder="Skill Title"
                      class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-purple focus:border-transparent" />
                    <input v-model="skill.description" type="text" placeholder="Skill Description"
                      class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-purple focus:border-transparent" />
                  </div>
                  <div class="flex justify-end mt-2">
                    <button @click="removeSkill(index)"
                      class="text-sm text-bright-pink hover:bg-bright-pink/10 px-3 py-1 rounded-lg transition-all">
                      Remove
                    </button>
                  </div>
                </div>
              </div>
              <button @click="addSkill"
                class="mt-4 px-4 py-2 bg-light-green/10 text-light-green rounded-lg font-medium hover:bg-light-green/20 transition-all">
                + Add Skill
              </button>
            </div>
          </div>
        </div>

        <!-- Experience Section -->
        <div class="bg-portfolio-white rounded-2xl p-8 shadow-md">
          <h2 class="text-2xl font-bold text-gray-900 mb-6 flex items-center gap-2">
            <span
              class="w-8 h-8 bg-light-green/10 text-light-green rounded-lg flex items-center justify-center text-sm font-bold">3</span>
            Experience Timeline
          </h2>

          <div class="space-y-6">
            <!-- Section Title & Description -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Section Title</label>
                <input v-model="aboutContent.experience.title" type="text"
                  class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-purple focus:border-transparent"
                  placeholder="Experience" />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Section Description</label>
                <input v-model="aboutContent.experience.description" type="text"
                  class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-purple focus:border-transparent"
                  placeholder="My journey in design" />
              </div>
            </div>

            <!-- Experience Items -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-4">Experience Items</label>
              <div class="space-y-4">
                <div v-for="(item, index) in aboutContent.experience.items" :key="index"
                  class="border border-gray-200 rounded-xl p-4">
                  <div class="space-y-3">
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                      <input v-model="item.title" type="text" placeholder="Job Title"
                        class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-purple focus:border-transparent" />
                      <input v-model="item.period" type="text" placeholder="Time Period (e.g., 2020 - Present)"
                        class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-purple focus:border-transparent" />
                    </div>
                    <textarea v-model="item.description" rows="2" placeholder="Job Description"
                      class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-purple focus:border-transparent"></textarea>
                  </div>
                  <div class="flex justify-end mt-2">
                    <button @click="removeExperience(index)"
                      class="text-sm text-bright-pink hover:bg-bright-pink/10 px-3 py-1 rounded-lg transition-all">
                      Remove
                    </button>
                  </div>
                </div>
              </div>
              <button @click="addExperience"
                class="mt-4 px-4 py-2 bg-light-green/10 text-light-green rounded-lg font-medium hover:bg-light-green/20 transition-all">
                + Add Experience
              </button>
            </div>
          </div>
        </div>

        <!-- CTA Section -->
        <div class="bg-portfolio-white rounded-2xl p-8 shadow-md">
          <h2 class="text-2xl font-bold text-gray-900 mb-6 flex items-center gap-2">
            <span
              class="w-8 h-8 bg-blue-purple/10 text-blue-purple rounded-lg flex items-center justify-center text-sm font-bold">4</span>
            Call to Action Section
          </h2>

          <div class="space-y-4">
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">Title</label>
              <input v-model="aboutContent.cta.title" type="text"
                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-purple focus:border-transparent"
                placeholder="Let's Create Together" />
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">Subtitle</label>
              <textarea v-model="aboutContent.cta.subtitle" rows="2"
                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-purple focus:border-transparent"
                placeholder="I'm always excited to work on new projects..."></textarea>
            </div>
          </div>
        </div>
      </div>

      <!-- Save Button (Bottom) -->
      <div class="mt-8 text-center">
        <button @click="saveAllContent" :disabled="saving"
          class="px-8 py-3 bg-blue-purple text-portfolio-white rounded-full font-semibold hover:bg-bright-pink transition-all shadow-lg hover:shadow-xl disabled:opacity-50">
          {{ saving ? 'Saving...' : 'Save All Changes' }}
        </button>
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
      .single()

    if (error && error.code !== 'PGRST116') {
      throw error
    }

    if (data) {
      aboutContent.value = data.content
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
    // Check if content exists
    const { data: existing } = await supabase
      .from('about_content')
      .select('id')
      .single()

    if (existing) {
      // Update existing
      const { error } = await supabase
        .from('about_content')
        .update({ content: aboutContent.value })
        .eq('id', existing.id)

      if (error) throw error
    } else {
      // Insert new
      const { error } = await supabase
        .from('about_content')
        .insert([{ content: aboutContent.value }])

      if (error) throw error
    }

    useToast().success('Changes saved successfully!')
  } catch (error) {
    console.error('Error saving content:', error)
    useToast().error('Error saving changes. Please try again.')
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
    aboutContent.value.hero.image = publicUrl
    useToast().success('Image uploaded successfully')
  } catch (error) {
    console.error('Error uploading image:', error)
    useToast().error('Failed to upload image. Please try again.')
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
