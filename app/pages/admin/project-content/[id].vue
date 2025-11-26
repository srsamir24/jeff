<template>
  <div class="h-screen flex flex-col">
    <!-- Header -->
    <div class="h-14 border-b border-gray-200 bg-white flex items-center justify-between px-4 z-20">
      <div class="flex items-center gap-4">
        <NuxtLink to="/admin/projects" class="text-gray-500 hover:text-gray-900">
          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18" />
          </svg>
        </NuxtLink>
        <h1 class="font-bold text-gray-900">Content Editor</h1>
        <span v-if="lastSaved" class="text-xs text-gray-400">Last saved: {{ lastSaved }}</span>
      </div>

      <div class="flex items-center gap-2">
        <button @click="saveContent" :disabled="saving"
          class="px-4 py-2 bg-gray-900 text-white rounded-lg text-sm font-medium hover:bg-gray-800 transition-colors disabled:opacity-50 disabled:cursor-not-allowed flex items-center gap-2">
          <svg v-if="saving" class="animate-spin h-4 w-4 text-white" xmlns="http://www.w3.org/2000/svg" fill="none"
            viewBox="0 0 24 24">
            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
            <path class="opacity-75" fill="currentColor"
              d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z">
            </path>
          </svg>
          {{ saving ? 'Saving...' : 'Save Changes' }}
        </button>
      </div>
    </div>

    <!-- Editor -->
    <div class="flex-1 overflow-hidden">
      <VizEditor v-model="contentBlocks" />
    </div>
  </div>
</template>

<script setup>
import VizEditor from '~/components/viz/VizEditor.vue'

definePageMeta({
  middleware: 'admin',
  layout: false
})

const route = useRoute()
const client = useSupabaseClient()
const toast = useToast() // Assuming useToast composable exists
const projectId = route.params.id

const contentBlocks = ref([])
const saving = ref(false)
const lastSaved = ref(null)

// Load Data
onMounted(async () => {
  try {
    const { data, error } = await client
      .from('projects')
      .select('content_blocks')
      .eq('id', projectId)
      .single()

    if (error) throw error

    if (data?.content_blocks) {
      contentBlocks.value = Array.isArray(data.content_blocks) ? data.content_blocks : []
    }
  } catch (err) {
    console.error('Error loading content:', err)
    toast.error('Failed to load content')
  }
})

// Save Data
const saveContent = async () => {
  if (saving.value) return
  saving.value = true

  try {
    const { error } = await client
      .from('projects')
      .update({
        content_blocks: contentBlocks.value,
        updated_at: new Date().toISOString()
      })
      .eq('id', projectId)

    if (error) throw error

    lastSaved.value = new Date().toLocaleTimeString()
    toast.success('Changes saved successfully')
  } catch (err) {
    console.error('Error saving:', err)
    toast.error('Failed to save changes')
  } finally {
    saving.value = false
  }
}
</script>
