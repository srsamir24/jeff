<template>
  <div class="w-64 bg-white border-r border-gray-200 h-full flex flex-col overflow-y-auto">
    <!-- Tabs -->
    <div class="flex border-b border-gray-200">
      <button 
        @click="activeTab = 'layouts'"
        class="flex-1 px-4 py-3 text-sm font-medium transition-colors"
        :class="activeTab === 'layouts' ? 'text-blue-600 border-b-2 border-blue-600' : 'text-gray-500 hover:text-gray-700'"
      >
        Layouts
      </button>
      <button 
        @click="activeTab = 'layers'"
        class="flex-1 px-4 py-3 text-sm font-medium transition-colors"
        :class="activeTab === 'layers' ? 'text-blue-600 border-b-2 border-blue-600' : 'text-gray-500 hover:text-gray-700'"
      >
        Layers
      </button>
    </div>

    <!-- Layouts Tab -->
    <div v-if="activeTab === 'layouts'" class="flex-1 p-4 space-y-4">
      <!-- Headers Section -->
      <div>
        <h3 class="text-xs font-bold text-gray-500 uppercase mb-2">Headers</h3>
        <div class="space-y-2">
          <button 
            v-for="preset in headerPresets" 
            :key="preset.id"
            class="w-full p-2 bg-gradient-to-r from-blue-50 to-purple-50 border border-blue-200 rounded-lg text-left hover:border-blue-400 hover:shadow-md transition-all"
            draggable="true"
            @dragstart="handleDragStart(preset, $event)"
          >
            <div class="text-xs font-semibold text-gray-900 mb-1">{{ preset.name }}</div>
            <div class="h-6 flex gap-1">
              <div v-for="(col, i) in preset.columns" :key="i" class="bg-blue-200 rounded" :style="{ flex: col }"></div>
            </div>
          </button>
        </div>
      </div>

      <!-- Columns Section -->
      <div>
        <h3 class="text-xs font-bold text-gray-500 uppercase mb-2">Columns</h3>
        <div class="space-y-2">
          <button 
            v-for="preset in columnPresets" 
            :key="preset.id"
            class="w-full p-2 bg-gradient-to-r from-green-50 to-teal-50 border border-green-200 rounded-lg text-left hover:border-green-400 hover:shadow-md transition-all"
            draggable="true"
            @dragstart="handleDragStart(preset, $event)"
          >
            <div class="text-xs font-semibold text-gray-900 mb-1">{{ preset.name }}</div>
            <div class="h-6 flex gap-1">
              <div v-for="(col, i) in preset.columns" :key="i" class="bg-green-200 rounded" :style="{ flex: col }"></div>
            </div>
          </button>
        </div>
      </div>

      <!-- Grids Section -->
      <div>
        <h3 class="text-xs font-bold text-gray-500 uppercase mb-2">Grids</h3>
        <div class="space-y-2">
          <button 
            v-for="preset in gridPresets" 
            :key="preset.id"
            class="w-full p-2 bg-gradient-to-r from-purple-50 to-pink-50 border border-purple-200 rounded-lg text-left hover:border-purple-400 hover:shadow-md transition-all"
            draggable="true"
            @dragstart="handleDragStart(preset, $event)"
          >
            <div class="text-xs font-semibold text-gray-900 mb-1">{{ preset.name }}</div>
            <div class="h-6 flex gap-1">
              <div v-for="(col, i) in preset.columns" :key="i" class="bg-purple-200 rounded" :style="{ flex: col }"></div>
            </div>
          </button>
        </div>
      </div>

      <!-- Content Section -->
      <div>
        <h3 class="text-xs font-bold text-gray-500 uppercase mb-2">Content</h3>
        <div class="space-y-2">
          <button 
            v-for="preset in contentPresets" 
            :key="preset.id"
            class="w-full p-2 bg-gradient-to-r from-orange-50 to-yellow-50 border border-orange-200 rounded-lg text-left hover:border-orange-400 hover:shadow-md transition-all"
            draggable="true"
            @dragstart="handleDragStart(preset, $event)"
          >
            <div class="text-xs font-semibold text-gray-900 mb-1">{{ preset.name }}</div>
            <div class="h-6 flex gap-1">
              <div v-for="(col, i) in preset.columns" :key="i" class="bg-orange-200 rounded" :style="{ flex: col }"></div>
            </div>
          </button>
        </div>
      </div>
    </div>

    <!-- Layers Tab -->
    <div v-else class="flex-1 p-4">
      <div class="text-xs text-gray-500 mb-3">{{ blocks.length }} blocks</div>
      <div class="space-y-1">
        <button
          v-for="block in blocks"
          :key="block.id"
          @click="$emit('select-block', block.id)"
          class="w-full px-3 py-2 text-left text-xs rounded hover:bg-gray-100 transition-colors flex items-center justify-between"
          :class="selectedIds.has(block.id) ? 'bg-blue-50 text-blue-600 font-medium' : 'text-gray-700'"
        >
          <span class="flex items-center gap-2">
            <svg v-if="block.type === 'text'" class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h7"/></svg>
            <svg v-else-if="block.type === 'image'" class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"/></svg>
            <svg v-else class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 5a1 1 0 011-1h4a1 1 0 011 1v7a1 1 0 01-1 1H5a1 1 0 01-1-1V5z"/></svg>
            {{ block.type }} {{ block.id.substr(0, 4) }}
          </span>
          <span class="text-[10px] text-gray-400">{{ Math.round(block.x) }},{{ Math.round(block.y) }}</span>
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
const props = defineProps({
  blocks: { type: Array, default: () => [] },
  selectedIds: { type: Object, default: () => new Set() }
})

const emit = defineEmits(['select-block'])

const activeTab = ref('layouts')

const headerPresets = [
  { id: 'hero', name: 'Hero Section', columns: [1], layout: 'hero' },
  { id: 'header-cta', name: 'Header + CTA', columns: [2, 1], layout: 'header-cta' },
  { id: 'title-subtitle', name: 'Title + Subtitle', columns: [1], layout: 'title-subtitle' }
]

const columnPresets = [
  { id: 'two-column', name: 'Two Columns', columns: [1, 1], layout: 'two-column' },
  { id: 'three-column', name: 'Three Columns', columns: [1, 1, 1], layout: 'three-column' },
  { id: 'four-column', name: 'Four Columns', columns: [1, 1, 1, 1], layout: 'four-column' },
  { id: 'sidebar-left', name: 'Sidebar Left', columns: [1, 2], layout: 'sidebar-left' },
  { id: 'sidebar-right', name: 'Sidebar Right', columns: [2, 1], layout: 'sidebar-right' }
]

const gridPresets = [
  { id: 'card-grid', name: 'Card Grid', columns: [1, 1, 1], layout: 'card-grid' },
  { id: 'gallery', name: 'Image Gallery', columns: [1, 1, 1, 1], layout: 'gallery' },
  { id: 'feature-grid', name: 'Feature Grid', columns: [1, 1], layout: 'feature-grid' }
]

const contentPresets = [
  { id: 'text-image', name: 'Text + Image', columns: [1, 1], layout: 'text-image' },
  { id: 'image-text', name: 'Image + Text', columns: [1, 1], layout: 'image-text' },
  { id: 'testimonial', name: 'Testimonial', columns: [1], layout: 'testimonial' }
]

const handleDragStart = (preset, e) => {
  e.dataTransfer.setData('application/json', JSON.stringify({ 
    type: 'preset',
    layout: preset.layout,
    columns: preset.columns
  }))
  e.dataTransfer.effectAllowed = 'copy'
}
</script>

