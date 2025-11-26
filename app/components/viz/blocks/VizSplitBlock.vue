<template>
    <div class="relative group" :class="[
        content.bgColor ? `bg-${content.bgColor}` : '',
        content.bgGradientEnabled ? getBgGradientClasses(content.bgGradient) : '',
        content.padding ? `p-${content.padding}` : 'py-16'
    ]">
        <div class="max-w-6xl mx-auto">
            <div class="flex flex-col md:flex-row items-center gap-12"
                :class="{ 'md:flex-row-reverse': content.reverse }">
                <!-- Image Side -->
                <div class="w-full md:w-1/2 relative">
                    <img :src="content.src || 'https://placehold.co/800x600'"
                        class="w-full h-auto rounded-xl shadow-lg object-cover" />
                    <div v-if="isEditor"
                        class="absolute inset-0 flex items-center justify-center bg-black/50 opacity-0 group-hover:opacity-100 transition-opacity rounded-xl">
                        <button @click="handleUpload"
                            class="bg-white px-4 py-2 rounded-full font-medium hover:bg-gray-100 shadow-lg">
                            Change Image
                        </button>
                    </div>
                </div>

                <!-- Text Side -->
                <div class="w-full md:w-1/2">
                    <component :is="content.headingTag || 'h3'" class="text-2xl md:text-3xl font-bold mb-4" :class="[
                        content.fontSize ? `text-${content.fontSize}` : '',
                        content.textAlign ? `text-${content.textAlign}` : '',
                        content.textColor && !content.gradientText ? `text-${content.textColor}` : '',
                        content.fontWeight ? `font-${content.fontWeight}` : '',
                        content.gradientText ? getGradientClasses(content.gradient || 'rainbow') + ' text-transparent bg-clip-text inline-block' : '',
                        content.animation === 'pulse' ? 'animate-pulse' : '',
                        content.animation === 'bounce' ? 'animate-bounce' : '',
                        content.animation === 'fade-in' ? 'animate-fade-in' : '',
                        content.animation === 'slide-in-left' ? 'animate-slide-in-left' : '',
                        content.animation === 'slide-in-right' ? 'animate-slide-in-right' : '',
                        (content.decorations || []).includes('underline') ? 'underline' : '',
                        (content.decorations || []).includes('line-through') ? 'line-through' : '',
                        (content.decorations || []).includes('highlight') ? 'bg-yellow-200' : '',
                        (content.decorations || []).includes('uppercase') ? 'uppercase' : ''
                    ]" :contenteditable="isEditor" @blur="updateTitle" v-html="content.title"></component>

                    <div class="prose prose-lg prose-slate max-w-none" :class="[
                        content.fontSize ? `text-${content.fontSize}` : '',
                        content.textAlign ? `text-${content.textAlign}` : '',
                        content.textColor && !content.gradientText ? `text-${content.textColor}` : '',
                        content.animation === 'fade-in' ? 'animate-fade-in' : '',
                        content.animation === 'slide-in-left' ? 'animate-slide-in-left' : '',
                        content.animation === 'slide-in-right' ? 'animate-slide-in-right' : ''
                    ]" :contenteditable="isEditor" @blur="updateBody" v-html="content.body"></div>
                </div>
            </div>

            <!-- Swap Button (appears on hover in the middle) -->
            <div v-if="isEditor"
                class="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 opacity-0 group-hover:opacity-100 transition-all duration-300 z-30">
                <button @click="toggleReverse"
                    class="bg-white p-3 rounded-full shadow-xl hover:shadow-2xl hover:scale-110 transition-all duration-200 border-2 border-gray-200 hover:border-blue-500"
                    title="Swap image and text sides">
                    <svg class="w-6 h-6 text-gray-700" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                            d="M8 7h12m0 0l-4-4m4 4l-4 4m0 6H4m0 0l4 4m-4-4l4-4" />
                    </svg>
                </button>
            </div>
        </div>
    </div>
</template>

<script setup>
const props = defineProps({
    content: {
        type: Object,
        default: () => ({
            title: 'Feature Title',
            body: '<p>Describe this feature or aspect of your project.</p>',
            src: 'https://placehold.co/800x600',
            reverse: false,
            headingTag: 'h3'
        })
    },
    isEditor: { type: Boolean, default: false }
})

const emit = defineEmits(['update', 'delete', 'move-up', 'move-down', 'upload'])

const { pickAndUploadFile } = useSupabaseStorage()

const updateTitle = (e) => emit('update', { ...props.content, title: e.target.innerHTML })
const updateBody = (e) => emit('update', { ...props.content, body: e.target.innerHTML })
const toggleReverse = () => emit('update', { ...props.content, reverse: !props.content.reverse })

const handleUpload = async () => {
    const url = await pickAndUploadFile()
    if (url) {
        emit('update', { ...props.content, src: url })
    }
}

const getGradientClasses = (gradient) => {
    switch (gradient) {
        case 'rainbow': return 'bg-gradient-to-r from-blue-600 via-green-500 to-indigo-400'
        case 'custom': return 'bg-gradient-to-r from-light-green via-bright-pink to-blue-purple'
        case 'sunset': return 'bg-gradient-to-r from-bright-pink via-lighter-pink to-light-blue'
        case 'ocean': return 'bg-gradient-to-r from-light-blue to-blue-purple'
        case 'forest': return 'bg-gradient-to-r from-light-green to-light-blue'
        case 'purple-dream': return 'bg-gradient-to-r from-blue-purple to-bright-pink'
        default: return 'bg-gradient-to-r from-blue-600 via-green-500 to-indigo-400'
    }
}

const getBgGradientClasses = (gradient) => {
    switch (gradient) {
        case 'blue-purple': return 'bg-gradient-to-br from-blue-purple to-blue-purple/80'
        case 'pink-green': return 'bg-gradient-to-br from-bright-pink to-light-green'
        case 'purple-pink': return 'bg-gradient-to-br from-blue-purple to-bright-pink'
        case 'green-blue': return 'bg-gradient-to-br from-light-green to-light-blue'
        case 'sunset-warm': return 'bg-gradient-to-br from-bright-pink via-lighter-pink to-light-blue'
        case 'ocean-breeze': return 'bg-gradient-to-br from-light-blue via-blue-purple to-bright-pink'
        case 'forest-mist': return 'bg-gradient-to-br from-light-green via-light-blue to-blue-purple'
        case 'berry-blast': return 'bg-gradient-to-br from-lighter-pink via-bright-pink to-blue-purple'
        case 'cosmic-fusion': return 'bg-gradient-to-br from-blue-purple via-bright-pink to-light-green'
        default: return 'bg-gradient-to-br from-blue-purple to-blue-purple/80'
    }
}
</script>

<style scoped>
@keyframes fadeIn {
    from {
        opacity: 0;
        transform: translateY(10px);
    }

    to {
        opacity: 1;
        transform: translateY(0);
    }
}

@keyframes slideInLeft {
    from {
        opacity: 0;
        transform: translateX(-3rem);
    }

    to {
        opacity: 1;
        transform: translateX(0);
    }
}

@keyframes slideInRight {
    from {
        opacity: 0;
        transform: translateX(3rem);
    }

    to {
        opacity: 1;
        transform: translateX(0);
    }
}

.animate-fade-in {
    animation: fadeIn 1.2s cubic-bezier(0.4, 0, 0.2, 1);
}

.animate-slide-in-left {
    animation: slideInLeft 1s cubic-bezier(0.34, 1.56, 0.64, 1);
}

.animate-slide-in-right {
    animation: slideInRight 1s cubic-bezier(0.34, 1.56, 0.64, 1);
}
</style>
