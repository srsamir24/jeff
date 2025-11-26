<template>
  <div class="group bg-portfolio-white p-8 rounded-2xl shadow-md hover:shadow-2xl transition-all duration-300 border border-gray-100 hover:-translate-y-1" :class="hoverBorderClass">
    <div :class="[
      'w-16 h-16 rounded-xl flex items-center justify-center mb-6',
      'group-hover:scale-110 transition-transform duration-300 shadow-lg',
      iconBgClass
    ]">
      <slot name="icon">
        <svg class="w-8 h-8 text-portfolio-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path>
        </svg>
      </slot>
    </div>
    <h3 :class="['text-xl font-bold text-gray-900 mb-3 transition-colors', hoverTextClass]">
      {{ title }}
    </h3>
    <p class="text-gray-600 leading-relaxed">{{ description }}</p>
  </div>
</template>

<script setup>
defineProps({
  title: {
    type: String,
    required: true
  },
  description: {
    type: String,
    required: true
  },
  iconBgClass: {
    type: String,
    default: 'bg-linear-to-br from-blue-purple to-blue-purple/70'
  },
  hoverBorderClass: {
    type: String,
    default: 'hover:border-blue-purple/20'
  },
  hoverTextClass: {
    type: String,
    default: 'group-hover:text-blue-purple'
  }
})
</script>
