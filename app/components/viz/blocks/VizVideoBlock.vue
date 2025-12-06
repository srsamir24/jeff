<template>
    <div class="relative group my-8">
        <div class="max-w-5xl mx-auto">
            <div class="aspect-video bg-gray-900 rounded-2xl overflow-hidden shadow-xl hover:shadow-2xl transition-shadow duration-300 relative ring-2 ring-gray-200 hover:ring-blue-purple">
                <iframe v-if="content.url" :src="getEmbedUrl(content.url)" class="w-full h-full" frameborder="0"
                    allowfullscreen></iframe>
                <div v-else class="w-full h-full flex items-center justify-center text-gray-500 bg-gray-100">
                    <div class="text-center">
                        <span class="text-4xl mb-2 block">▶️</span>
                        <p class="font-medium">No video URL set</p>
                    </div>
                </div>
            </div>

            <div v-if="isEditor" class="mt-6 flex gap-4 justify-center">
                <input type="text" :value="content.url" @input="updateUrl" placeholder="🎬 Paste YouTube or Vimeo URL"
                    class="w-full max-w-xl px-6 py-3.5 border-2 border-gray-200 rounded-2xl text-sm focus:ring-2 focus:ring-blue-purple focus:border-blue-purple outline-none shadow-sm hover:border-light-blue transition-colors">
            </div>
        </div>
    </div>
</template>

<script setup>
const props = defineProps({
    content: { type: Object, default: () => ({ url: '' }) },
    isEditor: { type: Boolean, default: false }
})

const emit = defineEmits(['update', 'delete', 'move-up', 'move-down'])

const updateUrl = (e) => {
    emit('update', { ...props.content, url: e.target.value })
}

const getEmbedUrl = (url) => {
    if (!url) return ''
    // Simple YouTube parser
    if (url.includes('youtube.com') || url.includes('youtu.be')) {
        const videoId = url.split('v=')[1] || url.split('/').pop()
        return `https://www.youtube.com/embed/${videoId}`
    }
    return url
}
</script>
