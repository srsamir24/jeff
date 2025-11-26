<template>
    <div class="relative group">
        <div class="max-w-6xl mx-auto">
            <div class="aspect-video bg-gray-900 rounded-2xl overflow-hidden shadow-2xl relative">
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
                <input type="text" :value="content.url" @input="updateUrl" placeholder="Paste YouTube or Vimeo URL"
                    class="w-full max-w-xl px-6 py-3 border border-gray-200 rounded-full text-sm focus:ring-2 focus:ring-blue-500 outline-none shadow-sm">
            </div>
        </div>

        <!-- Controls -->
        <div v-if="isEditor"
            class="absolute top-8 right-8 opacity-0 group-hover:opacity-100 transition-opacity flex gap-2 z-20">
            <button @click="$emit('move-up')"
                class="p-2 bg-white rounded-full shadow-lg hover:bg-gray-50 text-gray-600 border border-gray-100">↑</button>
            <button @click="$emit('move-down')"
                class="p-2 bg-white rounded-full shadow-lg hover:bg-gray-50 text-gray-600 border border-gray-100">↓</button>
            <button @click="$emit('delete')"
                class="p-2 bg-red-500 rounded-full shadow-lg hover:bg-red-600 text-white border border-red-600">✕</button>
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
