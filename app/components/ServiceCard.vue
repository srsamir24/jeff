<template>
  <div class="group bg-portfolio-white dark:bg-[#0e0b1e] rounded-2xl p-6 md:p-8 transition-all hover:shadow-lg hover:-translate-y-0.5">
    <div
      :class="[
        'w-12 h-12 md:w-14 md:h-14 rounded-xl flex items-center justify-center mb-4 transition-transform group-hover:scale-110',
        iconBgClass
      ]"
    >
      <slot name="icon">
        <UIcon name="lucide:sparkles" class="w-6 h-6 md:w-7 md:h-7 text-portfolio-white" />
      </slot>
    </div>
    <h3 :class="['text-lg md:text-xl font-semibold text-neutral-900 dark:text-neutral-50 mb-2 transition-colors', hoverTextClass]">
      {{ title }}
    </h3>
    <p class="text-sm md:text-base text-neutral-500 dark:text-neutral-400 leading-relaxed">
      {{ description }}
    </p>
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
    default: ''
  },
  hoverTextClass: {
    type: String,
    default: 'group-hover:text-blue-purple'
  }
})
</script>
