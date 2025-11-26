<template>
    <div class="w-full">
        <section v-for="(block, index) in content" :key="block.id" :class="getSectionClass(block, index)">
            <div class="container mx-auto px-6">
                <component :is="resolveComponent(block.type)" :content="block.props" :is-editor="false" />
            </div>
        </section>
    </div>
</template>

<script setup>
import VizHeroBlock from './blocks/VizHeroBlock.vue'
import VizTextBlock from './blocks/VizTextBlock.vue'
import VizImageBlock from './blocks/VizImageBlock.vue'
import VizSplitBlock from './blocks/VizSplitBlock.vue'
import VizGalleryBlock from './blocks/VizGalleryBlock.vue'
import VizQuoteBlock from './blocks/VizQuoteBlock.vue'
import VizVideoBlock from './blocks/VizVideoBlock.vue'

const props = defineProps({
    content: { type: Array, default: () => [] }
})

const resolveComponent = (type) => {
    switch (type) {
        case 'hero': return VizHeroBlock
        case 'text': return VizTextBlock
        case 'image': return VizImageBlock
        case 'split': return VizSplitBlock
        case 'gallery': return VizGalleryBlock
        case 'quote': return VizQuoteBlock
        case 'video': return VizVideoBlock
        default: return VizTextBlock
    }
}

// Alternate backgrounds like homepage
const getSectionClass = (block, index) => {
    const type = block.type

    // Check if block has isHero property set
    if (block.isHero) {
        return 'py-20 bg-linear-to-b from-light-blue/5 to-portfolio-white'
    }

    // Hero and Quote blocks get gradient by default
    if (type === 'hero' || type === 'quote') {
        return 'py-20 bg-linear-to-b from-light-blue/5 to-portfolio-white'
    }

    // Alternate between white and subtle gradient for other blocks
    if (index % 2 === 0) {
        return 'py-20 bg-portfolio-white'
    } else {
        return 'py-20 bg-linear-to-b from-light-blue/5 to-portfolio-white'
    }
}
</script>
