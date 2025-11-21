<template>
  <div class="w-16 bg-white border-r border-gray-200 h-full flex flex-col items-center py-4 gap-4 z-20 relative shadow-sm">
    <!-- Tools -->
    <div class="flex flex-col gap-2 w-full px-2">
      <button 
        v-for="tool in tools" 
        :key="tool.id"
        class="p-2 rounded-lg transition-all group relative"
        :class="activeTool === tool.id ? 'bg-blue-50 text-blue-600' : 'text-gray-500 hover:bg-gray-100 hover:text-gray-900'"
        @click="activeTool = tool.id"
        :title="tool.label"
        :draggable="tool.type ? 'true' : 'false'"
        @dragstart="handleDragStart(tool, $event)"
      >
        <component :is="tool.icon" class="w-6 h-6" />
        
        <!-- Tooltip -->
        <div class="absolute left-full ml-2 px-2 py-1 bg-gray-900 text-white text-xs rounded opacity-0 group-hover:opacity-100 pointer-events-none whitespace-nowrap z-50 transition-opacity">
          {{ tool.label }}
        </div>
      </button>
    </div>

    <div class="flex-1"></div>

    <!-- Bottom Actions -->
    <div class="flex flex-col gap-2 w-full px-2 border-t pt-4">
      <button class="p-2 text-gray-500 hover:text-gray-900 rounded-lg" title="Undo">
        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 10h10a8 8 0 018 8v2M3 10l6 6m-6-6l6-6"/></svg>
      </button>
      <button class="p-2 text-gray-500 hover:text-gray-900 rounded-lg" title="Redo">
        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 10h-10a8 8 0 00-8 8v2M21 10l-6 6m6-6l-6-6"/></svg>
      </button>
    </div>
  </div>
</template>

<script setup>
const activeTool = ref('select')

const IconSelect = {
  render: () => h('svg', { fill: 'none', viewBox: '0 0 24 24', stroke: 'currentColor', strokeWidth: 2 }, [
    h('path', { strokeLinecap: 'round', strokeLinejoin: 'round', d: 'M15 15l-2 5L9 9l11 4-5 2zm0 0l5 5M7.188 2.239l.777 2.897M5.136 7.965l-2.898-.777M13.95 4.05l-2.122 2.122m-5.657 5.656l-2.12 2.122' })
  ])
}

const IconH1 = {
  render: () => h('svg', { fill: 'none', viewBox: '0 0 24 24', stroke: 'currentColor', strokeWidth: 2 }, [
    h('text', { x: 4, y: 18, fontSize: 16, fontWeight: 'bold', fill: 'currentColor' }, 'H1')
  ])
}

const IconH2 = {
  render: () => h('svg', { fill: 'none', viewBox: '0 0 24 24', stroke: 'currentColor', strokeWidth: 2 }, [
    h('text', { x: 4, y: 18, fontSize: 16, fontWeight: 'bold', fill: 'currentColor' }, 'H2')
  ])
}

const IconH3 = {
  render: () => h('svg', { fill: 'none', viewBox: '0 0 24 24', stroke: 'currentColor', strokeWidth: 2 }, [
    h('text', { x: 4, y: 18, fontSize: 16, fontWeight: 'bold', fill: 'currentColor' }, 'H3')
  ])
}

const IconText = {
  render: () => h('svg', { fill: 'none', viewBox: '0 0 24 24', stroke: 'currentColor', strokeWidth: 2 }, [
    h('path', { strokeLinecap: 'round', strokeLinejoin: 'round', d: 'M4 6h16M4 12h16M4 18h7' })
  ])
}

const IconImage = {
  render: () => h('svg', { fill: 'none', viewBox: '0 0 24 24', stroke: 'currentColor', strokeWidth: 2 }, [
    h('path', { strokeLinecap: 'round', strokeLinejoin: 'round', d: 'M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z' })
  ])
}

const IconContainer = {
  render: () => h('svg', { fill: 'none', viewBox: '0 0 24 24', stroke: 'currentColor', strokeWidth: 2 }, [
    h('rect', { x: 3, y: 3, width: 18, height: 18, rx: 2, strokeLinecap: 'round', strokeLinejoin: 'round' })
  ])
}

const tools = [
  { id: 'select', label: 'Select (V)', icon: IconSelect },
  { id: 'h1', label: 'Heading 1', icon: IconH1, type: 'text', tag: 'h1', fontSize: 48 },
  { id: 'h2', label: 'Heading 2', icon: IconH2, type: 'text', tag: 'h2', fontSize: 36 },
  { id: 'h3', label: 'Heading 3', icon: IconH3, type: 'text', tag: 'h3', fontSize: 24 },
  { id: 'paragraph', label: 'Paragraph', icon: IconText, type: 'text', tag: 'p', fontSize: 16 },
  { id: 'image', label: 'Image (I)', icon: IconImage, type: 'image' },
  { id: 'container', label: 'Container (F)', icon: IconContainer, type: 'container' },
]

const handleDragStart = (tool, e) => {
  console.log('Drag start:', tool.type)
  if (!tool.type) return // Select tool doesn't drag
  
  const blockData = {
    type: tool.type,
    tag: tool.tag,
    fontSize: tool.fontSize
  }
  
  e.dataTransfer.setData('application/json', JSON.stringify(blockData))
  e.dataTransfer.effectAllowed = 'copy'
}
</script>

