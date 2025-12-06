<template>
    <div class="relative group my-8 mx-auto max-w-5xl" :class="[
        content.bgColor ? `bg-${content.bgColor}` : '',
        content.bgGradientEnabled ? getBgGradientClasses(content.bgGradient) : '',
        content.padding ? `p-${content.padding}` : 'py-16 px-8',
        content.bgColor || content.bgGradientEnabled ? 'rounded-3xl shadow-lg' : ''
    ]">
        <div class="max-w-4xl mx-auto text-center">
            <h2 class="text-3xl md:text-5xl font-bold mb-6 outline-none" :class="[
                content.fontSize ? `text-${content.fontSize}` : '',
                content.textAlign ? `text-${content.textAlign}` : '',
                content.textColor && !content.gradientText ? `text-${content.textColor}` : '',
                content.fontWeight ? `font-${content.fontWeight}` : '',
                content.gradientText ? getGradientClasses(content.gradient || 'rainbow') + ' text-transparent bg-clip-text inline-block' : '',
                content.gradientAnimation && content.gradientText ? 'animate-gradient' : '',
                content.animation === 'pulse' ? 'animate-pulse' : '',
                content.animation === 'bounce' ? 'animate-bounce' : '',
                content.animation === 'fade-in' ? 'animate-fade-in' : '',
                content.animation === 'slide-in-left' ? 'animate-slide-in-left' : '',
                content.animation === 'slide-in-right' ? 'animate-slide-in-right' : '',
                (content.decorations || []).includes('underline') ? 'underline' : '',
                (content.decorations || []).includes('line-through') ? 'line-through' : '',
                (content.decorations || []).includes('highlight') ? 'bg-yellow-200' : '',
                (content.decorations || []).includes('uppercase') ? 'uppercase' : ''
            ]" :contenteditable="isEditor" @blur="updateTitle" v-html="content.title"></h2>
            <p class="text-lg md:text-xl text-gray-600 max-w-2xl mx-auto outline-none" :class="[
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
            ]" :contenteditable="isEditor" @blur="updateSubtitle" v-html="content.subtitle"></p>
        </div>
    </div>
</template>

<script setup>
const props = defineProps({
    content: { type: Object, default: () => ({ title: 'Project Title', subtitle: 'A brief description.' }) },
    isEditor: { type: Boolean, default: false }
})
const emit = defineEmits(['update', 'move-up', 'move-down', 'delete'])

const updateTitle = (e) => emit('update', { ...props.content, title: e.target.innerHTML })
const updateSubtitle = (e) => emit('update', { ...props.content, subtitle: e.target.innerHTML })

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
/* Reuse animation definitions */
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
