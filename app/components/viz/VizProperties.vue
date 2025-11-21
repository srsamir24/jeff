<template>
  <div class="w-64 bg-white border-l border-gray-200 h-full flex flex-col overflow-y-auto z-20 relative shadow-sm">
    <div v-if="block" class="flex-1 p-4 space-y-6">
      
      <!-- Header -->
      <div class="flex items-center justify-between pb-4 border-b border-gray-100">
        <span class="text-xs font-bold text-gray-500 uppercase">{{ block.type }}</span>
        <button @click="centerBlock" class="px-2 py-1 text-xs bg-blue-50 text-blue-600 rounded hover:bg-blue-100 transition-colors" title="Center on artboard">
          <svg class="w-3 h-3 inline mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 20l-5.447-2.724A1 1 0 013 16.382V5.618a1 1 0 011.447-.894L9 7m0 13l6-3m-6 3V7m6 10l4.553 2.276A1 1 0 0021 18.382V7.618a1 1 0 00-.553-.894L15 4m0 13V4m0 0L9 7"/></svg>
          Center
        </button>
      </div>

      <!-- Layout (X, Y, W, H, Rotation) -->
      <section>
        <h4 class="text-xs font-bold text-gray-900 mb-3">Transform</h4>
        <div class="grid grid-cols-2 gap-3 mb-3">
          <div class="flex items-center gap-2">
            <span class="text-xs text-gray-400 w-4">X</span>
            <input type="number" v-model.number="block.x" class="flex-1 px-2 py-1 text-xs border border-gray-200 rounded" />
          </div>
          <div class="flex items-center gap-2">
            <span class="text-xs text-gray-400 w-4">Y</span>
            <input type="number" v-model.number="block.y" class="flex-1 px-2 py-1 text-xs border border-gray-200 rounded" />
          </div>
          <div class="flex items-center gap-2">
            <span class="text-xs text-gray-400 w-4">W</span>
            <input type="number" v-model.number="block.width" class="flex-1 px-2 py-1 text-xs border border-gray-200 rounded" />
          </div>
          <div class="flex items-center gap-2">
            <span class="text-xs text-gray-400 w-4">H</span>
            <input type="number" v-model.number="block.height" class="flex-1 px-2 py-1 text-xs border border-gray-200 rounded" />
          </div>
          <div class="flex items-center gap-2">
            <span class="text-xs text-gray-400 w-4">R</span>
            <input type="number" v-model.number="block.rotation" class="flex-1 px-2 py-1 text-xs border border-gray-200 rounded" placeholder="0°" />
          </div>
          <div class="flex items-center gap-2">
            <span class="text-xs text-gray-400 w-4">Z</span>
            <input type="number" v-model.number="block.zIndex" class="flex-1 px-2 py-1 text-xs border border-gray-200 rounded" placeholder="Auto" />
          </div>
        </div>
      </section>

      <!-- Fill -->
      <section class="border-t border-gray-100 pt-4">
        <h4 class="text-xs font-bold text-gray-900 mb-3">Fill</h4>
        <div class="flex items-center gap-2 mb-2">
          <div class="w-6 h-6 rounded border border-gray-200 overflow-hidden relative">
            <input type="color" v-model="style.backgroundColor" class="absolute -top-2 -left-2 w-10 h-10 cursor-pointer" />
          </div>
          <input type="text" v-model="style.backgroundColor" class="flex-1 px-2 py-1 text-xs border border-gray-200 rounded font-mono" placeholder="#FFFFFF" />
          <input type="range" min="0" max="1" step="0.01" v-model.number="style.opacity" class="w-16" title="Opacity" />
        </div>
      </section>

      <!-- Stroke -->
      <section class="border-t border-gray-100 pt-4">
        <h4 class="text-xs font-bold text-gray-900 mb-3">Stroke</h4>
        <div class="flex items-center gap-2 mb-2">
          <div class="w-6 h-6 rounded border border-gray-200 overflow-hidden relative">
            <input type="color" v-model="style.borderColor" class="absolute -top-2 -left-2 w-10 h-10 cursor-pointer" />
          </div>
          <input type="text" v-model="style.borderColor" class="flex-1 px-2 py-1 text-xs border border-gray-200 rounded font-mono" placeholder="#000000" />
        </div>
        <div class="flex items-center gap-2">
          <span class="text-xs text-gray-400">Width</span>
          <input type="number" v-model.number="style.borderWidth" class="flex-1 px-2 py-1 text-xs border border-gray-200 rounded" placeholder="0" />
        </div>
      </section>

      <!-- Typography (Text Only) -->
      <section v-if="block.type === 'text'" class="border-t border-gray-100 pt-4">
        <h4 class="text-xs font-bold text-gray-900 mb-3">Typography</h4>
        <div class="space-y-2">
          <textarea v-model="block.props.text" rows="3" class="w-full px-2 py-1 text-xs border border-gray-200 rounded resize-none" placeholder="Enter text..."></textarea>
          
          <div class="grid grid-cols-2 gap-2">
            <input type="number" v-model.number="style.fontSize" class="px-2 py-1 text-xs border border-gray-200 rounded" placeholder="Size" />
            <select v-model="style.fontWeight" class="px-2 py-1 text-xs border border-gray-200 rounded">
              <option value="400">Regular</option>
              <option value="500">Medium</option>
              <option value="600">SemiBold</option>
              <option value="700">Bold</option>
            </select>
          </div>
          
          <div class="flex items-center gap-2">
            <div class="w-6 h-6 rounded border border-gray-200 overflow-hidden relative">
              <input type="color" v-model="style.color" class="absolute -top-2 -left-2 w-10 h-10 cursor-pointer" />
            </div>
            <input type="text" v-model="style.color" class="flex-1 px-2 py-1 text-xs border border-gray-200 rounded font-mono" placeholder="#000000" />
          </div>

          <div class="flex gap-1 bg-gray-100 p-1 rounded">
            <button @click="style.textAlign = 'left'" class="flex-1 p-1 rounded hover:bg-white" :class="style.textAlign === 'left' ? 'bg-white shadow-sm' : ''">
              <svg class="w-3 h-3 mx-auto" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h10M4 18h16"/></svg>
            </button>
            <button @click="style.textAlign = 'center'" class="flex-1 p-1 rounded hover:bg-white" :class="style.textAlign === 'center' ? 'bg-white shadow-sm' : ''">
              <svg class="w-3 h-3 mx-auto" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"/></svg>
            </button>
            <button @click="style.textAlign = 'right'" class="flex-1 p-1 rounded hover:bg-white" :class="style.textAlign === 'right' ? 'bg-white shadow-sm' : ''">
              <svg class="w-3 h-3 mx-auto" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M10 12h10M4 18h16"/></svg>
            </button>
          </div>
        </div>
      </section>

      <!-- Image (Image Only) -->
      <section v-if="block.type === 'image'" class="border-t border-gray-100 pt-4">
        <h4 class="text-xs font-bold text-gray-900 mb-3">Image</h4>
        <input type="text" v-model="block.props.src" class="w-full px-2 py-1 text-xs border border-gray-200 rounded mb-2" placeholder="Image URL" />
        <input ref="fileInput" type="file" accept="image/*" @change="handleImageUpload" class="hidden" />
        <button @click="$refs.fileInput.click()" class="w-full px-3 py-2 bg-blue-50 hover:bg-blue-100 rounded text-xs font-medium text-blue-600 transition-colors" :disabled="uploading">
          {{ uploading ? 'Uploading...' : 'Upload Image' }}
        </button>
      </section>

      <!-- Effects -->
      <section class="border-t border-gray-100 pt-4">
        <h4 class="text-xs font-bold text-gray-900 mb-3">Effects</h4>
        <div class="flex items-center gap-2 mb-2">
          <span class="text-xs text-gray-400 w-12">Radius</span>
          <input type="number" v-model.number="style.borderRadius" class="flex-1 px-2 py-1 text-xs border border-gray-200 rounded" placeholder="0" />
        </div>
        <div class="flex items-center gap-2">
          <span class="text-xs text-gray-400 w-12">Shadow</span>
          <select v-model="style.boxShadow" class="flex-1 px-2 py-1 text-xs border border-gray-200 rounded">
            <option value="">None</option>
            <option value="0 2px 4px rgba(0,0,0,0.1)">Small</option>
            <option value="0 4px 6px rgba(0,0,0,0.1)">Medium</option>
            <option value="0 10px 15px rgba(0,0,0,0.1)">Large</option>
          </select>
        </div>
      </section>

    </div>

    <div v-else class="flex-1 flex items-center justify-center p-4 text-center text-gray-400">
      <p class="text-sm">Select an object to edit</p>
    </div>
  </div>
</template>

<script setup>
const props = defineProps({
  block: { type: Object, default: null }
})

const emit = defineEmits(['center'])

const supabase = useSupabaseClient()
const toast = useToast()
const uploading = ref(false)
const fileInput = ref(null)

// Helper to access style safely
const style = computed(() => {
  if (!props.block) return {}
  if (!props.block.props) props.block.props = {}
  if (!props.block.props.style) props.block.props.style = {}
  return props.block.props.style
})

// Center block on artboard
const centerBlock = () => {
  if (!props.block) return
  props.block.x = (1440 - props.block.width) / 2
  props.block.y = 100 // Top padding for navbar
}

// Handle image upload
const handleImageUpload = async (e) => {
  const file = e.target.files[0]
  if (!file) return

  uploading.value = true
  try {
    const fileExt = file.name.split('.').pop()
    const fileName = `${Math.random().toString(36).substring(2)}-${Date.now()}.${fileExt}`
    const filePath = `${fileName}`

    const { data, error: uploadError } = await supabase.storage
      .from('projects')
      .upload(filePath, file)

    if (uploadError) throw uploadError

    const { data: { publicUrl } } = supabase.storage
      .from('projects')
      .getPublicUrl(filePath)

    props.block.props.src = publicUrl
    toast.success('Image uploaded successfully')
  } catch (error) {
    console.error('Error uploading image:', error)
    toast.error('Error uploading image')
  } finally {
    uploading.value = false
  }
}
</script>
