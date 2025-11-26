<template>
    <div class="relative group">
        <div class="max-w-7xl mx-auto grid grid-cols-1 md:grid-cols-3 gap-8">
            <div v-for="(img, index) in content.images" :key="index" class="relative aspect-square group/item">
                <img :src="img || 'https://placehold.co/400x400'"
                    class="w-full h-full object-cover rounded-xl shadow-lg transition-transform hover:scale-[1.02]" />

                <div v-if="isEditor"
                    class="absolute inset-0 flex items-center justify-center bg-black/50 opacity-0 group-hover/item:opacity-100 transition-opacity gap-2 rounded-xl">
                    <button @click="$emit('upload', index)"
                        class="bg-white p-3 rounded-full hover:bg-gray-100 shadow-lg" title="Change Image">
                        🖼️
                    </button>
                    <button @click="removeImage(index)"
                        class="bg-red-500 text-white p-3 rounded-full hover:bg-red-600 shadow-lg" title="Remove">
                        ✕
                    </button>
                </div>
            </div>

            <!-- Add Button -->
            <div v-if="isEditor"
                class="aspect-square border-2 border-dashed border-gray-300 rounded-xl flex items-center justify-center cursor-pointer hover:border-blue-500 hover:bg-blue-50 transition-all group/add"
                @click="addImage">
                <span class="text-4xl text-gray-300 group-hover/add:text-blue-500 transition-colors">+</span>
            </div>
        </div>
    </div>
</template>

<script setup>
const props = defineProps({
    content: { type: Object, default: () => ({ images: ['https://placehold.co/400x400', 'https://placehold.co/400x400'] }) },
    isEditor: { type: Boolean, default: false }
})

const emit = defineEmits(['update', 'delete', 'move-up', 'move-down', 'upload'])

const { pickAndUploadFile } = useSupabaseStorage()

const addImage = async () => {
    if (props.isEditor) {
        // Upload new image to Supabase
        const url = await pickAndUploadFile()
        if (url) {
            const newImages = [...props.content.images, url]
            emit('update', { ...props.content, images: newImages })
        }
    } else {
        // Fallback for non-editor mode
        const newImages = [...props.content.images, 'https://placehold.co/400x400']
        emit('update', { ...props.content, images: newImages })
    }
}

const removeImage = (index) => {
    const newImages = [...props.content.images]
    newImages.splice(index, 1)
    emit('update', { ...props.content, images: newImages })
}

const handleUpload = async (index) => {
    // Upload replacement image to Supabase
    const url = await pickAndUploadFile()
    if (url) {
        const newImages = [...props.content.images]
        newImages[index] = url
        emit('update', { ...props.content, images: newImages })
    }
}

// Expose handleUpload for parent component
defineExpose({ handleUpload })
</script>
