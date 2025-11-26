<template>
    <div class="relative group">
        <div class="max-w-7xl mx-auto relative flex justify-center">
            <img :src="content.src || 'https://placehold.co/1200x800'"
                class="max-h-[85vh] w-auto object-contain rounded-xl shadow-2xl" />

            <div v-if="isEditor"
                class="absolute inset-0 flex items-center justify-center bg-black/50 opacity-0 group-hover:opacity-100 transition-opacity rounded-xl">
                <button @click="handleUpload"
                    class="bg-white px-6 py-3 rounded-full font-medium hover:bg-gray-100 shadow-lg transform hover:scale-105 transition-all">
                    Change Image
                </button>
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
    content: { type: Object, default: () => ({ src: '' }) },
    isEditor: { type: Boolean, default: false }
})

const emit = defineEmits(['update', 'delete', 'move-up', 'move-down', 'upload'])

const { pickAndUploadFile } = useSupabaseStorage()

const handleUpload = async () => {
    const url = await pickAndUploadFile()
    if (url) {
        emit('update', { ...props.content, src: url })
    }
}
</script>
