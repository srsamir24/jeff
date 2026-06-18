<template>
  <NuxtLayout name="admin">
    <div class="space-y-10 animate-fade-in">
      <!-- Header -->
      <div class="flex flex-col md:flex-row md:items-end md:justify-between gap-4">
        <div class="space-y-2">
          <h1 class="text-4xl font-bold tracking-tight text-white font-display">AI Studio</h1>
          <p class="text-white/40 font-medium">Generate images & video with Freepik / Magnific — powered by your account credits.</p>
        </div>

        <!-- Mode toggle -->
        <div class="flex items-center gap-2 p-1.5 bg-white/[0.03] backdrop-blur-3xl rounded-full w-fit self-start">
          <button
            v-for="m in modes"
            :key="m.key"
            @click="setMode(m.key)"
            :class="[
              'px-7 py-2.5 rounded-full text-xs font-bold tracking-widest uppercase transition-all duration-500 flex items-center gap-2',
              mode === m.key ? 'bg-white text-black shadow-2xl' : 'text-white/40 hover:text-white hover:bg-white/5'
            ]"
          >
            <Icon :name="m.icon" class="w-4 h-4" />
            {{ m.label }}
          </button>
        </div>
      </div>

      <div class="grid grid-cols-1 lg:grid-cols-[minmax(0,400px)_1fr] gap-8 items-start">
        <!-- ============ CONTROLS ============ -->
        <div class="bg-white/[0.03] backdrop-blur-3xl rounded-[32px] p-7 space-y-7 lg:sticky lg:top-6">
          <!-- Model picker -->
          <div class="space-y-3">
            <label class="text-overline">Model</label>
            <div class="grid grid-cols-1 gap-2">
              <button
                v-for="model in models"
                :key="model.id"
                @click="selectedModel = model.id"
                :class="[
                  'text-left px-4 py-3 rounded-2xl transition-all duration-300 group',
                  selectedModel === model.id ? 'bg-white/10 ring-1 ring-white/20' : 'bg-white/[0.02] hover:bg-white/5'
                ]"
              >
                <div class="flex items-center justify-between gap-2">
                  <span class="font-bold text-sm text-white">{{ model.label }}</span>
                  <span v-if="model.badge" class="text-[8px] uppercase tracking-widest font-bold px-2 py-0.5 rounded-full bg-[var(--ui-primary)]/20 text-[var(--ui-primary)]">
                    {{ model.badge }}
                  </span>
                </div>
                <p class="text-[11px] text-white/30 mt-0.5 leading-snug">{{ model.blurb }}</p>
              </button>
            </div>
          </div>

          <!-- Source image (video only) -->
          <div v-if="mode === 'video'" class="space-y-3">
            <label class="text-overline">Source Image <span class="text-[var(--ui-primary)]">*</span></label>
            <div
              v-if="sourceImage"
              class="relative rounded-2xl overflow-hidden group bg-black/20"
            >
              <img :src="sourceImage" alt="source" class="w-full h-44 object-contain" />
              <button
                @click="sourceImage = ''"
                class="absolute top-2 right-2 w-8 h-8 rounded-full bg-black/60 backdrop-blur flex items-center justify-center text-white/80 hover:text-white hover:bg-black/80 transition"
              >
                <Icon name="i-heroicons-x-mark" class="w-4 h-4" />
              </button>
            </div>
            <div v-else class="space-y-2">
              <button
                @click="pickSourceImage"
                :disabled="uploading"
                class="w-full px-4 py-6 rounded-2xl bg-white/[0.02] hover:bg-white/5 transition flex flex-col items-center gap-2 text-white/50 hover:text-white/80 disabled:opacity-50"
              >
                <Icon :name="uploading ? 'i-heroicons-arrow-path' : 'i-heroicons-arrow-up-tray'" class="w-6 h-6" :class="{ 'animate-spin': uploading }" />
                <span class="text-xs font-medium">{{ uploading ? 'Uploading…' : 'Upload an image' }}</span>
              </button>
              <div class="flex items-center gap-2">
                <input
                  v-model="sourceImageUrl"
                  type="text"
                  placeholder="…or paste an image URL"
                  class="flex-1 px-4 py-3 bg-white/5 rounded-2xl text-white text-sm placeholder:text-white/20 outline-none focus:ring-1 focus:ring-white/20 transition"
                  @keyup.enter="applyImageUrl"
                />
                <button @click="applyImageUrl" class="px-4 py-3 rounded-2xl bg-white/10 hover:bg-white/20 text-white text-xs font-bold transition">Set</button>
              </div>
            </div>
          </div>

          <!-- Prompt -->
          <div class="space-y-3">
            <label class="text-overline">{{ mode === 'video' ? 'Motion Prompt' : 'Prompt' }} <span v-if="mode === 'image'" class="text-[var(--ui-primary)]">*</span></label>
            <textarea
              v-model="prompt"
              :rows="mode === 'video' ? 3 : 5"
              :placeholder="mode === 'video' ? 'Describe the camera and motion… e.g. slow dolly-in, hair blowing in the wind' : 'Describe the image you want to create…'"
              class="w-full px-5 py-4 bg-white/5 rounded-2xl text-white text-sm placeholder:text-white/20 outline-none focus:ring-1 focus:ring-white/20 transition resize-none leading-relaxed"
            ></textarea>
          </div>

          <!-- Negative prompt (video) -->
          <div v-if="mode === 'video'" class="space-y-3">
            <label class="text-overline">Negative Prompt</label>
            <input
              v-model="negativePrompt"
              type="text"
              placeholder="Things to avoid (optional)"
              class="w-full px-5 py-3 bg-white/5 rounded-2xl text-white text-sm placeholder:text-white/20 outline-none focus:ring-1 focus:ring-white/20 transition"
            />
          </div>

          <!-- Image options -->
          <template v-if="mode === 'image'">
            <div class="grid grid-cols-2 gap-3">
              <div class="space-y-3 col-span-2">
                <label class="text-overline">Aspect Ratio</label>
                <select v-model="aspectRatio" class="studio-select">
                  <option v-for="ar in ASPECT_RATIOS" :key="ar.value" :value="ar.value">{{ ar.label }}</option>
                </select>
              </div>

              <div v-if="features.resolution" class="space-y-3">
                <label class="text-overline">Resolution</label>
                <select v-model="resolution" class="studio-select">
                  <option v-for="r in RESOLUTIONS" :key="r.value" :value="r.value">{{ r.label }}</option>
                </select>
              </div>

              <div v-if="features.styleModel" class="space-y-3">
                <label class="text-overline">Style</label>
                <select v-model="styleModel" class="studio-select">
                  <option v-for="s in MYSTIC_STYLES" :key="s.value" :value="s.value">{{ s.label }}</option>
                </select>
              </div>
            </div>

            <div v-if="features.hdr" class="space-y-3">
              <label class="text-overline flex items-center justify-between">
                <span>Detail / HDR</span>
                <span class="text-white/40 font-mono">{{ hdr }}</span>
              </label>
              <input v-model.number="hdr" type="range" min="0" max="100" class="studio-range" />
            </div>
          </template>

          <!-- Video options -->
          <template v-else>
            <div class="grid grid-cols-2 gap-3">
              <div class="space-y-3">
                <label class="text-overline">Duration</label>
                <select v-model="duration" class="studio-select">
                  <option v-for="d in DURATIONS" :key="d.value" :value="d.value">{{ d.label }}</option>
                </select>
              </div>
              <div v-if="features.cfgScale" class="space-y-3">
                <label class="text-overline flex items-center justify-between">
                  <span>Adherence</span>
                  <span class="text-white/40 font-mono">{{ cfgScale.toFixed(1) }}</span>
                </label>
                <input v-model.number="cfgScale" type="range" min="0" max="1" step="0.1" class="studio-range mt-3" />
              </div>
            </div>
          </template>

          <!-- Generate -->
          <button
            @click="onGenerate"
            :disabled="!canGenerate"
            class="w-full px-6 py-4 rounded-full font-bold tracking-wide transition-all duration-300 flex items-center justify-center gap-2 bg-[var(--ui-primary)] text-black hover:brightness-110 disabled:opacity-30 disabled:cursor-not-allowed"
          >
            <Icon :name="busy ? 'i-heroicons-arrow-path' : (mode === 'video' ? 'i-heroicons-film' : 'i-heroicons-sparkles')" class="w-5 h-5" :class="{ 'animate-spin': busy }" />
            {{ busy ? 'Generating…' : (mode === 'video' ? 'Generate Video' : 'Generate Image') }}
          </button>
          <p class="text-[10px] text-white/25 text-center -mt-3">Generations use your Freepik / Magnific credits.</p>
        </div>

        <!-- ============ RESULTS ============ -->
        <div class="space-y-6 min-w-0">
          <div class="flex items-center justify-between">
            <h2 class="text-overline">Generations</h2>
            <button v-if="history.length" @click="clearHistory" class="text-[10px] uppercase tracking-widest text-white/30 hover:text-red-400 transition">Clear all</button>
          </div>

          <!-- Empty state -->
          <div v-if="!history.length" class="rounded-[32px] bg-white/[0.02] py-24 flex flex-col items-center justify-center text-center px-6">
            <Icon name="i-heroicons-photo" class="w-12 h-12 text-white/10 mb-4" />
            <p class="text-white/40 font-medium">Your generations will appear here</p>
            <p class="text-white/20 text-sm mt-1">Pick a model, write a prompt, and hit generate.</p>
          </div>

          <!-- Grid -->
          <div v-else class="grid grid-cols-1 sm:grid-cols-2 gap-5">
            <div
              v-for="item in history"
              :key="item.id"
              class="rounded-[24px] overflow-hidden bg-white/[0.03] group flex flex-col"
            >
              <!-- Media -->
              <div class="relative aspect-square bg-black/30 flex items-center justify-center overflow-hidden">
                <!-- pending -->
                <div v-if="item.status === 'IN_PROGRESS' || item.status === 'CREATED'" class="flex flex-col items-center gap-3 text-white/40">
                  <div class="w-10 h-10 border-2 border-white/10 border-t-[var(--ui-primary)] rounded-full animate-spin"></div>
                  <span class="text-[10px] uppercase tracking-widest animate-pulse">Rendering…</span>
                </div>
                <!-- failed -->
                <div v-else-if="item.status === 'FAILED'" class="flex flex-col items-center gap-2 text-red-400/70 px-4 text-center">
                  <Icon name="i-heroicons-exclamation-triangle" class="w-8 h-8" />
                  <span class="text-[11px]">Generation failed</span>
                  <button @click="retry(item)" class="mt-1 text-[10px] uppercase tracking-widest text-white/40 hover:text-white">Retry</button>
                </div>
                <!-- done: image -->
                <img v-else-if="item.kind === 'image'" :src="item.urls[0]" :alt="item.prompt" class="w-full h-full object-cover" />
                <!-- done: video -->
                <video v-else :src="item.urls[0]" class="w-full h-full object-cover" controls loop playsinline />

                <!-- kind badge -->
                <span class="absolute top-3 left-3 text-[9px] uppercase tracking-widest font-bold px-2 py-1 rounded-full bg-black/60 backdrop-blur text-white/80">
                  {{ item.modelLabel }}
                </span>
              </div>

              <!-- Meta + actions -->
              <div class="p-4 space-y-3 flex-1 flex flex-col">
                <p class="text-xs text-white/50 line-clamp-2 leading-snug flex-1">{{ item.prompt || '—' }}</p>
                <div v-if="item.status === 'COMPLETED' && item.urls.length" class="flex items-center gap-2">
                  <a :href="proxyUrl(item.urls[0], true)" class="action-btn" title="Download">
                    <Icon name="i-heroicons-arrow-down-tray" class="w-4 h-4" />
                  </a>
                  <button @click="saveToLibrary(item)" :disabled="item.saving" class="action-btn" title="Save to Library (Supabase)">
                    <Icon :name="item.saving ? 'i-heroicons-arrow-path' : 'i-heroicons-bookmark'" class="w-4 h-4" :class="{ 'animate-spin': item.saving }" />
                  </button>
                  <button v-if="item.kind === 'image'" @click="useAsVideoSource(item)" class="action-btn" title="Animate this image">
                    <Icon name="i-heroicons-film" class="w-4 h-4" />
                  </button>
                  <button @click="removeItem(item.id)" class="action-btn ml-auto hover:!text-red-400" title="Remove">
                    <Icon name="i-heroicons-trash" class="w-4 h-4" />
                  </button>
                </div>
                <div v-else-if="item.status === 'FAILED'" class="flex justify-end">
                  <button @click="removeItem(item.id)" class="action-btn hover:!text-red-400" title="Remove">
                    <Icon name="i-heroicons-trash" class="w-4 h-4" />
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </NuxtLayout>
</template>

<script setup>
import {
  useAiStudio, IMAGE_MODELS, VIDEO_MODELS,
  ASPECT_RATIOS, RESOLUTIONS, MYSTIC_STYLES, DURATIONS
} from '~/composables/useAiStudio'

definePageMeta({
  middleware: 'admin',
  layout: false
})

const toast = useAppToast()
const studio = useAiStudio()
const { proxyUrl } = studio
const { uploadFile, pickAndUploadFile } = useSupabaseStorage()

const STORAGE_KEY = 'ai-studio-history-v1'

const modes = [
  { key: 'image', label: 'Image', icon: 'i-heroicons-photo' },
  { key: 'video', label: 'Video', icon: 'i-heroicons-film' }
]

// ---- form state ----
const mode = ref('image')
const selectedModel = ref(IMAGE_MODELS[0].id)
const prompt = ref('')
const negativePrompt = ref('')

// image params
const aspectRatio = ref('square_1_1')
const resolution = ref('2k')
const styleModel = ref('realism')
const hdr = ref(50)

// video params
const sourceImage = ref('')
const sourceImageUrl = ref('')
const duration = ref('5')
const cfgScale = ref(0.5)

const uploading = ref(false)
const busy = ref(false)

const history = ref([])

// ---- derived ----
const models = computed(() => (mode.value === 'image' ? IMAGE_MODELS : VIDEO_MODELS))
const currentModel = computed(() => models.value.find((m) => m.id === selectedModel.value) || models.value[0])
const features = computed(() => currentModel.value?.features || {})

const canGenerate = computed(() => {
  if (busy.value) return false
  if (mode.value === 'image') return prompt.value.trim().length > 0
  return sourceImage.value.trim().length > 0
})

function setMode(key) {
  if (mode.value === key) return
  mode.value = key
  selectedModel.value = models.value[0].id
}

function applyImageUrl() {
  const url = sourceImageUrl.value.trim()
  if (!url) return
  sourceImage.value = url
  sourceImageUrl.value = ''
}

async function pickSourceImage() {
  uploading.value = true
  try {
    const url = await pickAndUploadFile()
    if (url) sourceImage.value = url
  } catch (e) {
    toast.error('Upload failed. Please try again.')
  } finally {
    uploading.value = false
  }
}

// ---- payload ----
function buildPayload() {
  if (mode.value === 'image') {
    const p = { prompt: prompt.value.trim(), aspect_ratio: aspectRatio.value }
    if (features.value.resolution) p.resolution = resolution.value
    if (features.value.styleModel) p.model = styleModel.value
    if (features.value.hdr) p.hdr = hdr.value
    return p
  }
  const p = { image: sourceImage.value.trim(), duration: duration.value }
  if (prompt.value.trim()) p.prompt = prompt.value.trim()
  if (negativePrompt.value.trim()) p.negative_prompt = negativePrompt.value.trim()
  if (features.value.cfgScale) p.cfg_scale = cfgScale.value
  return p
}

// ---- generate + poll ----
async function onGenerate() {
  if (!canGenerate.value) return
  busy.value = true

  const modelId = selectedModel.value
  const modelLabel = currentModel.value.label
  const kind = mode.value
  const promptText = prompt.value.trim()

  try {
    const res = await studio.generate(modelId, buildPayload())

    const item = reactive({
      id: res.taskId,
      model: modelId,
      modelLabel,
      kind,
      prompt: promptText || (kind === 'video' ? 'Animated clip' : ''),
      status: res.status || 'IN_PROGRESS',
      urls: [],
      saving: false,
      createdAt: Date.now()
    })
    history.value.unshift(item)

    track(item)
  } catch (e) {
    toast.error(errMsg(e, 'Could not start generation.'))
  } finally {
    busy.value = false
  }
}

async function track(item) {
  try {
    const final = await studio.pollTask(item.model, item.id, {
      onTick: (s) => { item.status = s.status }
    })
    item.status = final.status
    item.urls = final.generated || []
    if (final.status === 'COMPLETED' && item.urls.length) {
      toast.success(`${item.modelLabel} ${item.kind} ready!`)
    } else if (final.status === 'COMPLETED') {
      item.status = 'FAILED'
      toast.error('Generation finished but returned no asset.')
    } else {
      toast.error('Generation failed.')
    }
  } catch (e) {
    item.status = 'FAILED'
    toast.error(errMsg(e, 'Generation failed.'))
  }
}

function retry(item) {
  item.status = 'IN_PROGRESS'
  track(item)
}

// ---- actions ----
function useAsVideoSource(item) {
  sourceImage.value = item.urls[0]
  setMode('video')
  toast.info('Image loaded as video source. Add a motion prompt and generate.')
  window.scrollTo({ top: 0, behavior: 'smooth' })
}

async function saveToLibrary(item) {
  item.saving = true
  try {
    const blob = await $fetch(proxyUrl(item.urls[0]), { responseType: 'blob' })
    const ext = item.kind === 'video' ? 'mp4' : 'png'
    const file = new File([blob], `studio-${item.id}.${ext}`, { type: blob.type })
    await uploadFile(file, `ai-studio/${item.id}.${ext}`)
    toast.success('Saved to Supabase storage (projects/ai-studio).')
  } catch (e) {
    toast.error(errMsg(e, 'Could not save asset.'))
  } finally {
    item.saving = false
  }
}

function removeItem(id) {
  history.value = history.value.filter((i) => i.id !== id)
}

function clearHistory() {
  history.value = []
}

// ---- persistence ----
function errMsg(e, fallback) {
  return e?.data?.statusMessage || e?.statusMessage || e?.message || fallback
}

onMounted(() => {
  try {
    const raw = localStorage.getItem(STORAGE_KEY)
    if (raw) {
      const saved = JSON.parse(raw)
      history.value = saved.map((i) => reactive({ ...i, saving: false }))
      // resume any still-pending tasks
      history.value
        .filter((i) => i.status === 'IN_PROGRESS' || i.status === 'CREATED')
        .forEach((i) => track(i))
    }
  } catch {}
})

watch(history, (val) => {
  try {
    // strip transient flags before persisting
    const slim = val.map(({ saving, ...rest }) => rest)
    localStorage.setItem(STORAGE_KEY, JSON.stringify(slim.slice(0, 60)))
  } catch {}
}, { deep: true })
</script>

<style scoped>
.animate-fade-in {
  animation: fadeIn 0.8s cubic-bezier(0.16, 1, 0.3, 1) forwards;
}
@keyframes fadeIn {
  from { opacity: 0; transform: translateY(16px); }
  to { opacity: 1; transform: translateY(0); }
}

.studio-select {
  width: 100%;
  padding: 0.7rem 1rem;
  background: rgba(255, 255, 255, 0.06);
  border-radius: 1rem;
  color: #fff;
  font-size: 0.85rem;
  outline: none;
  appearance: none;
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 24 24' stroke='rgba(255,255,255,0.4)'%3E%3Cpath stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M19 9l-7 7-7-7'/%3E%3C/svg%3E");
  background-repeat: no-repeat;
  background-position: right 0.85rem center;
  background-size: 1rem;
  transition: background-color 0.2s;
}
.studio-select:hover { background-color: rgba(255, 255, 255, 0.1); }
.studio-select option { background: #14101c; color: #fff; }

.studio-range {
  width: 100%;
  height: 4px;
  border-radius: 999px;
  background: rgba(255, 255, 255, 0.12);
  appearance: none;
  cursor: pointer;
}
.studio-range::-webkit-slider-thumb {
  appearance: none;
  width: 16px;
  height: 16px;
  border-radius: 50%;
  background: var(--ui-primary);
  cursor: pointer;
}
.studio-range::-moz-range-thumb {
  width: 16px;
  height: 16px;
  border: none;
  border-radius: 50%;
  background: var(--ui-primary);
  cursor: pointer;
}

.action-btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 34px;
  height: 34px;
  border-radius: 0.75rem;
  background: rgba(255, 255, 255, 0.06);
  color: rgba(255, 255, 255, 0.6);
  transition: all 0.2s;
}
.action-btn:hover { background: rgba(255, 255, 255, 0.14); color: #fff; }
.action-btn:disabled { opacity: 0.5; }

.line-clamp-2 {
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
</style>
