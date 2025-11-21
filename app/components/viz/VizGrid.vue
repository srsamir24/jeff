<template>
  <div 
    class="absolute inset-0 pointer-events-none" 
    :style="{ 
      backgroundSize: `${size * zoom}px ${size * zoom}px`,
      backgroundPosition: `${pan.x}px ${pan.y}px`,
      backgroundImage: `
        linear-gradient(to right, ${color} 1px, transparent 1px),
        linear-gradient(to bottom, ${color} 1px, transparent 1px)
      `,
      opacity: 0.5
    }"
  ></div>
</template>

<script setup>
defineProps({
  size: { type: Number, default: 20 },
  zoom: { type: Number, default: 1 },
  pan: { type: Object, default: () => ({ x: 0, y: 0 }) },
  color: { type: String, default: '#e5e7eb' }
})
</script>
