<template>
  <div 
    class="absolute select-none group cursor-move"
    :style="{
      left: `${block.x}px`,
      top: `${block.y}px`,
      width: `${block.width}px`,
      height: `${block.height}px`,
      transform: `rotate(${block.rotation || 0}deg)`,
      zIndex: block.zIndex || 1
    }"
    @mousedown.stop="$emit('mousedown', $event)"
  >
    <!-- Controls -->
    <div v-if="isSelected" class="absolute -top-8 left-0 flex items-center gap-1 bg-white border border-gray-200 rounded px-2 py-1 text-xs shadow-sm z-20">
      <span class="font-medium text-gray-700">{{ block.type }}</span>
      <button @click.stop="$emit('delete')" class="ml-2 p-1 text-red-500 hover:text-red-700 hover:bg-red-50 rounded transition-colors" title="Delete (Del)">
        <svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/></svg>
      </button>
    </div>

    <!-- Content Render -->
    <div 
      class="w-full h-full overflow-hidden transition-shadow"
      :class="[
        isSelected ? 'ring-2 ring-blue-500' : 'hover:ring-1 hover:ring-blue-300',
        block.type === 'container' ? 'bg-white' : ''
      ]"
      :style="getStyles"
    >
      <!-- Text -->
      <div v-if="block.type === 'text'" class="w-full h-full" :style="getTextStyles">
        {{ block.props.text || 'Double click to edit' }}
      </div>

      <!-- Image -->
      <img 
        v-else-if="block.type === 'image'" 
        :src="block.props.src || 'https://via.placeholder.com/150'" 
        class="w-full h-full object-cover pointer-events-none"
      />

      <!-- Container Children -->
      <slot />
    </div>

    <!-- Selection Handles -->
    <div v-if="isSelected" class="absolute inset-0 pointer-events-none">
      <!-- Resize Handles -->
      <div class="absolute -top-1 -left-1 w-2 h-2 bg-white border border-blue-500 pointer-events-auto cursor-nwse-resize" @mousedown.stop="$emit('resize', 'nw', $event)"></div>
      <div class="absolute -top-1 -right-1 w-2 h-2 bg-white border border-blue-500 pointer-events-auto cursor-nesw-resize" @mousedown.stop="$emit('resize', 'ne', $event)"></div>
      <div class="absolute -bottom-1 -left-1 w-2 h-2 bg-white border border-blue-500 pointer-events-auto cursor-nesw-resize" @mousedown.stop="$emit('resize', 'sw', $event)"></div>
      <div class="absolute -bottom-1 -right-1 w-2 h-2 bg-white border border-blue-500 pointer-events-auto cursor-nwse-resize" @mousedown.stop="$emit('resize', 'se', $event)"></div>
      
      <!-- Edges -->
      <div class="absolute -top-1 left-1/2 -translate-x-1/2 w-2 h-2 bg-white border border-blue-500 pointer-events-auto cursor-ns-resize" @mousedown.stop="$emit('resize', 'n', $event)"></div>
      <div class="absolute -bottom-1 left-1/2 -translate-x-1/2 w-2 h-2 bg-white border border-blue-500 pointer-events-auto cursor-ns-resize" @mousedown.stop="$emit('resize', 's', $event)"></div>
      <div class="absolute top-1/2 -translate-y-1/2 -left-1 w-2 h-2 bg-white border border-blue-500 pointer-events-auto cursor-ew-resize" @mousedown.stop="$emit('resize', 'w', $event)"></div>
      <div class="absolute top-1/2 -translate-y-1/2 -right-1 w-2 h-2 bg-white border border-blue-500 pointer-events-auto cursor-ew-resize" @mousedown.stop="$emit('resize', 'e', $event)"></div>
    </div>
  </div>
</template>

<script setup>
const props = defineProps({
  block: { type: Object, required: true },
  isSelected: { type: Boolean, default: false }
})

defineEmits(['mousedown', 'resize', 'delete'])

const getStyles = computed(() => {
  const s = props.block.props.style || {}
  return {
    backgroundColor: s.backgroundColor,
    borderRadius: s.borderRadius ? `${s.borderRadius}px` : undefined,
    borderWidth: s.borderWidth ? `${s.borderWidth}px` : undefined,
    borderColor: s.borderColor,
    borderStyle: s.borderWidth ? 'solid' : undefined,
    boxShadow: s.boxShadow,
    opacity: s.opacity
  }
})

const getTextStyles = computed(() => {
  const s = props.block.props.style || {}
  return {
    fontSize: s.fontSize ? `${s.fontSize}px` : undefined,
    fontWeight: s.fontWeight,
    color: s.color,
    textAlign: s.textAlign,
    fontFamily: s.fontFamily,
    display: 'flex',
    alignItems: s.alignItems || 'flex-start',
    justifyContent: s.justifyContent || 'flex-start'
  }
})
</script>
