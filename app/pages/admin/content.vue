<template>
  <NuxtLayout name="admin">
    <div class="max-w-5xl mx-auto">
      <!-- Header Area -->
      <div class="mb-12">
        <h1 class="text-4xl font-bold tracking-tight text-white mb-2 font-display">System Content</h1>
        <p class="text-white/40 font-medium">Configure global site sections and interactive endpoints</p>
      </div>

      <!-- Loading State -->
      <div v-if="loading" class="flex flex-col items-center justify-center py-24">
        <div class="w-12 h-12 border-2 border-white/10 border-t-white rounded-full animate-spin mb-4"></div>
        <p class="text-white/40 font-medium animate-pulse">Fetching system state...</p>
      </div>

      <!-- Content Tabs & Forms -->
      <div v-else>
        <!-- Tab Navigation -->
        <div class="flex items-center gap-2 mb-12 p-1.5 bg-white/[0.03] backdrop-blur-3xl rounded-full w-fit">
          <button
            v-for="tab in tabs"
            :key="tab.key"
            @click="activeTab = tab.key"
            :class="[
              'px-8 py-3 rounded-full text-xs font-bold tracking-widest uppercase transition-all duration-500',
              activeTab === tab.key
                ? 'bg-white text-black shadow-2xl'
                : 'text-white/40 hover:text-white hover:bg-white/5'
            ]"
          >
            {{ tab.label }}
          </button>
        </div>

        <!-- Forms Container -->
        <div class="space-y-12 animate-in fade-in slide-in-from-bottom-4 duration-700">
          
          <!-- Hero Section Form -->
          <div v-if="activeTab === 'hero'" class="bg-white/[0.03] backdrop-blur-3xl rounded-[40px] p-10 border border-white/5">
            <div class="flex items-center justify-between mb-10">
              <div>
                <h2 class="text-2xl font-bold font-display text-white">Hero Identity</h2>
                <p class="text-[10px] uppercase tracking-widest text-white/20 font-bold mt-1">Primary Landing Configuration</p>
              </div>
              <div class="w-12 h-12 bg-white/5 rounded-2xl flex items-center justify-center text-white/20">
                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z" />
                </svg>
              </div>
            </div>

            <form @submit.prevent="saveSection('hero')" class="space-y-8">
              <div class="space-y-3">
                <label class="text-overline">Main Headline</label>
                <input v-model="contentData.hero.title" type="text"
                  class="w-full px-6 py-4 bg-white/5 rounded-2xl text-white text-lg font-bold focus:ring-1 focus:ring-white/20 outline-none border-none transition-all">
              </div>
              
              <div class="space-y-3">
                <label class="text-overline">Supporting Narrative</label>
                <textarea v-model="contentData.hero.subtitle" rows="3"
                  class="w-full px-6 py-4 bg-white/5 rounded-2xl text-white focus:ring-1 focus:ring-white/20 outline-none border-none transition-all resize-none"></textarea>
              </div>

              <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
                <div class="space-y-3">
                  <label class="text-overline">Interaction Label</label>
                  <input v-model="contentData.hero.ctaText" type="text"
                    class="w-full px-6 py-4 bg-white/5 rounded-2xl text-white focus:ring-1 focus:ring-white/20 outline-none border-none transition-all">
                </div>
                <div class="space-y-3">
                  <label class="text-overline">Routing Endpoint</label>
                  <input v-model="contentData.hero.ctaLink" type="text"
                    class="w-full px-6 py-4 bg-white/5 rounded-2xl text-white font-mono text-sm focus:ring-1 focus:ring-white/20 outline-none border-none transition-all">
                </div>
              </div>

              <div class="pt-6 flex justify-end">
                <button type="submit" :disabled="saving"
                  class="px-10 py-4 bg-white text-black rounded-full font-bold hover:bg-bright-pink hover:text-white transition-all duration-300 disabled:opacity-50">
                  {{ saving ? 'Synchronizing...' : 'Deploy Hero Updates' }}
                </button>
              </div>
            </form>
          </div>

          <!-- Stats Section Form -->
          <div v-if="activeTab === 'stats'" class="bg-white/[0.03] backdrop-blur-3xl rounded-[40px] p-10 border border-white/5">
                <div class="flex items-center justify-between mb-10">
              <div>
                <h2 class="text-2xl font-bold font-display text-white">Performance Metrics</h2>
                <p class="text-[10px] uppercase tracking-widest text-white/20 font-bold mt-1">Vibrancy and Achievements</p>
              </div>
              <div class="w-12 h-12 bg-white/5 rounded-2xl flex items-center justify-center text-white/20">
                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
                </svg>
              </div>
            </div>

            <form @submit.prevent="saveSection('stats')" class="space-y-10">
              <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
                <div v-for="(stat, index) in contentData.stats.stats" :key="index" 
                  class="bg-white/[0.02] rounded-[32px] p-8 border border-white/5 space-y-6">
                  <div class="flex items-center justify-between mb-2">
                    <span class="text-[10px] font-bold text-white/20 uppercase tracking-[0.3em]">Metric {{ index + 1 }}</span>
                    <div :class="['w-3 h-3 rounded-full shadow-[0_0_15px]', stat.colorClass.replace('text-', 'bg-')]"></div>
                  </div>
                  
                  <div class="space-y-4">
                    <div class="space-y-2">
                      <label class="text-[10px] uppercase tracking-widest text-white/40 font-bold ml-1">Data Value</label>
                      <input v-model="stat.value" type="text"
                        class="w-full px-5 py-3.5 bg-white/5 rounded-2xl text-white font-display text-xl font-bold focus:ring-1 focus:ring-white/20 outline-none border-none transition-all">
                    </div>
                    
                    <div class="space-y-2">
                      <label class="text-[10px] uppercase tracking-widest text-white/40 font-bold ml-1">Label</label>
                      <input v-model="stat.label" type="text"
                        class="w-full px-5 py-3.5 bg-white/5 rounded-2xl text-white text-sm focus:ring-1 focus:ring-white/20 outline-none border-none transition-all">
                    </div>

                    <div class="space-y-2">
                      <label class="text-[10px] uppercase tracking-widest text-white/40 font-bold ml-1">Aesthetic Accent</label>
                      <select v-model="stat.colorClass"
                        class="w-full px-5 py-3.5 bg-white/10 rounded-2xl text-white text-sm focus:ring-1 focus:ring-white/20 outline-none border-none appearance-none transition-all">
                        <option value="text-bright-pink">Neon Pink</option>
                        <option value="text-purple-500">Cyber Purple</option>
                        <option value="text-cyan-400">Glitch Cyan</option>
                        <option value="text-yellow-400">Solar Yellow</option>
                      </select>
                    </div>
                  </div>
                </div>
              </div>

              <div class="pt-4 flex justify-end">
                <button type="submit" :disabled="saving"
                  class="px-10 py-4 bg-white text-black rounded-full font-bold hover:bg-bright-pink hover:text-white transition-all duration-300 disabled:opacity-50">
                  {{ saving ? 'Synchronizing...' : 'Deploy Statistics' }}
                </button>
              </div>
            </form>
          </div>

          <!-- CTA Section Form -->
          <div v-if="activeTab === 'cta'" class="bg-white/[0.03] backdrop-blur-3xl rounded-[40px] p-10 border border-white/5">
             <div class="flex items-center justify-between mb-10">
              <div>
                <h2 class="text-2xl font-bold font-display text-white">Call to Action</h2>
                <p class="text-[10px] uppercase tracking-widest text-white/20 font-bold mt-1">Conversion Architecture</p>
              </div>
              <div class="w-12 h-12 bg-white/5 rounded-2xl flex items-center justify-center text-white/20">
                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 15l-2 5L9 9l11 4-5 2zm0 0l5 5" />
                </svg>
              </div>
            </div>

            <form @submit.prevent="saveSection('cta')" class="space-y-8">
              <div class="space-y-3">
                <label class="text-overline">Persuasion Title</label>
                <input v-model="contentData.cta.title" type="text"
                  class="w-full px-6 py-4 bg-white/5 rounded-2xl text-white text-lg font-bold focus:ring-1 focus:ring-white/20 outline-none border-none transition-all">
              </div>

              <div class="space-y-3">
                <label class="text-overline">Micro-copy</label>
                <textarea v-model="contentData.cta.subtitle" rows="3"
                  class="w-full px-6 py-4 bg-white/5 rounded-2xl text-white focus:ring-1 focus:ring-white/20 outline-none border-none transition-all resize-none"></textarea>
              </div>

              <div class="grid grid-cols-1 md:grid-cols-2 gap-10">
                <div class="space-y-6">
                   <h4 class="text-[10px] uppercase tracking-[0.3em] text-white/20 font-bold">Primary Trigger</h4>
                   <div class="space-y-4">
                      <input v-model="contentData.cta.primaryButtonText" type="text" placeholder="Label"
                        class="w-full px-5 py-3.5 bg-white/5 rounded-2xl text-white focus:ring-1 focus:ring-white/20 outline-none border-none transition-all">
                      <input v-model="contentData.cta.primaryButtonLink" type="text" placeholder="Route"
                        class="w-full px-5 py-3.5 bg-white/5 rounded-2xl text-white font-mono text-xs focus:ring-1 focus:ring-white/20 outline-none border-none transition-all">
                   </div>
                </div>

                <div class="space-y-6">
                   <h4 class="text-[10px] uppercase tracking-[0.3em] text-white/20 font-bold">Secondary Trigger</h4>
                   <div class="space-y-4">
                      <input v-model="contentData.cta.secondaryButtonText" type="text" placeholder="Label"
                        class="w-full px-5 py-3.5 bg-white/5 rounded-2xl text-white focus:ring-1 focus:ring-white/20 outline-none border-none transition-all">
                      <input v-model="contentData.cta.secondaryButtonLink" type="text" placeholder="Route"
                        class="w-full px-5 py-3.5 bg-white/5 rounded-2xl text-white font-mono text-xs focus:ring-1 focus:ring-white/20 outline-none border-none transition-all">
                   </div>
                </div>
              </div>

              <div class="pt-6 flex justify-end">
                <button type="submit" :disabled="saving"
                  class="px-10 py-4 bg-white text-black rounded-full font-bold hover:bg-bright-pink hover:text-white transition-all duration-300 disabled:opacity-50">
                  {{ saving ? 'Synchronizing...' : 'Deploy CTA Logic' }}
                </button>
              </div>
            </form>
          </div>
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
const toast = useAppToast()

// State
const loading = ref(true)
const saving = ref(false)
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
    toast.error('Error loading content. Please refresh the page.')
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

    toast.success('Changes saved successfully!')
  } catch (error) {
    console.error('Error saving content:', error)
    toast.error('Error saving changes. Please try again.')
  } finally {
    saving.value = false
  }
}

// Load content on mount
onMounted(() => {
  fetchContent()
})
</script>
