<template>
  <NuxtLink
    :to="`/work/${projectId}`"
    class="group block relative w-full mb-12 last:mb-0"
  >
    <!-- Image Container -->
    <div class="relative w-full aspect-[16/10] overflow-hidden bg-charcoal/5 dark:bg-paper/5">
      <img
        v-if="imageUrl"
        :src="imageUrl"
        :alt="title"
        loading="lazy"
        class="w-full h-full object-cover transition-transform duration-1000 cubic-bezier(0.16, 1, 0.3, 1) group-hover:scale-[1.03]"
      />
      <div
        v-else
        class="w-full h-full flex items-center justify-center bg-gradient-to-br from-neon-teal/20 to-electric-violet/20"
      >
        <UIcon name="lucide:image" class="w-12 h-12 opacity-20" />
      </div>

      <!-- Sophisticated Hover Overlay (Minimalist) -->
      <div class="absolute inset-0 opacity-0 group-hover:opacity-100 transition-opacity duration-500 bg-charcoal/10" />
      
      <!-- Magnetic-style Button or Tag -->
      <div class="absolute bottom-8 right-8 overflow-hidden">
        <div class="translate-y-full group-hover:translate-y-0 transition-transform duration-500 cubic-bezier(0.16, 1, 0.3, 1)">
          <div class="bg-paper text-charcoal px-6 py-3 rounded-full font-display text-[11px] font-bold uppercase tracking-widest shadow-2xl">
            View Project
          </div>
        </div>
      </div>
    </div>

    <!-- Content -->
    <div class="mt-8 flex flex-col md:flex-row md:items-start justify-between gap-4">
      <div class="max-w-2xl">
        <h3 class="font-display text-2xl md:text-3xl font-semibold tracking-tighter mb-3">
          {{ title }}
        </h3>
        <p class="font-body text-sm text-charcoal/60 dark:text-paper/60 line-clamp-2 leading-relaxed">
          {{ description }}
        </p>
      </div>
      
      <!-- Tags as overline -->
      <div v-if="tags && tags.length > 0" class="flex flex-wrap gap-2 md:text-right">
        <span
          v-for="tag in tags"
          :key="tag.label"
          class="text-overline opacity-40 text-[9px]"
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
  tags: {
    type: Array,
    default: () => []
  }
})
</script>
