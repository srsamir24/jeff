<template>
    <div class="relative group" :class="[
        content.bgColor ? `bg-${content.bgColor}` : '',
        content.padding ? `p-${content.padding}` : 'py-16'
    ]">
        <div class="max-w-4xl mx-auto" :class="content.textAlign ? `text-${content.textAlign}` : 'text-center'">
            <blockquote class="text-3xl md:text-5xl font-serif italic mb-8 outline-none leading-tight" :class="[
                content.fontSize ? `text-${content.fontSize}` : '',
                content.textColor && !content.gradientText ? `text-${content.textColor}` : 'text-gray-900',
                content.fontWeight ? `font-${content.fontWeight}` : '',
                content.gradientText ? getGradientClasses(content.gradient || 'rainbow') + ' text-transparent bg-clip-text inline-block' : '',
                content.animation === 'pulse' ? 'animate-pulse' : '',
                content.animation === 'bounce' ? 'animate-bounce' : '',
                content.animation === 'fade-in' ? 'animate-fade-in' : '',
                content.animation === 'slide-in-left' ? 'animate-slide-in-left' : '',
                content.animation === 'slide-in-right' ? 'animate-slide-in-right' : ''
            ]" :contenteditable="isEditor" @blur="updateContent('text', $event)">
                "{{ content.text }}"
            </blockquote>

            <cite class="text-xl not-italic block tracking-wide outline-none" :class="[
                content.textColor && !content.gradientText ? `text-${content.textColor}` : 'text-gray-500',
                content.fontWeight ? `font-${content.fontWeight}` : 'font-medium'
            ]" :contenteditable="isEditor" @blur="updateContent('author', $event)">
                — {{ content.author }}
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
