<template>
    <div class="relative group" :class="[
        content.bgColor ? `bg-${content.bgColor}` : '',
        content.bgGradientEnabled ? getBgGradientClasses(content.bgGradient) : '',
        content.padding ? `p-${content.padding}` : 'py-16'
    ]">
        <div class="max-w-6xl mx-auto">
            <div class="flex flex-col md:flex-row items-center gap-12" :class="{ 'md:flex-row-reverse': content.reverse }">
                <!-- Image Side -->
                <div class="w-full md:w-1/2 relative">
                    <img :src="content.src || 'https://placehold.co/800x600'"
                        class="w-full h-auto rounded-xl shadow-lg object-cover" />
                    <div v-if="isEditor"
                        class="absolute inset-0 flex items-center justify-center bg-black/50 opacity-0 group-hover:opacity-100 transition-opacity rounded-xl">
                        <button @click="$emit('upload')"
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
        </div>

        <!-- Controls -->
        <div v-if="isEditor"
            class="absolute top-8 right-8 opacity-0 group-hover:opacity-100 transition-opacity flex gap-2 z-20">
            <button @click="toggleReverse"
                class="p-2 bg-white rounded-full shadow-lg hover:bg-gray-50 text-gray-600 border border-gray-100"
                title="Swap sides">⇄</button>
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

const updateTitle = (e) => emit('update', { ...props.content, title: e.target.innerHTML })
const updateBody = (e) => emit('update', { ...props.content, body: e.target.innerHTML })
const toggleReverse = () => emit('update', { ...props.content, reverse: !props.content.reverse })

const getGradientClasses = (gradient) => {
    switch (gradient) {
        case 'rainbow': return 'bg-gradient-to-r from-blue-600 via-green-500 to-indigo-400'
        case 'sunset': return 'bg-gradient-to-r from-orange-500 via-red-500 to-pink-500'
        case 'ocean': return 'bg-gradient-to-r from-blue-500 to-cyan-400'
        case 'forest': return 'bg-gradient-to-r from-green-500 to-teal-500'
        case 'purple-dream': return 'bg-gradient-to-r from-purple-600 to-pink-500'
        case 'custom': return 'bg-gradient-to-r from-light-green via-bright-pink to-blue-purple'
        default: return 'bg-gradient-to-r from-blue-600 via-green-500 to-indigo-400'
    }
}

const getBgGradientClasses = (gradient) => {
    switch (gradient) {
        case 'purple-blue': return 'bg-gradient-to-br from-purple-600 to-blue-500'
        case 'pink-orange': return 'bg-gradient-to-br from-pink-500 to-orange-400'
        case 'green-blue': return 'bg-gradient-to-br from-green-500 to-blue-400'
        case 'blue-purple': return 'bg-gradient-to-br from-blue-purple to-blue-purple/80'
        case 'sunset-warm': return 'bg-gradient-to-br from-orange-500 via-red-500 to-pink-600'
        case 'ocean-breeze': return 'bg-gradient-to-br from-cyan-400 via-blue-500 to-indigo-600'
        case 'forest-mist': return 'bg-gradient-to-br from-green-400 via-teal-500 to-cyan-600'
        case 'berry-blast': return 'bg-gradient-to-br from-pink-500 via-purple-500 to-indigo-600'
        case 'cosmic-fusion': return 'bg-gradient-to-br from-purple-600 via-pink-500 to-orange-400'
        case 'peach-cream': return 'bg-gradient-to-br from-orange-300 via-pink-200 to-pink-100'
        case 'mint-dream': return 'bg-gradient-to-br from-green-300 via-cyan-300 to-blue-300'
        case 'lavender-sky': return 'bg-gradient-to-br from-purple-300 via-pink-300 to-blue-200'
        default: return 'bg-gradient-to-br from-purple-600 to-blue-500'
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
