<template>
    <div class="relative group my-8">
        <div class="max-w-5xl mx-auto grid grid-cols-1 md:grid-cols-3 gap-6">
            <div v-for="(img, index) in content.images" :key="index" class="relative aspect-square group/item overflow-hidden rounded-2xl shadow-md hover:shadow-xl transition-all duration-300">
                <img :src="img || 'https://placehold.co/400x400'"
                    class="w-full h-full object-cover transition-transform duration-500 hover:scale-110" />

                <div v-if="isEditor"
                    class="absolute inset-0 flex items-center justify-center bg-black/60 backdrop-blur-sm opacity-0 group-hover/item:opacity-100 transition-all duration-300 gap-3 rounded-2xl">
                    <button @click="$emit('upload', index)"
                        class="bg-white p-3 rounded-xl hover:bg-linear-to-r hover:from-light-blue hover:to-blue-purple hover:text-white shadow-lg transform hover:scale-110 transition-all duration-200" title="Change Image">
                        🖼️
                    </button>
                    <button @click="removeImage(index)"
                        class="bg-bright-pink text-white p-3 rounded-xl hover:bg-red-600 shadow-lg transform hover:scale-110 transition-all duration-200" title="Remove">
                        ✕
                    </button>
                </div>
            </div>

            <!-- Add Button -->
            <div v-if="isEditor"
                class="aspect-square border-2 border-dashed border-gray-300 rounded-2xl flex items-center justify-center cursor-pointer hover:border-bright-pink hover:bg-linear-to-br hover:from-bright-pink/10 hover:to-blue-purple/10 transition-all duration-300 group/add shadow-sm hover:shadow-md"
                @click="addImage">
                <div class="text-center">
                    <span class="text-5xl text-gray-400 group-hover/add:text-bright-pink transition-colors duration-200 block mb-2">+</span>
                    <span class="text-xs text-gray-500 group-hover/add:text-bright-pink transition-colors duration-200">Add Image</span>
                </div>
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
</script>
