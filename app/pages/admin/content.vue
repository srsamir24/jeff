<template>
  <div class="min-h-screen bg-gray-50">
    <!-- Admin Header -->
    <header class="bg-portfolio-white border-b border-gray-200 sticky top-0 z-50">
      <div class="container mx-auto px-6 py-4">
        <div class="flex items-center space-x-4">
          <NuxtLink to="/admin" class="text-gray-500 hover:text-blue-purple">
            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"></path>
            </svg>
          </NuxtLink>
          <h1 class="text-2xl font-bold text-gray-900">Manage Content</h1>
        </div>
      </div>
    </header>

    <!-- Main Content -->
    <main class="container mx-auto px-6 py-8">
      <!-- Loading State -->
      <div v-if="loading" class="text-center py-12">
        <div class="inline-block animate-spin rounded-full h-12 w-12 border-b-2 border-blue-purple"></div>
        <p class="text-gray-500 mt-4">Loading content...</p>
      </div>

      <!-- Content Tabs -->
      <div v-else>
        <!-- Tab Navigation -->
        <div class="flex space-x-2 mb-8 overflow-x-auto pb-2">
          <button
            v-for="tab in tabs"
            :key="tab.key"
            @click="activeTab = tab.key"
            :class="[
              'px-6 py-3 rounded-lg font-medium transition-all whitespace-nowrap',
              activeTab === tab.key
                ? 'bg-blue-purple text-portfolio-white shadow-lg'
                : 'bg-portfolio-white text-gray-600 hover:bg-gray-100'
            ]"
          >
            {{ tab.label }}
          </button>
        </div>

        <!-- Hero Section Form -->
        <div v-if="activeTab === 'hero'" class="bg-portfolio-white rounded-2xl p-8 shadow-md">
          <h2 class="text-2xl font-bold text-gray-900 mb-6">Hero Section</h2>
          <form @submit.prevent="saveSection('hero')" class="space-y-6">
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">Title</label>
              <input
                v-model="contentData.hero.title"
                type="text"
                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-purple focus:border-transparent"
              />
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">Subtitle</label>
              <textarea
                v-model="contentData.hero.subtitle"
                rows="3"
                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-purple focus:border-transparent"
              ></textarea>
            </div>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">CTA Button Text</label>
                <input
                  v-model="contentData.hero.ctaText"
                  type="text"
                  class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-purple focus:border-transparent"
                />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">CTA Button Link</label>
                <input
                  v-model="contentData.hero.ctaLink"
                  type="text"
                  class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-purple focus:border-transparent"
                />
              </div>
            </div>
            <AppButton
              type="submit"
              variant="primary"
              size="md"
              rounded="lg"
              :loading="saving"
              loading-text="Saving..."
            >
              Save Changes
            </AppButton>
          </form>
        </div>

        <!-- Stats Section Form -->
        <div v-if="activeTab === 'stats'" class="bg-portfolio-white rounded-2xl p-8 shadow-md">
          <h2 class="text-2xl font-bold text-gray-900 mb-6">Stats Section</h2>
          <form @submit.prevent="saveSection('stats')" class="space-y-6">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div v-for="(stat, index) in contentData.stats.stats" :key="index" class="border border-gray-200 rounded-lg p-4">
                <h3 class="font-semibold text-gray-900 mb-4">Stat {{ index + 1 }}</h3>
                <div class="space-y-3">
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Value</label>
                    <input
                      v-model="stat.value"
                      type="text"
                      class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-purple focus:border-transparent"
                    />
                  </div>
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Label</label>
                    <input
                      v-model="stat.label"
                      type="text"
                      class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-purple focus:border-transparent"
                    />
                  </div>
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Color Class</label>
                    <select
                      v-model="stat.colorClass"
                      class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-purple focus:border-transparent"
                    >
                      <option value="text-blue-purple">Blue Purple</option>
                      <option value="text-bright-pink">Bright Pink</option>
                      <option value="text-light-green">Light Green</option>
                      <option value="text-light-blue">Light Blue</option>
                    </select>
                  </div>
                </div>
              </div>
            </div>
            <AppButton
              type="submit"
              variant="primary"
              size="md"
              rounded="lg"
              :loading="saving"
              loading-text="Saving..."
            >
              Save Changes
            </AppButton>
          </form>
        </div>

        <!-- CTA Section Form -->
        <div v-if="activeTab === 'cta'" class="bg-portfolio-white rounded-2xl p-8 shadow-md">
          <h2 class="text-2xl font-bold text-gray-900 mb-6">CTA Section</h2>
          <form @submit.prevent="saveSection('cta')" class="space-y-6">
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">Title</label>
              <input
                v-model="contentData.cta.title"
                type="text"
                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-purple focus:border-transparent"
              />
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">Subtitle</label>
              <textarea
                v-model="contentData.cta.subtitle"
                rows="3"
                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-purple focus:border-transparent"
              ></textarea>
            </div>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Primary Button Text</label>
                <input
                  v-model="contentData.cta.primaryButtonText"
                  type="text"
                  class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-purple focus:border-transparent"
                />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Primary Button Link</label>
                <input
                  v-model="contentData.cta.primaryButtonLink"
                  type="text"
                  class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-purple focus:border-transparent"
                />
              </div>
            </div>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Secondary Button Text</label>
                <input
                  v-model="contentData.cta.secondaryButtonText"
                  type="text"
                  class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-purple focus:border-transparent"
                />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Secondary Button Link</label>
                <input
                  v-model="contentData.cta.secondaryButtonLink"
                  type="text"
                  class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-purple focus:border-transparent"
                />
              </div>
            </div>
            <AppButton
              type="submit"
              variant="primary"
              size="md"
              rounded="lg"
              :loading="saving"
              loading-text="Saving..."
            >
              Save Changes
            </AppButton>
          </form>
        </div>
      </div>

      <!-- Success Message -->
      <transition
        enter-active-class="transition duration-300 ease-out"
        enter-from-class="opacity-0 translate-y-2"
        enter-to-class="opacity-100 translate-y-0"
        leave-active-class="transition duration-200 ease-in"
        leave-from-class="opacity-100 translate-y-0"
        leave-to-class="opacity-0 translate-y-2"
      >
        <div v-if="showSuccess" class="fixed bottom-8 right-8 bg-light-green text-portfolio-white px-6 py-4 rounded-lg shadow-2xl flex items-center space-x-3">
          <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>
          </svg>
          <span class="font-medium">Changes saved successfully!</span>
        </div>
      </transition>
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
const showSuccess = ref(false)
const activeTab = ref('hero')

const tabs = [
  { key: 'hero', label: 'Hero Section' },
  { key: 'stats', label: 'Stats' },
  { key: 'cta', label: 'Call to Action' }
]

const contentData = ref({
  hero: {
    title: '',
    subtitle: '',
    ctaText: '',
    ctaLink: ''
  },
  stats: {
    stats: []
  },
  cta: {
    title: '',
    subtitle: '',
    primaryButtonText: '',
    primaryButtonLink: '',
    secondaryButtonText: '',
    secondaryButtonLink: ''
  }
})

// Fetch all content
const fetchContent = async () => {
  loading.value = true

  try {
    const { data, error } = await supabase
      .from('page_content')
      .select('*')

    if (error) throw error

    // Map database content to form data
    data.forEach(section => {
      if (contentData.value[section.section_key]) {
        contentData.value[section.section_key] = section.content
      }
    })
  } catch (error) {
    console.error('Error fetching content:', error)
    alert('Error loading content. Please refresh the page.')
  } finally {
    loading.value = false
  }
}

// Save section
const saveSection = async (sectionKey) => {
  saving.value = true

  try {
    const { error } = await supabase
      .from('page_content')
      .update({ content: contentData.value[sectionKey] })
      .eq('section_key', sectionKey)

    if (error) throw error

    // Show success message
    showSuccess.value = true
    setTimeout(() => {
      showSuccess.value = false
    }, 3000)
  } catch (error) {
    console.error('Error saving content:', error)
    alert('Error saving changes. Please try again.')
  } finally {
    saving.value = false
  }
}

// Load content on mount
onMounted(() => {
  fetchContent()
})
</script>
