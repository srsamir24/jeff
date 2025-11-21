<template>
  <div class="relative w-full min-h-screen bg-gray-50">
    <!-- Artboard Container (Full width, max 1440px, centered) -->
    <div class="relative bg-white mx-auto" style="max-width: 1440px; min-height: 100vh;">
      <!-- Blocks -->
      <div 
        v-for="block in blocks"
        :key="block.id"
        class="absolute"
        :style="{
          left: `${block.x}px`,
          top: `${block.y}px`,
          width: `${block.width}px`,
          height: `${block.height}px`,
          transform: `rotate(${block.rotation || 0}deg)`,
          zIndex: block.zIndex || 1
        }"
      >
        <!-- Content Render -->
        <div 
          class="w-full h-full overflow-hidden"
          :style="getStyles(block)"
        >
          <!-- Text -->
          <div v-if="block.type === 'text'" class="w-full h-full" :style="getTextStyles(block)">
            {{ block.props.text }}
          </div>

          <!-- Image -->
          <img 
            v-else-if="block.type === 'image'" 
            :src="block.props.src" 
            :alt="block.props.alt"
            class="w-full h-full object-cover"
          />
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
const props = defineProps({
  blocks: { type: Array, default: () => [] }
})

const getStyles = (block) => {
  const s = block.props.style || {}
  return {
    backgroundColor: s.backgroundColor,
    borderRadius: s.borderRadius ? `${s.borderRadius}px` : undefined,
    borderWidth: s.borderWidth ? `${s.borderWidth}px` : undefined,
    borderColor: s.borderColor,
    borderStyle: s.borderWidth ? 'solid' : undefined,
    boxShadow: s.boxShadow,
    opacity: s.opacity
  }
}

const getTextStyles = (block) => {
  const s = block.props.style || {}
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
}
</script>
