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
