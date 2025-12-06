<template>
    <div class="relative group my-8 mx-auto max-w-4xl" :class="[
        content.bgColor ? `bg-${content.bgColor}` : 'bg-linear-to-br from-portfolio-white to-gray-50',
        content.padding ? `p-${content.padding}` : 'py-12 px-10',
        'rounded-3xl shadow-lg border-l-4 border-bright-pink'
    ]">
        <div class="mx-auto" :class="content.textAlign ? `text-${content.textAlign}` : 'text-center'">
            <!-- Decorative Quote Mark -->
            <div class="text-7xl text-bright-pink/20 font-serif leading-none mb-4">"</div>

            <blockquote class="text-2xl md:text-3xl font-serif italic mb-8 outline-none leading-relaxed -mt-12" :class="[
                content.fontSize ? `text-${content.fontSize}` : '',
                content.textColor && !content.gradientText ? `text-${content.textColor}` : 'text-gray-800',
                content.fontWeight ? `font-${content.fontWeight}` : 'font-medium',
                content.gradientText ? getGradientClasses(content.gradient || 'rainbow') + ' text-transparent bg-clip-text inline-block' : '',
                content.animation === 'pulse' ? 'animate-pulse' : '',
                content.animation === 'bounce' ? 'animate-bounce' : '',
                content.animation === 'fade-in' ? 'animate-fade-in' : '',
                content.animation === 'slide-in-left' ? 'animate-slide-in-left' : '',
                content.animation === 'slide-in-right' ? 'animate-slide-in-right' : ''
            ]" :contenteditable="isEditor" @blur="updateContent('text', $event)">
                {{ content.text }}
            </blockquote>

            <cite class="text-lg not-italic tracking-wide outline-none flex items-center justify-center gap-2" :class="[
                content.textColor && !content.gradientText ? `text-${content.textColor}` : 'text-bright-pink',
                content.fontWeight ? `font-${content.fontWeight}` : 'font-semibold'
            ]" :contenteditable="isEditor" @blur="updateContent('author', $event)">
                <span class="w-8 h-0.5 bg-bright-pink"></span>
                {{ content.author }}
                <span class="w-8 h-0.5 bg-bright-pink"></span>
            </cite>
        </div>
    </div>
</template>

<script setup>
const props = defineProps({
    content: { type: Object, default: () => ({ text: 'Design is intelligence made visible.', author: 'Alina Wheeler' }) },
    isEditor: { type: Boolean, default: false }
})

const emit = defineEmits(['update', 'delete', 'move-up', 'move-down'])

const updateContent = (key, event) => {
    emit('update', { ...props.content, [key]: event.target.innerText })
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
</script>
