<template>
  <div>
    <VizViewer :content="contentBlocks" />
  </div>
</template>

<script setup>
import VizViewer from '~/components/viz/VizViewer.vue'

const route = useRoute()
const client = useSupabaseClient()
const projectId = route.params.id

const contentBlocks = ref([])

// Load Data
const { data } = await useAsyncData(`project-content-${projectId}`, async () => {
  const { data } = await client
    .from('projects')
    .select('content_blocks')
    .eq('id', projectId)
    .single()
  return data
})

if (data.value?.content_blocks) {
  contentBlocks.value = Array.isArray(data.value.content_blocks)
    ? data.value.content_blocks
    : []
}
</script>
