<template>
  <div 
    class="relative w-full h-full bg-gray-50 overflow-hidden cursor-default"
    @mousedown="handleMouseDown"
    @mousemove="handleMouseMove"
    @mouseup="handleMouseUp"
    @wheel.prevent="handleWheel"
    @drop.prevent="handleDrop"
    @dragover.prevent
  >
    <!-- Grid -->
    <VizGrid v-if="showGrid" :size="gridSize" :zoom="zoom" :pan="pan" />

    <!-- Artboard Frame (Fixed 1200x800 canvas) -->
    <div 
      class="absolute bg-white shadow-2xl"
      :style="{
        left: `${artboardX}px`,
        top: `${artboardY}px`,
        width: `${artboardWidth}px`,
        height: `${artboardHeight}px`,
        transform: `scale(${zoom})`,
        transformOrigin: 'top left'
      }"
    >
      <!-- Frame Label -->
      <div class="absolute -top-8 left-0 px-2 py-1 bg-gray-900 text-white text-xs rounded">
        Artboard - {{ artboardWidth }}×{{ artboardHeight }} (Website Viewport)
      </div>

      <!-- Blocks (constrained within artboard) -->
      <VizBlock
        v-for="block in blocks"
        :key="block.id"
        :block="block"
        :is-selected="selectedIds.has(block.id)"
        @mousedown="startDrag(block, $event)"
        @resize="(handle, e) => startResize(block, handle, e)"
        @delete="deleteBlock(block.id)"
      />
    </div>

    <!-- Selection Marquee -->
    <div 
      v-if="marquee"
      class="absolute border border-blue-500 bg-blue-500/10 pointer-events-none"
      :style="{
        left: `${Math.min(marquee.start.x, marquee.current.x)}px`,
        top: `${Math.min(marquee.start.y, marquee.current.y)}px`,
        width: `${Math.abs(marquee.current.x - marquee.start.x)}px`,
        height: `${Math.abs(marquee.current.y - marquee.start.y)}px`
      }"
    ></div>

    <!-- Zoom Controls -->
    <div class="absolute bottom-4 right-4 flex items-center gap-2 bg-white rounded-lg shadow-lg px-3 py-2 z-20">
      <button @click="zoom = Math.max(0.25, zoom - 0.25)" class="p-1 hover:bg-gray-100 rounded">
        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 12H4"/></svg>
      </button>
      <span class="text-xs font-medium text-gray-600 w-12 text-center">{{ Math.round(zoom * 100) }}%</span>
      <button @click="zoom = Math.min(2, zoom + 0.25)" class="p-1 hover:bg-gray-100 rounded">
        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/></svg>
      </button>
      <button @click="resetView" class="p-1 hover:bg-gray-100 rounded ml-2">
        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"/></svg>
      </button>
    </div>
  </div>
</template>

<script setup>
import VizGrid from './VizGrid.vue'
import VizBlock from './VizBlock.vue'
import { useCanvas } from '~/composables/useCanvas'

const props = defineProps({
  blocks: { type: Array, required: true }
})

const emit = defineEmits(['update:blocks', 'select'])

const { 
  zoom, pan, gridSize, showGrid, snapToGrid, selectedIds,
  snap, startPan, handlePan, stopPan, handleWheel, selectBlock, clearSelection 
} = useCanvas()

// Artboard settings (matches website viewport)
const artboardWidth = 1440 // Max content width
const artboardMinHeight = 1000 // Minimum height, can grow
const artboardX = computed(() => Math.max(20, pan.value.x)) // Small margin
const artboardY = computed(() => Math.max(20, pan.value.y))

// Calculate dynamic artboard height based on content
const artboardHeight = computed(() => {
  if (!props.blocks.length) return artboardMinHeight
  
  // Find the lowest block bottom edge
  const maxBottom = Math.max(
    artboardMinHeight,
    ...props.blocks.map(b => (b.y || 0) + (b.height || 0) + 100) // +100 for padding
  )
  
  return maxBottom
})

// Interaction State
const dragStart = ref(null)
const activeBlock = ref(null)
const activeAction = ref(null)
const resizeHandle = ref(null)
const marquee = ref(null)

// Constrain position to artboard bounds
const constrainToArtboard = (x, y, width, height) => {
  return {
    x: Math.max(0, Math.min(x, artboardWidth - width)),
    y: Math.max(0, Math.min(y, artboardHeight - height))
  }
}

// Reset view to center artboard
const resetView = () => {
  zoom.value = 1
  pan.value = { x: 0, y: 0 }
}

// Mouse Handlers
const handleMouseDown = (e) => {
  if (e.button === 1 || (e.button === 0 && e.spaceKey)) {
    activeAction.value = 'pan'
    startPan(e)
    return
  }

  if (e.target === e.currentTarget) {
    clearSelection()
    activeAction.value = 'marquee'
    marquee.value = {
      start: { x: e.clientX, y: e.clientY },
      current: { x: e.clientX, y: e.clientY }
    }
  }
}

const startDrag = (block, e) => {
  if (e.button !== 0) return
  e.stopPropagation()
  
  if (!selectedIds.value.has(block.id) && !e.shiftKey) {
    selectBlock(block.id)
  } else if (e.shiftKey) {
    selectBlock(block.id, true)
  }

  activeAction.value = 'drag'
  activeBlock.value = block
  dragStart.value = { 
    x: e.clientX, 
    y: e.clientY,
    blockX: block.x,
    blockY: block.y
  }
}

const startResize = (block, handle, e) => {
  e.stopPropagation()
  activeAction.value = 'resize'
  activeBlock.value = block
  resizeHandle.value = handle
  dragStart.value = {
    x: e.clientX,
    y: e.clientY,
    blockX: block.x,
    blockY: block.y,
    blockW: block.width,
    blockH: block.height
  }
}

const handleMouseMove = (e) => {
  if (activeAction.value === 'pan') {
    handlePan(e)
  } else if (activeAction.value === 'drag' && activeBlock.value) {
    const dx = e.clientX - dragStart.value.x
    const dy = e.clientY - dragStart.value.y
    
    let newX = dragStart.value.blockX + dx
    let newY = dragStart.value.blockY + dy

    if (snapToGrid.value) {
      newX = snap(newX)
      newY = snap(newY)
    }

    // Constrain to artboard
    const constrained = constrainToArtboard(newX, newY, activeBlock.value.width, activeBlock.value.height)
    activeBlock.value.x = constrained.x
    activeBlock.value.y = constrained.y
  } else if (activeAction.value === 'resize' && activeBlock.value) {
    const dx = e.clientX - dragStart.value.x
    const dy = e.clientY - dragStart.value.y
    const handle = resizeHandle.value

    let newX = dragStart.value.blockX
    let newY = dragStart.value.blockY
    let newW = dragStart.value.blockW
    let newH = dragStart.value.blockH

    if (handle.includes('e')) newW += dx
    if (handle.includes('w')) { newX += dx; newW -= dx }
    if (handle.includes('s')) newH += dy
    if (handle.includes('n')) { newY += dy; newH -= dy }

    if (snapToGrid.value) {
      if (handle.includes('w')) newX = snap(newX)
      if (handle.includes('n')) newY = snap(newY)
      newW = snap(newW)
      newH = snap(newH)
    }

    // Min dimensions
    if (newW < gridSize.value) newW = gridSize.value
    if (newH < gridSize.value) newH = gridSize.value

    // Constrain to artboard
    const constrained = constrainToArtboard(newX, newY, newW, newH)
    activeBlock.value.x = constrained.x
    activeBlock.value.y = constrained.y
    activeBlock.value.width = Math.min(newW, artboardWidth - constrained.x)
    activeBlock.value.height = Math.min(newH, artboardHeight - constrained.y)
  } else if (activeAction.value === 'marquee') {
    marquee.value.current = { x: e.clientX, y: e.clientY }
  }
}

const handleDrop = (e) => {
  console.log('Drop event detected', e.clientX, e.clientY)
  const dropX = (e.clientX - artboardX.value) / zoom.value
  const dropY = (e.clientY - artboardY.value) / zoom.value

  try {
    const rawData = e.dataTransfer.getData('application/json')
    console.log('Drop data:', rawData)
    if (!rawData) {
      console.error('No data in drop event')
      return
    }

    const data = JSON.parse(rawData)
    
    if (data.type === 'preset' && data.layout) {
      // Handle preset
      console.log('Creating preset layout:', data.layout)
      createPresetLayout(data, dropX, dropY)
    } else {
      // Handle single block
      console.log('Creating single block:', data.type)
      const block = {
        id: crypto.randomUUID(),
        type: data.type,
        x: dropX,
        y: dropY,
        width: data.type === 'container' ? 300 : 200,
        height: data.type === 'container' ? 200 : 50,
        rotation: 0,
        zIndex: 1,
        props: {
          text: data.tag ? `Heading ${data.tag.replace('h', '')}` : 'Text Block',
          style: {
            fontSize: data.fontSize || 16,
            backgroundColor: data.type === 'container' ? '#f3f4f6' : 'transparent',
            borderColor: '#000000',
            borderWidth: 0,
            color: '#000000',
            borderRadius: 0,
            boxShadow: '',
            opacity: 1,
            textAlign: 'left',
            fontWeight: '400',
            fontFamily: 'Inter, sans-serif'
          }
        },
        children: []
      }

      // Default image
      if (data.type === 'image') {
        block.width = 300
        block.height = 200
        block.props.src = 'https://placehold.co/600x400'
        block.props.alt = 'Placeholder Image'
      }

      props.blocks.push(block)
      // Select the new block
      selectBlock(block.id)
      console.log('Block created:', block.id)
    }
  } catch (err) {
    console.error('Drop error:', err)
  }
}

const createPresetLayout = (preset, dropX, dropY) => {
  const layouts = {
    'hero': () => {
      const container = createContainer(dropX, dropY, 1400, 500)
      const title = createText(dropX + 50, dropY + 200, 1300, 100, 'Your Hero Title', 'h1', 56)
      props.blocks.push(container, title)
    },
    'header-cta': () => {
      const title = createText(dropX, dropY, 900, 80, 'Main Heading', 'h1', 48)
      const cta = createContainer(dropX + 950, dropY + 20, 400, 40)
      const ctaText = createText(dropX + 970, dropY + 25, 360, 30, 'Get Started', 'p', 18)
      props.blocks.push(title, cta, ctaText)
    },
    'title-subtitle': () => {
      const title = createText(dropX, dropY, 1400, 80, 'Main Title', 'h1', 48)
      const subtitle = createText(dropX, dropY + 100, 1400, 40, 'Supporting subtitle text', 'p', 20)
      props.blocks.push(title, subtitle)
    },
    'two-column': () => {
      const gap = 20
      const colWidth = (1400 - gap) / 2
      const col1 = createContainer(dropX, dropY, colWidth, 400)
      const col2 = createContainer(dropX + colWidth + gap, dropY, colWidth, 400)
      props.blocks.push(col1, col2)
    },
    'three-column': () => {
      const gap = 20
      const colWidth = (1400 - gap * 2) / 3
      const col1 = createContainer(dropX, dropY, colWidth, 400)
      const col2 = createContainer(dropX + colWidth + gap, dropY, colWidth, 400)
      const col3 = createContainer(dropX + (colWidth + gap) * 2, dropY, colWidth, 400)
      props.blocks.push(col1, col2, col3)
    },
    'four-column': () => {
      const gap = 20
      const colWidth = (1400 - gap * 3) / 4
      for (let i = 0; i < 4; i++) {
        const col = createContainer(dropX + (colWidth + gap) * i, dropY, colWidth, 300)
        props.blocks.push(col)
      }
    },
    'sidebar-left': () => {
      const gap = 20
      const sidebar = createContainer(dropX, dropY, 350, 400)
      const main = createContainer(dropX + 350 + gap, dropY, 1030, 400)
      props.blocks.push(sidebar, main)
    },
    'sidebar-right': () => {
      const gap = 20
      const main = createContainer(dropX, dropY, 1030, 400)
      const sidebar = createContainer(dropX + 1030 + gap, dropY, 350, 400)
      props.blocks.push(main, sidebar)
    },
    'card-grid': () => {
      const gap = 20
      const cardWidth = (1400 - gap * 2) / 3
      const cardHeight = 350
      for (let i = 0; i < 3; i++) {
        const card = createContainer(dropX + (cardWidth + gap) * i, dropY, cardWidth, cardHeight)
        const img = createImage(dropX + (cardWidth + gap) * i, dropY, cardWidth, 200)
        const title = createText(dropX + (cardWidth + gap) * i + 20, dropY + 220, cardWidth - 40, 40, 'Card Title', 'h3', 20)
        props.blocks.push(card, img, title)
      }
    },
    'gallery': () => {
      const gap = 20
      const imgWidth = (1400 - gap * 3) / 4
      const imgHeight = 250
      for (let row = 0; row < 2; row++) {
        for (let col = 0; col < 4; col++) {
          const img = createImage(
            dropX + (imgWidth + gap) * col,
            dropY + (imgHeight + gap) * row,
            imgWidth,
            imgHeight
          )
          props.blocks.push(img)
        }
      }
    },
    'feature-grid': () => {
      const gap = 20
      const boxWidth = (1400 - gap) / 2
      const boxHeight = 250
      for (let row = 0; row < 2; row++) {
        for (let col = 0; col < 2; col++) {
          const box = createContainer(
            dropX + (boxWidth + gap) * col,
            dropY + (boxHeight + gap) * row,
            boxWidth,
            boxHeight
          )
          const title = createText(
            dropX + (boxWidth + gap) * col + 20,
            dropY + (boxHeight + gap) * row + 20,
            boxWidth - 40,
            40,
            'Feature Title',
            'h3',
            24
          )
          props.blocks.push(box, title)
        }
      }
    },
    'text-image': () => {
      const gap = 20
      const halfWidth = (1400 - gap) / 2
      const textBox = createContainer(dropX, dropY, halfWidth, 400)
      const title = createText(dropX + 20, dropY + 100, halfWidth - 40, 60, 'Heading', 'h2', 36)
      const para = createText(dropX + 20, dropY + 180, halfWidth - 40, 100, 'Description text goes here', 'p', 16)
      const img = createImage(dropX + halfWidth + gap, dropY, halfWidth, 400)
      props.blocks.push(textBox, title, para, img)
    },
    'image-text': () => {
      const gap = 20
      const halfWidth = (1400 - gap) / 2
      const img = createImage(dropX, dropY, halfWidth, 400)
      const textBox = createContainer(dropX + halfWidth + gap, dropY, halfWidth, 400)
      const title = createText(dropX + halfWidth + gap + 20, dropY + 100, halfWidth - 40, 60, 'Heading', 'h2', 36)
      const para = createText(dropX + halfWidth + gap + 20, dropY + 180, halfWidth - 40, 100, 'Description text', 'p', 16)
      props.blocks.push(img, textBox, title, para)
    },
    'testimonial': () => {
      const box = createContainer(dropX, dropY, 700, 250)
      const quote = createText(dropX + 40, dropY + 40, 620, 120, '"This is an amazing testimonial quote that shows social proof."', 'p', 18)
      const author = createText(dropX + 40, dropY + 180, 620, 30, '— Customer Name', 'p', 14)
      props.blocks.push(box, quote, author)
    }
  }

  layouts[preset.layout]?.()
}

const createContainer = (x, y, w, h) => ({
  id: Math.random().toString(36).substr(2, 9),
  type: 'container',
  x, y, width: w, height: h,
  rotation: 0,
  zIndex: props.blocks.length + 1,
  props: {
    text: '',
    src: '',
    style: {
      backgroundColor: '#FFFFFF',
      borderColor: '#E5E7EB',
      borderWidth: 1,
      fontSize: 16,
      color: '#000000'
    }
  }
})

const createText = (x, y, w, h, text, tag, size) => ({
  id: Math.random().toString(36).substr(2, 9),
  type: 'text',
  x, y, width: w, height: h,
  rotation: 0,
  zIndex: props.blocks.length + 1,
  props: {
    text,
    src: '',
    style: {
      backgroundColor: 'transparent',
      fontSize: size,
      fontWeight: tag.startsWith('h') ? '700' : '400',
      color: '#000000',
      textAlign: 'left'
    }
  }
})

const createImage = (x, y, w, h) => ({
  id: Math.random().toString(36).substr(2, 9),
  type: 'image',
  x, y, width: w, height: h,
  rotation: 0,
  zIndex: props.blocks.length + 1,
  props: {
    text: '',
    src: 'https://via.placeholder.com/400x300',
    style: {
      backgroundColor: '#F3F4F6',
      fontSize: 16,
      color: '#000000'
    }
  }
})

const deleteBlock = (id) => {
  const index = props.blocks.findIndex(b => b.id === id)
  if (index > -1) {
    props.blocks.splice(index, 1)
    clearSelection()
  }
}

const handleKeyboard = (e) => {
  // Delete selected block
  if ((e.key === 'Delete' || e.key === 'Backspace') && selectedIds.value.size > 0) {
    e.preventDefault()
    selectedIds.value.forEach(id => deleteBlock(id))
  }
}

const handleMouseUp = () => {
  activeAction.value = null
  activeBlock.value = null
  resizeHandle.value = null
  marquee.value = null
  stopPan()
}

onMounted(() => {
  document.addEventListener('keydown', handleKeyboard)
})

onUnmounted(() => {
  document.removeEventListener('keydown', handleKeyboard)
})
</script>

