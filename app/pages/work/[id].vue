<template>
  <div class="min-h-screen bg-white">
    <div v-if="loading" class="flex items-center justify-center h-screen">
      <div class="animate-spin rounded-full h-8 w-8 border-b-2 border-gray-900"></div>
    </div>

    <div v-else-if="error" class="flex items-center justify-center h-screen text-red-500">
      {{ error }}
    </div>

    <div v-else>
      <nav class="fixed top-0 left-0 right-0 z-50 p-6 flex justify-between items-start pointer-events-none">
        <NuxtLink to="/" class="text-2xl font-bold pointer-events-auto mix-blend-difference text-white">
          JEFF.
        </NuxtLink>
        <NuxtLink to="/work" class="text-sm font-medium hover:opacity-60 transition-opacity pointer-events-auto mix-blend-difference text-white">
          CLOSE
        </NuxtLink>
      </nav>
      <VizRenderer :blocks="contentBlocks" />
    </div>
  </div>
</template>

<script setup>
import VizRenderer from '~/components/viz/VizRenderer.vue'

const route = useRoute()
const supabase = useSupabaseClient()
const loading = ref(true)
const error = ref(null)
const contentBlocks = ref([])

onMounted(async () => {
  try {
    const { data, error: err } = await supabase.from('projects').select('*').eq('id', route.params.id).single()
    if (err) throw err
    if (data.content_blocks && Array.isArray(data.content_blocks)) {
      contentBlocks.value = data.content_blocks.map((block, index) => {
        if (typeof block.x === 'number') return block
        return {
          id: block.id,
          type: block.type,
          x: 20,
          y: 20 + (index * 120),
          width: 800,
          height: 100,
          rotation: 0,
          zIndex: 1,
          props: {
            text: block.content || '',
            src: block.url || '',
            style: {
              backgroundColor: block.styles?.background || 'transparent',
              color: block.color || '#000000',
              fontSize: parseInt(block.fontSize || 16),
              ...block.styles
            }
          }
        }
      })
    }
  } catch (e) {
    error.value = e.message
  } finally {
    loading.value = false
  }
})
</script>
