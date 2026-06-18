/**
 * Client helper for the AI Studio: declarative model catalogue + submit/poll
 * helpers that talk to our server proxy (which holds the Freepik API key).
 *
 * Each model declares exactly which inputs the form should render (prompt,
 * image slots, scalar controls) so the UI adapts per model — text-to-image,
 * reference-image, image-to-video, start/end-frame and text-to-video all share
 * one form driven by this data.
 */

export type ModelKind = 'image' | 'video'

/** An image upload slot. `format` decides how we hand the file to Freepik. */
export interface ImageSlot {
  key: string // request body field name (e.g. image, image_tail, style_reference)
  label: string
  format: 'url' | 'base64'
  required?: boolean
  hint?: string
}

export interface ModelControls {
  aspectRatio?: boolean
  resolution?: boolean
  styleModel?: boolean
  hdr?: boolean
  duration?: boolean
  cfgScale?: boolean
  negativePrompt?: boolean
}

export interface StudioModel {
  id: string
  label: string
  kind: ModelKind // output type
  group: string // category, used for grouping in the picker
  badge?: string
  blurb: string
  prompt: 'required' | 'optional' | 'none'
  images: ImageSlot[]
  controls: ModelControls
}

const URL_IMG = (key: string, label: string, required = false, hint?: string): ImageSlot =>
  ({ key, label, format: 'url', required, hint })

export const STUDIO_MODELS: StudioModel[] = [
  // ───────── Text → Image ─────────
  {
    id: 'mystic', label: 'Mystic', kind: 'image', group: 'Text → Image', badge: 'Flagship',
    blurb: 'Highest fidelity up to 4K. Accepts optional structure & style reference images.',
    prompt: 'required',
    images: [
      { key: 'structure_reference', label: 'Structure reference', format: 'base64', hint: 'Keep this image’s composition' },
      { key: 'style_reference', label: 'Style reference', format: 'base64', hint: 'Match this image’s look' }
    ],
    controls: { aspectRatio: true, resolution: true, styleModel: true, hdr: true }
  },
  { id: 'flux-2-pro', label: 'Flux 2 Pro', kind: 'image', group: 'Text → Image', badge: 'New', blurb: 'Latest Flux — superb prompt adherence & detail.', prompt: 'required', images: [], controls: { aspectRatio: true } },
  { id: 'flux-2-turbo', label: 'Flux 2 Turbo', kind: 'image', group: 'Text → Image', badge: 'Fast', blurb: 'Flux 2 quality at draft speed.', prompt: 'required', images: [], controls: { aspectRatio: true } },
  { id: 'flux-pro-1-1', label: 'Flux Pro 1.1', kind: 'image', group: 'Text → Image', blurb: 'Reliable, balanced photoreal output.', prompt: 'required', images: [], controls: { aspectRatio: true } },
  { id: 'flux-dev', label: 'Flux Dev', kind: 'image', group: 'Text → Image', blurb: 'Cost-effective everyday generations.', prompt: 'required', images: [], controls: { aspectRatio: true } },
  { id: 'hyperflux', label: 'Hyperflux', kind: 'image', group: 'Text → Image', badge: 'Fast', blurb: 'Ultra-fast drafts and iterations.', prompt: 'required', images: [], controls: { aspectRatio: true } },
  { id: 'seedream-v4', label: 'Seedream 4', kind: 'image', group: 'Text → Image', blurb: 'Great typography and composition.', prompt: 'required', images: [], controls: { aspectRatio: true } },
  { id: 'seedream-v4-5', label: 'Seedream 4.5', kind: 'image', group: 'Text → Image', badge: 'New', blurb: 'Latest Seedream, sharper detail.', prompt: 'required', images: [], controls: { aspectRatio: true } },
  { id: 'imagen3', label: 'Imagen 3', kind: 'image', group: 'Text → Image', blurb: 'Google Imagen 3 — clean, accurate scenes.', prompt: 'required', images: [], controls: { aspectRatio: true } },
  { id: 'runway-t2i', label: 'Runway', kind: 'image', group: 'Text → Image', blurb: 'Runway’s text-to-image model.', prompt: 'required', images: [], controls: { aspectRatio: true } },

  // ───────── Image → Video ─────────
  {
    id: 'kling-v2', label: 'Kling 2.0', kind: 'video', group: 'Image → Video', badge: 'Recommended',
    blurb: 'Smooth, coherent motion from a still image.', prompt: 'optional',
    images: [URL_IMG('image', 'Source image', true)],
    controls: { duration: true, cfgScale: true, negativePrompt: true }
  },
  {
    id: 'kling-v2-5-pro', label: 'Kling 2.5 Pro', kind: 'video', group: 'Image → Video', badge: 'Pro',
    blurb: 'Highest-quality Kling motion.', prompt: 'optional',
    images: [URL_IMG('image', 'Source image', true)],
    controls: { duration: true, cfgScale: true, negativePrompt: true }
  },
  {
    id: 'minimax-hailuo-02-1080p', label: 'Hailuo 02', kind: 'video', group: 'Image → Video',
    blurb: 'Cinematic 1080p clips.', prompt: 'optional',
    images: [URL_IMG('image', 'Source image', true)],
    controls: { duration: true }
  },
  {
    id: 'minimax-hailuo-2-3-1080p', label: 'Hailuo 2.3', kind: 'video', group: 'Image → Video', badge: 'New',
    blurb: 'Newer Hailuo with stronger motion.', prompt: 'optional',
    images: [URL_IMG('image', 'Source image', true)],
    controls: { duration: true }
  },
  {
    id: 'wan-v2-6-1080p', label: 'Wan 2.6', kind: 'video', group: 'Image → Video',
    blurb: 'Wan 2.6 — crisp 1080p image-to-video.', prompt: 'optional',
    images: [URL_IMG('image', 'Source image', true)],
    controls: { duration: true }
  },

  // ───────── Start / End frame → Video ─────────
  {
    id: 'kling-pro', label: 'Kling 1.6 Pro', kind: 'video', group: 'Start / End Frame → Video', badge: 'Keyframes',
    blurb: 'Interpolates motion between a start frame and an optional end frame.', prompt: 'optional',
    images: [
      URL_IMG('image', 'Start frame', true),
      URL_IMG('image_tail', 'End frame', false, 'Optional — animate toward this frame')
    ],
    controls: { duration: true, cfgScale: true, negativePrompt: true }
  },

  // ───────── Text → Video ─────────
  {
    id: 'ltx-2-pro', label: 'LTX 2.0 Pro', kind: 'video', group: 'Text → Video', badge: 'No image',
    blurb: 'Generate video directly from a prompt — no source image needed.', prompt: 'required',
    images: [],
    controls: { duration: true }
  }
]

export const IMAGE_MODELS = STUDIO_MODELS.filter((m) => m.kind === 'image')
export const VIDEO_MODELS = STUDIO_MODELS.filter((m) => m.kind === 'video')

/** Group an array of models by their `group` field, preserving order. */
export function groupModels(models: StudioModel[]): { group: string; models: StudioModel[] }[] {
  const out: { group: string; models: StudioModel[] }[] = []
  for (const m of models) {
    let bucket = out.find((g) => g.group === m.group)
    if (!bucket) { bucket = { group: m.group, models: [] }; out.push(bucket) }
    bucket.models.push(m)
  }
  return out
}

export const ASPECT_RATIOS = [
  { value: 'square_1_1', label: 'Square · 1:1' },
  { value: 'widescreen_16_9', label: 'Landscape · 16:9' },
  { value: 'social_story_9_16', label: 'Vertical · 9:16' },
  { value: 'classic_4_3', label: 'Classic · 4:3' },
  { value: 'traditional_3_4', label: 'Portrait · 3:4' },
  { value: 'standard_3_2', label: 'Photo · 3:2' },
  { value: 'portrait_2_3', label: 'Portrait · 2:3' },
  { value: 'social_post_4_5', label: 'Social · 4:5' }
]

export const RESOLUTIONS = [
  { value: '1k', label: '1K' },
  { value: '2k', label: '2K' },
  { value: '4k', label: '4K' }
]

export const MYSTIC_STYLES = [
  { value: 'realism', label: 'Realism' },
  { value: 'super_real', label: 'Super Real' },
  { value: 'fluid', label: 'Fluid' },
  { value: 'zen', label: 'Zen' },
  { value: 'flexible', label: 'Flexible' },
  { value: 'editorial_portraits', label: 'Editorial Portraits' }
]

export const DURATIONS = [
  { value: '5', label: '5 seconds' },
  { value: '10', label: '10 seconds' }
]

export type TaskStatus = 'CREATED' | 'IN_PROGRESS' | 'COMPLETED' | 'FAILED' | string

export interface GenerateResponse { taskId: string; status: TaskStatus; model: string }
export interface StatusResponse { taskId: string; status: TaskStatus; generated: string[]; source: 'webhook' | 'poll' }

/** Read a File as a raw base64 string (no data: prefix), plus a preview data URI. */
export function fileToBase64(file: File): Promise<{ raw: string; dataUri: string }> {
  return new Promise((resolve, reject) => {
    const reader = new FileReader()
    reader.onload = () => {
      const dataUri = String(reader.result)
      resolve({ raw: dataUri.split(',')[1] || '', dataUri })
    }
    reader.onerror = reject
    reader.readAsDataURL(file)
  })
}

export const useAiStudio = () => {
  const generate = (model: string, payload: Record<string, any>) =>
    $fetch<GenerateResponse>('/api/ai/generate', { method: 'POST', body: { model, payload } })

  const getStatus = (model: string, taskId: string) =>
    $fetch<StatusResponse>('/api/ai/status', { query: { model, taskId } })

  const pollTask = async (
    model: string,
    taskId: string,
    opts: { onTick?: (s: StatusResponse) => void; intervalMs?: number; timeoutMs?: number } = {}
  ): Promise<StatusResponse> => {
    const interval = opts.intervalMs ?? 4000
    const timeout = opts.timeoutMs ?? 1000 * 60 * 10
    const start = Date.now()
    await new Promise((r) => setTimeout(r, 1500))

    while (true) {
      const res = await getStatus(model, taskId)
      opts.onTick?.(res)
      if (res.status === 'COMPLETED' || res.status === 'FAILED') return res
      if (Date.now() - start > timeout) return { taskId, status: 'FAILED', generated: [], source: res.source }
      await new Promise((r) => setTimeout(r, interval))
    }
  }

  const proxyUrl = (url: string, download = false) =>
    `/api/ai/proxy?url=${encodeURIComponent(url)}${download ? '&download=1' : ''}`

  return { generate, getStatus, pollTask, proxyUrl }
}
