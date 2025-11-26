<template>
  <NuxtLink :to="`/work/${projectId}`" class="group cursor-pointer block">
    <div :class="[
      'relative overflow-hidden rounded-xl shadow-lg aspect-4/3 transition-all duration-300',
      'group-hover:shadow-2xl group-hover:scale-[1.02]',
      !imageUrl && gradientClass
    ]">
      <!-- Project Image -->
      <img
        v-if="imageUrl"
        :src="imageUrl"
        :alt="title"
        class="w-full h-full object-cover"
        loading="lazy"
      />

      <!-- Hover Overlay -->
      <div class="absolute inset-0 bg-gray-900/0 group-hover:bg-gray-900/20 transition-colors duration-300 flex items-center justify-center">
        <div class="transform scale-0 group-hover:scale-100 transition-transform duration-200">
          <div class="bg-portfolio-white/95 rounded-2xl px-6 py-4 shadow-xl">
            <p class="text-blue-purple font-semibold">View Project</p>
          </div>
        </div>
      </div>
      <!-- Decorative element -->
      <div class="absolute top-4 right-4 w-12 h-12 bg-portfolio-white/20 rounded-full flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity duration-200">
        <svg class="w-6 h-6 text-portfolio-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14 5l7 7m0 0l-7 7m7-7H3"></path>
        </svg>
      </div>
    </div>
    <div class="mt-5">
      <h3 class="text-xl font-bold text-gray-900 group-hover:text-blue-purple transition-colors duration-200">{{ title }}</h3>
      <p class="text-gray-600 mt-1">{{ description }}</p>
      <div v-if="tags && tags.length > 0" class="flex items-center space-x-2 mt-3">
        <span
          v-for="tag in tags"
          :key="tag.label"
          :class="['px-3 py-1 text-xs rounded-full font-medium', tag.class]"
        >
          {{ tag.label }}
        </span>
      </div>
    </div>
  </NuxtLink>
</template>

<script setup>
defineProps({
  projectId: {
    type: String,
    required: true
  },
  title: {
    type: String,
    required: true
  },
  description: {
    type: String,
    required: true
  },
  imageUrl: {
    type: String,
    default: null
  },
  gradientClass: {
    type: String,
    default: 'bg-linear-to-br from-blue-purple to-light-blue'
  },
  tags: {
    type: Array,
    default: () => []
  }
})
</script>
