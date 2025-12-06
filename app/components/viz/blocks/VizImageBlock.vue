<template>
    <div class="relative group my-8">
        <div class="max-w-5xl mx-auto relative flex justify-center">
            <img :src="content.src || 'https://placehold.co/1200x800'"
                class="max-h-[70vh] w-full object-cover rounded-2xl shadow-lg hover:shadow-2xl transition-shadow duration-300" />

            <div v-if="isEditor"
                class="absolute inset-0 flex items-center justify-center bg-black/60 backdrop-blur-sm opacity-0 group-hover:opacity-100 transition-all duration-300 rounded-2xl">
                <button @click="handleUpload"
                    class="bg-white px-6 py-3 rounded-full font-medium hover:bg-linear-to-r hover:from-bright-pink hover:to-blue-purple hover:text-white shadow-xl transform hover:scale-105 transition-all duration-200">
                    📸 Change Image
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
