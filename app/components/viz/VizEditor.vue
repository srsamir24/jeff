<template>
    <div class="flex h-full bg-gray-100">
        <!-- Left Sidebar: Block Presets -->
        <div class="w-64 bg-white border-r border-gray-200 flex flex-col">
            <div class="p-4 border-b border-gray-200">
                <h2 class="text-sm font-semibold text-gray-700 uppercase tracking-wide">Add Blocks</h2>
            </div>
            <div class="flex-1 overflow-y-auto p-3 space-y-2">
                <!-- Block Presets -->
                <div v-for="preset in blockPresets" :key="preset.type"
                    class="group p-3 bg-gray-50 hover:bg-blue-50 border border-gray-200 hover:border-blue-300 rounded-lg cursor-pointer transition-all"
                    draggable="true" @dragstart="handleDragStart(preset, $event)" @click="addBlock(preset.type)">
                    <div class="flex items-center gap-3">
                        <div class="w-10 h-10 rounded-lg flex items-center justify-center text-xl"
                            :class="preset.iconBg">
                            {{ preset.icon }}
                        </div>
                        <div>
                            <p class="font-medium text-gray-800 text-sm">{{ preset.label }}</p>
                            <p class="text-xs text-gray-500">{{ preset.description }}</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Center: Canvas Preview -->
        <div class="flex-1 flex flex-col overflow-hidden">
            <!-- Toolbar -->
            <div class="bg-white border-b border-gray-200 px-4 py-2 flex items-center justify-between">
                <div class="flex items-center gap-2">
                    <span class="text-sm text-gray-500">{{ blocks.length }} blocks</span>
                </div>
                <div class="flex items-center gap-2">
                    <button @click="previewMode = !previewMode" class="px-3 py-1.5 text-sm rounded-lg transition-colors"
                        :class="previewMode ? 'bg-blue-500 text-white' : 'bg-gray-100 text-gray-700 hover:bg-gray-200'">
                        {{ previewMode ? 'Exit Preview' : 'Preview' }}
                    </button>
                </div>
            </div>

            <!-- Canvas Area -->
            <div class="flex-1 overflow-y-auto p-6" @dragover.prevent @drop="handleCanvasDrop">
                <div class="max-w-4xl mx-auto bg-white rounded-xl shadow-lg min-h-[600px]"
                    :class="{ 'ring-2 ring-blue-300 ring-dashed': isDragging }">
                    <!-- Empty State -->
                    <div v-if="blocks.length === 0"
                        class="h-96 flex flex-col items-center justify-center text-gray-400">
                        <svg class="w-16 h-16 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                                d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10" />
                        </svg>
                        <p class="text-lg font-medium">Drag blocks here to start</p>
                        <p class="text-sm">or click a block type from the left panel</p>
                    </div>

                    <!-- Block List -->
                    <div v-else class="divide-y divide-gray-100">
                        <div v-for="(block, index) in blocks" :key="block.id" class="relative group"
                            :class="{ 'ring-2 ring-blue-500 ring-inset': selectedBlockIndex === index && !previewMode }"
                            @click="!previewMode && selectBlock(index)">
                            <!-- Block Controls -->
                            <div v-if="selectedBlockIndex === index && !previewMode"
                                class="absolute top-2 right-2 z-20 flex items-center gap-1 bg-white rounded-lg shadow-lg border border-gray-200 p-1">
                                <button @click.stop="moveBlock(index, -1)" :disabled="index === 0"
                                    class="p-1.5 rounded hover:bg-gray-100 disabled:opacity-30 disabled:cursor-not-allowed"
                                    title="Move Up">
                                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                            d="M5 15l7-7 7 7" />
                                    </svg>
                                </button>
                                <button @click.stop="moveBlock(index, 1)" :disabled="index === blocks.length - 1"
                                    class="p-1.5 rounded hover:bg-gray-100 disabled:opacity-30 disabled:cursor-not-allowed"
                                    title="Move Down">
                                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                            d="M19 9l-7 7-7-7" />
                                    </svg>
                                </button>
                                <button @click.stop="duplicateBlock(index)" class="p-1.5 rounded hover:bg-gray-100"
                                    title="Duplicate">
                                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                            d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z" />
                                    </svg>
                                </button>
                                <div class="w-px h-4 bg-gray-200"></div>
                                <button @click.stop="deleteBlock(index)"
                                    class="p-1.5 rounded hover:bg-red-100 text-red-500" title="Delete">
                                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                            d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                                    </svg>
                                </button>
                            </div>

                            <!-- Block Component -->
                            <component :is="blockComponents[block.type]" :content="block.props"
                                :is-editor="!previewMode"
                                @update="(newProps: Record<string, any>) => updateBlockProps(index, newProps)"
                                @upload="triggerUpload(block.id)" />
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Right Sidebar: Style Panel -->
        <div class="w-80 bg-white border-l border-gray-200 flex flex-col" v-if="selectedBlock && !previewMode">
            <div class="p-4 border-b border-gray-200 flex items-center justify-between">
                <h2 class="text-sm font-semibold text-gray-700 uppercase tracking-wide">Style</h2>
                <span class="text-xs px-2 py-1 bg-gray-100 rounded-full text-gray-600 capitalize">{{ selectedBlock.type
                }}</span>
            </div>

            <div class="flex-1 overflow-y-auto p-4 space-y-2">
                <!-- Typography Section -->
                <div class="border border-gray-200 rounded-lg overflow-hidden">
                    <button @click="expandedSections.typography = !expandedSections.typography"
                        class="w-full px-4 py-3 bg-gray-50 hover:bg-gray-100 flex items-center justify-between transition-colors">
                        <h3 class="text-xs font-semibold text-gray-700 uppercase tracking-wide">Typography</h3>
                        <svg class="w-4 h-4 text-gray-500 transition-transform"
                            :class="{ 'rotate-180': expandedSections.typography }" fill="none" stroke="currentColor"
                            viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
                        </svg>
                    </button>

                    <div v-show="expandedSections.typography" class="p-4 space-y-4">

                        <!-- Font Size -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Font Size</label>
                            <div class="grid grid-cols-5 gap-1">
                                <button v-for="size in fontSizes" :key="size.value"
                                    @click="updateStyle('fontSize', size.value)"
                                    class="px-2 py-1.5 text-xs rounded border transition-colors"
                                    :class="selectedBlock.props.fontSize === size.value ? 'bg-blue-500 text-white border-blue-500' : 'bg-white text-gray-700 border-gray-300 hover:border-blue-300'">
                                    {{ size.label }}
                                </button>
                            </div>
                        </div>

                        <!-- Text Align -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Text Align</label>
                            <div class="grid grid-cols-4 gap-1">
                                <button v-for="align in textAligns" :key="align.value"
                                    @click="updateStyle('textAlign', align.value)"
                                    class="p-2 rounded border transition-colors flex items-center justify-center"
                                    :class="selectedBlock.props.textAlign === align.value ? 'bg-blue-500 text-white border-blue-500' : 'bg-white text-gray-700 border-gray-300 hover:border-blue-300'">
                                    <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20"
                                        v-html="align.icon"></svg>
                                </button>
                            </div>
                        </div>

                        <!-- Text Color -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Text Color</label>
                            <div class="flex flex-wrap gap-2">
                                <button v-for="color in textColors" :key="color.value"
                                    @click="updateStyle('textColor', color.value)"
                                    class="w-8 h-8 rounded-full border-2 transition-transform hover:scale-110"
                                    :class="[color.class, selectedBlock.props.textColor === color.value ? 'ring-2 ring-blue-500 ring-offset-2' : 'border-gray-200']"
                                    :title="color.label">
                                </button>
                            </div>
                        </div>

                        <!-- Gradient Text Toggle -->
                        <div>
                            <label class="flex items-center justify-between cursor-pointer">
                                <span class="text-sm font-medium text-gray-700">Gradient Text</span>
                                <button @click="updateStyle('gradientText', !selectedBlock.props.gradientText)"
                                    class="relative w-11 h-6 rounded-full transition-colors"
                                    :class="selectedBlock.props.gradientText ? 'bg-blue-500' : 'bg-gray-300'">
                                    <span
                                        class="absolute top-0.5 left-0.5 w-5 h-5 bg-white rounded-full shadow transition-transform"
                                        :class="{ 'translate-x-5': selectedBlock.props.gradientText }"></span>
                                </button>
                            </label>
                        </div>

                        <!-- Gradient Presets for Text -->
                        <div v-if="selectedBlock.props.gradientText" class="space-y-2">
                            <label class="block text-sm font-medium text-gray-700">Text Gradient</label>
                            <div class="grid grid-cols-2 gap-2">
                                <button v-for="gradient in textGradients" :key="gradient.value"
                                    @click="updateStyle('gradient', gradient.value)"
                                    class="h-10 rounded-lg border-2 transition-transform hover:scale-105 flex items-center justify-center text-xs font-medium"
                                    :class="[gradient.class, selectedBlock.props.gradient === gradient.value ? 'ring-2 ring-blue-500 ring-offset-2' : 'border-gray-200']">
                                    <span class="text-transparent bg-clip-text" :class="gradient.class">{{
                                        gradient.label
                                        }}</span>
                                </button>
                            </div>
                        </div>

                        <!-- Font Weight -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Font Weight</label>
                            <div class="grid grid-cols-4 gap-1">
                                <button v-for="weight in fontWeights" :key="weight.value"
                                    @click="updateStyle('fontWeight', weight.value)"
                                    class="px-2 py-1.5 text-xs rounded border transition-colors"
                                    :class="selectedBlock.props.fontWeight === weight.value ? 'bg-blue-500 text-white border-blue-500' : 'bg-white text-gray-700 border-gray-300 hover:border-blue-300'">
                                    {{ weight.label }}
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Spacing Section -->
            <div class="border border-gray-200 rounded-lg overflow-hidden">
                <button @click="expandedSections.spacing = !expandedSections.spacing"
                    class="w-full px-4 py-3 bg-gray-50 hover:bg-gray-100 flex items-center justify-between transition-colors">
                    <h3 class="text-xs font-semibold text-gray-700 uppercase tracking-wide">Spacing</h3>
                    <svg class="w-4 h-4 text-gray-500 transition-transform"
                        :class="{ 'rotate-180': expandedSections.spacing }" fill="none" stroke="currentColor"
                        viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
                    </svg>
                </button>

                <div v-show="expandedSections.spacing" class="p-4 space-y-4">

                    <!-- Padding -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Padding</label>
                        <div class="grid grid-cols-5 gap-1">
                            <button v-for="pad in paddings" :key="pad.value" @click="updateStyle('padding', pad.value)"
                                class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                                <option value="h1">H1 - Main Title</option>
                                <option value="h2">H2 - Section</option>
                                <option value="h3">H3 - Subsection</option>
                                <option value="h4">H4 - Small</option>
                                <option value="p">Paragraph</option>
                                <option value="div">Div (No semantic)</option>
                                </select>
                        </div>
                    </div>

                    <!-- Block-Specific Options -->
                    <div v-if="selectedBlock.type === 'split'"
                        class="border border-gray-200 rounded-lg overflow-hidden">
                        <button @click="expandedSections.layoutOptions = !expandedSections.layoutOptions"
                            class="w-full px-4 py-3 bg-gray-50 hover:bg-gray-100 flex items-center justify-between transition-colors">
                            <h3 class="text-xs font-semibold text-gray-700 uppercase tracking-wide">Layout</h3>
                            <svg class="w-4 h-4 text-gray-500 transition-transform"
                                :class="{ 'rotate-180': expandedSections.layoutOptions }" fill="none"
                                stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                    d="M19 9l-7 7-7-7" />
                            </svg>
                        </button>

                        <div v-show="expandedSections.layoutOptions" class="p-4 space-y-4">

                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-1">Heading Tag</label>
                                <select :value="selectedBlock.props.headingTag || 'h3'"
                                    @change="updateStyle('headingTag', ($event.target as HTMLSelectElement).value)"
                                    class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                                    <option value="h1">H1 - Main Title</option>
                                    <option value="h2">H2 - Section</option>
                                    <option value="h3">H3 - Subsection</option>
                                    <option value="h4">H4 - Small</option>
                                    <option value="p">Paragraph</option>
                                </select>
                            </div>

                            <div>
                                <label class="flex items-center justify-between cursor-pointer">
                                    <span class="text-sm font-medium text-gray-700">Reverse Layout</span>
                                    <button @click="updateStyle('reverse', !selectedBlock.props.reverse)"
                                        class="relative w-11 h-6 rounded-full transition-colors"
                                        :class="selectedBlock.props.reverse ? 'bg-blue-500' : 'bg-gray-300'">
                                        <span
                                            class="absolute top-0.5 left-0.5 w-5 h-5 bg-white rounded-full shadow transition-transform"
                                            :class="{ 'translate-x-5': selectedBlock.props.reverse }"></span>
                                    </button>
                                </label>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Empty State for Right Panel -->
                <div v-else-if="!previewMode"
                    class="w-80 bg-white border-l border-gray-200 flex flex-col items-center justify-center text-gray-400 p-6">
                    <svg class="w-12 h-12 mb-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                            d="M15 15l-2 5L9 9l11 4-5 2zm0 0l5 5M7.188 2.239l.777 2.897M5.136 7.965l-2.898-.777M13.95 4.05l-2.122 2.122m-5.657 5.656l-2.12 2.122" />
                    </svg>
                    <p class="text-sm font-medium text-center">Select a block to edit its style</p>
                </div>

                <!-- Hidden file input for image uploads -->
                <input type="file" ref="fileInput" class="hidden" accept="image/*" @change="handleFileUpload" />
            </div>
</template>

<script setup lang="ts">
import { ref, computed, watch } from 'vue'
import VizTextBlock from './blocks/VizTextBlock.vue'
import VizHeroBlock from './blocks/VizHeroBlock.vue'
import VizSplitBlock from './blocks/VizSplitBlock.vue'
import VizImageBlock from './blocks/VizImageBlock.vue'
import VizGalleryBlock from './blocks/VizGalleryBlock.vue'
import VizQuoteBlock from './blocks/VizQuoteBlock.vue'
import VizVideoBlock from './blocks/VizVideoBlock.vue'

const props = defineProps({
    modelValue: { type: Array, default: () => [] },
    initialBlocks: { type: Array, default: () => [] }
})
const emit = defineEmits(['update:modelValue', 'update:blocks'])

const blocks = ref([...(props.modelValue as any[] || props.initialBlocks as any[])])
const selectedBlockIndex = ref<number | null>(null)
const previewMode = ref(false)
const isDragging = ref(false)
const draggedPreset = ref<any>(null)

// Collapsible sections state
const expandedSections = ref({
    typography: true,
    spacing: false,
    background: false,
    animation: false,
    decorations: false,
    textOptions: false,
    layoutOptions: false
})

// Watch for changes to modelValue and sync blocks
watch(() => props.modelValue, (newValue) => {
    if (newValue && Array.isArray(newValue)) {
        blocks.value = [...newValue]
    }
}, { deep: true, immediate: true })

const blockComponents: Record<string, any> = {
    text: VizTextBlock,
    hero: VizHeroBlock,
    split: VizSplitBlock,
    image: VizImageBlock,
    gallery: VizGalleryBlock,
    quote: VizQuoteBlock,
    video: VizVideoBlock
}

// Block Presets
const blockPresets = [
    { type: 'hero', label: 'Hero', description: 'Title & subtitle', icon: '🎯', iconBg: 'bg-purple-100' },
    { type: 'text', label: 'Text', description: 'Rich text content', icon: '📝', iconBg: 'bg-blue-100' },
    { type: 'image', label: 'Image', description: 'Full-width image', icon: '🖼️', iconBg: 'bg-green-100' },
    { type: 'split', label: 'Split', description: 'Image + text side by side', icon: '⬛', iconBg: 'bg-orange-100' },
    { type: 'gallery', label: 'Gallery', description: 'Image grid', icon: '🎨', iconBg: 'bg-pink-100' },
    { type: 'quote', label: 'Quote', description: 'Testimonial or quote', icon: '💬', iconBg: 'bg-yellow-100' },
    { type: 'video', label: 'Video', description: 'Embed video', icon: '🎬', iconBg: 'bg-red-100' }
]

// Style Options
const fontSizes = [
    { value: 'sm', label: 'S' },
    { value: 'base', label: 'M' },
    { value: 'lg', label: 'L' },
    { value: 'xl', label: 'XL' },
    { value: '2xl', label: '2X' }
]

const textAligns = [
    { value: 'left', icon: '<path d="M2 4h12v2H2V4zm0 4h16v2H2V8zm0 4h10v2H2v-2zm0 4h16v2H2v-2z"/>' },
    { value: 'center', icon: '<path d="M4 4h12v2H4V4zm-2 4h16v2H2V8zm3 4h10v2H5v-2zm-3 4h16v2H2v-2z"/>' },
    { value: 'right', icon: '<path d="M6 4h12v2H6V4zm-4 4h16v2H2V8zm6 4h10v2H8v-2zm-6 4h16v2H2v-2z"/>' },
    { value: 'justify', icon: '<path d="M2 4h16v2H2V4zm0 4h16v2H2V8zm0 4h16v2H2v-2zm0 4h16v2H2v-2z"/>' }
]

const textColors = [
    { value: '', label: 'Default', class: 'bg-gray-800' },
    { value: 'gray-500', label: 'Gray', class: 'bg-gray-500' },
    { value: 'light-green', label: 'Light Green', class: 'bg-light-green' },
    { value: 'bright-pink', label: 'Bright Pink', class: 'bg-bright-pink' },
    { value: 'lighter-pink', label: 'Lighter Pink', class: 'bg-lighter-pink' },
    { value: 'light-blue', label: 'Light Blue', class: 'bg-light-blue' },
    { value: 'blue-purple', label: 'Blue Purple', class: 'bg-blue-purple' },
    { value: 'white', label: 'White', class: 'bg-white border-2 border-gray-300' }
]

const bgColors = [
    { value: '', label: 'None', class: 'bg-white border-dashed' },
    { value: 'gray-50', label: 'Light Gray', class: 'bg-gray-50' },
    { value: 'gray-100', label: 'Gray', class: 'bg-gray-100' },
    { value: 'portfolio-white', label: 'Portfolio White', class: 'bg-portfolio-white' },
    { value: 'light-green/10', label: 'Light Green Tint', class: 'bg-light-green/10' },
    { value: 'bright-pink/10', label: 'Pink Tint', class: 'bg-bright-pink/10' },
    { value: 'light-blue/10', label: 'Blue Tint', class: 'bg-light-blue/10' },
    { value: 'blue-purple/10', label: 'Purple Tint', class: 'bg-blue-purple/10' }
]

const gradientPresets = [
    { value: 'blue-purple', label: 'Blue Purple', class: 'bg-gradient-to-br from-blue-purple to-blue-purple/80' },
    { value: 'pink-green', label: 'Pink Green', class: 'bg-gradient-to-br from-bright-pink to-light-green' },
    { value: 'purple-pink', label: 'Purple Pink', class: 'bg-gradient-to-br from-blue-purple to-bright-pink' },
    { value: 'green-blue', label: 'Green Blue', class: 'bg-gradient-to-br from-light-green to-light-blue' },
    { value: 'sunset-warm', label: 'Sunset', class: 'bg-gradient-to-br from-bright-pink via-lighter-pink to-light-blue' },
    { value: 'ocean-breeze', label: 'Ocean', class: 'bg-gradient-to-br from-light-blue via-blue-purple to-bright-pink' },
    { value: 'forest-mist', label: 'Forest', class: 'bg-gradient-to-br from-light-green via-light-blue to-blue-purple' },
    { value: 'berry-blast', label: 'Berry', class: 'bg-gradient-to-br from-lighter-pink via-bright-pink to-blue-purple' },
    { value: 'cosmic-fusion', label: 'Cosmic', class: 'bg-gradient-to-br from-blue-purple via-bright-pink to-light-green' }
]

const animations = [
    { value: 'none', label: 'None' },
    { value: 'fade-in', label: 'Fade In' },
    { value: 'slide-in-left', label: 'Slide Left' },
    { value: 'slide-in-right', label: 'Slide Right' },
    { value: 'pulse', label: 'Pulse' },
    { value: 'bounce', label: 'Bounce' }
]

const decorations = [
    { value: 'underline', label: 'Underline', class: 'underline' },
    { value: 'line-through', label: 'Strike', class: 'line-through' },
    { value: 'highlight', label: 'Highlight', class: 'bg-yellow-200 px-1' },
    { value: 'uppercase', label: 'UPPERCASE', class: 'uppercase' }
]

const textGradients = [
    { value: 'rainbow', label: 'Rainbow', class: 'bg-gradient-to-r from-blue-600 via-green-500 to-indigo-400' },
    { value: 'custom', label: 'Custom', class: 'bg-gradient-to-r from-light-green via-bright-pink to-blue-purple' },
    { value: 'sunset', label: 'Sunset', class: 'bg-gradient-to-r from-bright-pink via-lighter-pink to-light-blue' },
    { value: 'ocean', label: 'Ocean', class: 'bg-gradient-to-r from-light-blue to-blue-purple' },
    { value: 'forest', label: 'Forest', class: 'bg-gradient-to-r from-light-green to-light-blue' },
    { value: 'purple-dream', label: 'Purple', class: 'bg-gradient-to-r from-blue-purple to-bright-pink' }
]

const fontWeights = [
    { value: 'normal', label: 'Normal' },
    { value: 'medium', label: 'Medium' },
    { value: 'semibold', label: 'Semibold' },
    { value: 'bold', label: 'Bold' }
]

const paddings = [
    { value: '4', label: 'XS' },
    { value: '8', label: 'S' },
    { value: '12', label: 'M' },
    { value: '16', label: 'L' },
    { value: '20', label: 'XL' }
]

// Computed
const selectedBlock = computed(() => {
    if (selectedBlockIndex.value === null) return null
    return blocks.value[selectedBlockIndex.value]
})

// Methods
const selectBlock = (index: number) => {
    selectedBlockIndex.value = index
}

const getDefaultProps = (type: string) => {
    switch (type) {
        case 'hero':
            return { title: 'Project Title', subtitle: 'A brief description of the project.' }
        case 'text':
            return { html: '<h3>Section Title</h3><p>Write your content here.</p>' }
        case 'image':
            return { src: '' }
        case 'split':
            return { title: 'Feature Title', body: '<p>Describe this feature or aspect of your project.</p>', src: 'https://placehold.co/800x600', reverse: false, headingTag: 'h3' }
        case 'gallery':
            return { images: ['https://placehold.co/400x400', 'https://placehold.co/400x400', 'https://placehold.co/400x400'] }
        case 'quote':
            return { text: 'Design is intelligence made visible.', author: 'Alina Wheeler' }
        case 'video':
            return { url: '' }
        default:
            return {}
    }
}

const addBlock = (type: string) => {
    const newBlock = {
        id: crypto.randomUUID(),
        type,
        props: getDefaultProps(type)
    }
    blocks.value.push(newBlock)
    selectedBlockIndex.value = blocks.value.length - 1
    emitUpdate()
}

const updateBlockProps = (index: number, newProps: any) => {
    blocks.value[index].props = newProps
    emitUpdate()
}

const updateStyle = (key: string, value: any) => {
    if (selectedBlockIndex.value === null) return
    blocks.value[selectedBlockIndex.value].props[key] = value
    blocks.value = [...blocks.value]
    emitUpdate()
}

const toggleDecoration = (decoration: string) => {
    if (!selectedBlock.value) return
    const current = selectedBlock.value.props.decorations || []
    const idx = current.indexOf(decoration)
    const newDec = idx === -1 ? [...current, decoration] : current.filter((d: string) => d !== decoration)
    updateStyle('decorations', newDec)
}

const moveBlock = (index: number, direction: number) => {
    const newIndex = index + direction
    if (newIndex < 0 || newIndex >= blocks.value.length) return
    const temp = blocks.value[index]
    blocks.value[index] = blocks.value[newIndex]
    blocks.value[newIndex] = temp
    selectedBlockIndex.value = newIndex
    emitUpdate()
}

const duplicateBlock = (index: number) => {
    const block = blocks.value[index]
    const newBlock = {
        id: crypto.randomUUID(),
        type: block.type,
        props: JSON.parse(JSON.stringify(block.props))
    }
    blocks.value.splice(index + 1, 0, newBlock)
    selectedBlockIndex.value = index + 1
    emitUpdate()
}

const deleteBlock = (index: number) => {
    blocks.value.splice(index, 1)
    if (selectedBlockIndex.value === index) {
        selectedBlockIndex.value = null
    } else if (selectedBlockIndex.value !== null && selectedBlockIndex.value > index) {
        selectedBlockIndex.value--
    }
    emitUpdate()
}

// Drag & Drop
const handleDragStart = (preset: any, e: DragEvent) => {
    draggedPreset.value = preset
    isDragging.value = true
    e.dataTransfer?.setData('text/plain', preset.type)
}

const handleCanvasDrop = () => {
    isDragging.value = false
    if (draggedPreset.value) {
        addBlock(draggedPreset.value.type)
        draggedPreset.value = null
    }
}

// Image Upload
const fileInput = ref<HTMLInputElement | null>(null)
const uploadBlockId = ref<string | null>(null)

const triggerUpload = (id: string) => {
    uploadBlockId.value = id
    fileInput.value?.click()
}

const handleFileUpload = async (e: Event) => {
    const target = e.target as HTMLInputElement
    const file = target.files?.[0]
    if (!file || !uploadBlockId.value) return

    const url = URL.createObjectURL(file)
    const blockIdx = blocks.value.findIndex((b: any) => b.id === uploadBlockId.value)
    if (blockIdx !== -1) {
        blocks.value[blockIdx].props.src = url
        blocks.value = [...blocks.value]
        emitUpdate()
    }
    target.value = ''
    uploadBlockId.value = null
}

const emitUpdate = () => {
    emit('update:modelValue', blocks.value)
    emit('update:blocks', blocks.value)
}

// Watch for drag end on document
if (typeof document !== 'undefined') {
    document.addEventListener('dragend', () => {
        isDragging.value = false
    })
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
