<template>
  <component
    :is="getTag"
    :style="getStyles"
    class="transition-all"
  >
    <!-- Container: Render children -->
    <template v-if="block.type === 'container'">
      <BlockRenderer
        v-for="child in block.children"
        :key="child.id"
        :block="child"
      />
    </template>

    <!-- Text: Render content -->
    <template v-else-if="block.type === 'text'">
      {{ block.content }}
    </template>

    <!-- Image: Render image -->
    <img
      v-else-if="block.type === 'image' && block.url"
      :src="block.url"
      :alt="block.alt || 'Image'"
      class="w-full h-full rounded-lg"
      :style="{ objectFit: block.objectFit || 'cover' }"
    />

    <!-- Spacer: Empty div -->
    <div v-else-if="block.type === 'spacer'"></div>
  </component>
</template>

<script setup>
const props = defineProps({
  block: { type: Object, required: true }
})

const getTag = computed(() => {
  if (props.block.type === 'container') return 'div'
  if (props.block.type === 'text') return props.block.tag || 'p'
  if (props.block.type === 'image') return 'div'
  if (props.block.type === 'spacer') return 'div'
  return 'div'
})

const getStyles = computed(() => {
  const styles = { ...props.block.styles }
  
  // Add text-specific styles
  if (props.block.type === 'text') {
    styles.fontSize = props.block.fontSize || '16px'
    styles.color = props.block.color || '#000000'
    styles.fontWeight = props.block.fontWeight || 'normal'
  }

  // Mobile responsiveness
  if (typeof window !== 'undefined' && window.innerWidth < 768) {
    // On mobile, make containers stack vertically
    if (props.block.type === 'container' && styles.flexDirection === 'row') {
      styles.flexDirection = 'column'
    }
    // Reduce padding on mobile
    if (styles.padding && parseInt(styles.padding) > 16) {
      styles.padding = '16px'
    }
  }

  return styles
})
</script>
