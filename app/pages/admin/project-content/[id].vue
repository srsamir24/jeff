<template>
  <div class="h-[calc(100vh-64px)] flex flex-col bg-gray-50">
    <!-- Main Layout -->
    <!-- Header -->
    <div class="h-14 bg-white border-b border-gray-200 px-4 flex items-center justify-between flex-shrink-0 z-30">
      <div class="flex items-center gap-4">
        <NuxtLink to="/admin/projects" class="text-gray-500 hover:text-gray-900">
          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"></path></svg>
        </NuxtLink>
        <h1 class="text-lg font-bold text-gray-900">Project Content</h1>
        <div v-if="saving" class="text-xs text-gray-400 animate-pulse">Saving...</div>
      </div>
      
      <div class="flex items-center gap-3">
        <div class="flex items-center gap-2 px-2 py-1 bg-gray-100 rounded text-xs text-gray-500">
          <span>Zoom: {{ Math.round(zoom * 100) }}%</span>
          <button @click="zoom = 1" class="hover:text-gray-900">Reset</button>
        </div>
        
        <button 
          @click="saveContent" 
          class="px-4 py-2 bg-blue-600 text-white text-sm font-medium rounded-lg hover:bg-blue-700 transition-colors shadow-sm"
        >
          Save Changes
        </button>
      </div>
    </div>

    <!-- Builder Workspace -->
    <div class="flex-1 flex overflow-hidden relative">
      <!-- Left Sidebar (Layouts & Layers) -->
      <VizPresets 
        :blocks="contentBlocks" 
        :selected-ids="selectedIds"
        @select-block="handleSelectBlock"
      />

      <!-- Center Canvas -->
      <div class="flex-1 relative bg-gray-100 overflow-hidden">
        <VizCanvas v-model:blocks="contentBlocks" />
      </div>

      <!-- Right Sidebar (Tools & Properties) -->
      <div class="flex">
        <VizSidebar />
        <VizProperties :block="selectedBlock" />
      </div>
    </div>
  </div>
</template>

<script setup>
import VizSidebar from '~/components/viz/VizSidebar.vue'
import VizCanvas from '~/components/viz/VizCanvas.vue'
import VizProperties from '~/components/viz/VizProperties.vue'
import VizPresets from '~/components/viz/VizPresets.vue'
import { useCanvas } from '~/composables/useCanvas'

const route = useRoute()
const supabase = useSupabaseClient()
const toast = useToast()

const { zoom, selectedIds } = useCanvas()

const contentBlocks = ref([])
const loading = ref(true)
const saving = ref(false)

// Computed selected block
const selectedBlock = computed(() => {
  if (selectedIds.value.size !== 1) return null
  const id = Array.from(selectedIds.value)[0]
  return contentBlocks.value.find(b => b.id === id)
})

// Fetch project
const fetchProject = async () => {
  loading.value = true
  try {
    const { data, error } = await supabase
      .from('projects')
      .select('content_blocks')
      .eq('id', route.params.id)
      .single()

    if (error) throw error

    // Migration Logic: Convert old blocks to new format if needed
    if (data.content_blocks && Array.isArray(data.content_blocks)) {
      contentBlocks.value = data.content_blocks.map((block, index) => {
        // If it already has x/y, it's new format
        if (typeof block.x === 'number') return block

        // Otherwise migrate
        return {
          id: block.id || Math.random().toString(36).substr(2, 9),
          type: block.type,
          x: 20,
          y: 20 + (index * 120), // Stack them vertically
          width: 800,
          height: block.styles?.height === 'auto' ? 100 : parseInt(block.styles?.height || 100),
          rotation: 0,
          zIndex: 1,
          props: {
            text: block.content || '',
            src: block.url || '',
            style: {
              backgroundColor: block.styles?.background || 'transparent',
              color: block.color || '#000000',
              fontSize: parseInt(block.fontSize || 16),
              fontWeight: block.fontWeight || '400',
              textAlign: 'left',
              ...block.styles
            }
          },
          children: []
        }
      })
    }
  } catch (error) {
    console.error('Error fetching project:', error)
    toast.error('Error loading project')
  } finally {
    loading.value = false
  }
}

// Handle block selection from layers panel
const handleSelectBlock = (blockId) => {
  selectBlock(blockId)
}

// Handle preset application from dropdown
const handleApplyPreset = (presetData) => {
  // Directly add preset blocks to canvas at center
  const dropX = 50
  const dropY = 50
  
  // Use the canvas's createPresetLayout by simulating a drop
  const rect = { left: 0, top: 0 }
  const fakeDropEvent = {
    dataTransfer: { getData: () => JSON.stringify(presetData) },
    currentTarget: { getBoundingClientRect: () => rect },
    clientX: 650, // Adjusted for artboard position
    clientY: 450
  }
  
  // Manually trigger preset creation
  const layouts = {
    'hero': () => {
      contentBlocks.value.push(
        { id: Math.random().toString(36).substr(2, 9), type: 'container', x: dropX, y: dropY, width: 1100, height: 400, rotation: 0, zIndex: contentBlocks.value.length + 1, props: { text: '', src: '', style: { backgroundColor: '#FFFFFF', borderColor: '#E5E7EB', borderWidth: 1 } } },
        { id: Math.random().toString(36).substr(2, 9), type: 'text', x: dropX + 50, y: dropY + 150, width: 1000, height: 100, rotation: 0, zIndex: contentBlocks.value.length + 2, props: { text: 'Your Hero Title', src: '', style: { fontSize: 56, fontWeight: '700', color: '#000000', backgroundColor: 'transparent' } } }
      )
    },
    'two-column': () => {
      const gap = 20, colWidth = (1100 - gap) / 2
      contentBlocks.value.push(
        { id: Math.random().toString(36).substr(2, 9), type: 'container', x: dropX, y: dropY, width: colWidth, height: 400, rotation: 0, zIndex: contentBlocks.value.length + 1, props: { text: '', src: '', style: { backgroundColor: '#FFFFFF', borderColor: '#E5E7EB', borderWidth: 1 } } },
        { id: Math.random().toString(36).substr(2, 9), type: 'container', x: dropX + colWidth + gap, y: dropY, width: colWidth, height: 400, rotation: 0, zIndex: contentBlocks.value.length + 2, props: { text: '', src: '', style: { backgroundColor: '#FFFFFF', borderColor: '#E5E7EB', borderWidth: 1 } } }
      )
    }
  }
  
  layouts[presetData.layout]?.()
  toast.success('Layout added to canvas')
}

// Save content
const saveContent = async () => {
  saving.value = true
  try {
    const { error } = await supabase
      .from('projects')
      .update({ content_blocks: contentBlocks.value })
      .eq('id', route.params.id)

    if (error) throw error
    toast.success('Saved successfully!')
  } catch (error) {
    console.error('Error saving:', error)
    toast.error('Error saving content')
  } finally {
    saving.value = false
  }
}

onMounted(() => {
  fetchProject()
})
</script>
