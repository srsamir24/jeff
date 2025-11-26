<template>
    <div class="relative group" :class="[
        content.bgColor ? `bg-${content.bgColor}` : '',
        content.bgGradientEnabled ? getBgGradientClasses(content.bgGradient) : '',
        content.padding ? `p-${content.padding}` : 'py-16'
    ]">
        <div class="max-w-3xl mx-auto">
            <div class="prose prose-lg md:prose-xl prose-slate max-w-none outline-none" :class="[
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
            ]" :contenteditable="isEditor" @blur="updateContent" v-html="content.html"></div>
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
    content: { type: Object, default: () => ({ html: '<h3>Section Title</h3><p>Write your content here. You can add multiple paragraphs.</p>' }) },
    isEditor: { type: Boolean, default: false }
})

const emit = defineEmits(['update', 'delete', 'move-up', 'move-down'])

const updateContent = (event) => {
    emit('update', { ...props.content, html: event.target.innerHTML })
}

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
/* Reuse animation definitions from VizEditor (they are globally scoped in the editor, but we keep them here for isolated preview) */
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
