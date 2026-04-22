<template>
  <div class="text-center p-6">
    <div :class="['text-4xl md:text-5xl font-bold mb-2', colorClass]">
      {{ value }}
    </div>
    <div class="text-sm text-neutral-500 dark:text-neutral-400 uppercase tracking-wider">
      {{ label }}
    </div>
  </div>
</template>

<script setup>
defineProps({
  value: {
    type: String,
    required: true
  },
  label: {
    type: String,
    required: true
  },
  colorClass: {
    type: String,
    default: 'text-blue-purple'
  }
})
</script>
