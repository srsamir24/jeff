/**
 * Client helper for the AI Studio: model catalogue + submit/poll helpers that
 * talk to our server proxy (which holds the Freepik API key).
 */

export type ModelKind = 'image' | 'video'

export interface StudioModel {
  id: string
  label: string
  kind: ModelKind
  badge?: string
  blurb: string
  features?: {
    resolution?: boolean
    styleModel?: boolean
    hdr?: boolean
    cfgScale?: boolean
  }
}

export const IMAGE_MODELS: StudioModel[] = [
  { id: 'mystic', label: 'Mystic', kind: 'image', badge: 'Flagship', blurb: 'Highest fidelity, up to 4K, full styling controls.', features: { resolution: true, styleModel: true, hdr: true } },
  { id: 'flux-2-pro', label: 'Flux 2 Pro', kind: 'image', badge: 'New', blurb: 'Latest Flux, excellent prompt adherence.' },
  { id: 'flux-2-turbo', label: 'Flux 2 Turbo', kind: 'image', badge: 'Fast', blurb: 'Quick Flux 2 generations.' },
  { id: 'flux-pro-1-1', label: 'Flux Pro 1.1', kind: 'image', blurb: 'Reliable, balanced photoreal output.' },
  { id: 'flux-dev', label: 'Flux Dev', kind: 'image', blurb: 'Cost-effective everyday generations.' },
  { id: 'hyperflux', label: 'Hyperflux', kind: 'image', badge: 'Fast', blurb: 'Ultra-fast drafts and iterations.' },
  { id: 'seedream-v4-5', label: 'Seedream 4.5', kind: 'image', blurb: 'Strong on typography and composition.' }
]

export const VIDEO_MODELS: StudioModel[] = [
  { id: 'kling-v2', label: 'Kling 2.0', kind: 'video', badge: 'Recommended', blurb: 'Smooth, coherent motion from a still image.', features: { cfgScale: true } },
  { id: 'kling-v2-5-pro', label: 'Kling 2.5 Pro', kind: 'video', badge: 'Pro', blurb: 'Highest-quality Kling motion.', features: { cfgScale: true } },
  { id: 'seedance-pro-1080p', label: 'Seedance Pro', kind: 'video', blurb: 'Dynamic 1080p motion.' },
  { id: 'minimax-hailuo-02-1080p', label: 'Hailuo 02', kind: 'video', blurb: 'Cinematic 1080p clips.' }
]

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

export interface GenerateResponse {
  taskId: string
  status: TaskStatus
  model: string
}

export interface StatusResponse {
  taskId: string
  status: TaskStatus
  generated: string[]
  source: 'webhook' | 'poll'
}

export const useAiStudio = () => {
  const generate = (model: string, payload: Record<string, any>) =>
    $fetch<GenerateResponse>('/api/ai/generate', { method: 'POST', body: { model, payload } })

  const getStatus = (model: string, taskId: string) =>
    $fetch<StatusResponse>('/api/ai/status', { query: { model, taskId } })

  /**
   * Poll a task until it reaches a terminal state (or times out).
   * Calls `onTick(status)` on every poll so the UI can show progress.
   */
  const pollTask = async (
    model: string,
    taskId: string,
    opts: { onTick?: (s: StatusResponse) => void; intervalMs?: number; timeoutMs?: number } = {}
  ): Promise<StatusResponse> => {
    const interval = opts.intervalMs ?? 4000
    const timeout = opts.timeoutMs ?? 1000 * 60 * 8 // 8 min ceiling
    const start = Date.now()

    // small initial delay so the task has time to register
    await new Promise((r) => setTimeout(r, 1500))

    while (true) {
      const res = await getStatus(model, taskId)
      opts.onTick?.(res)

      if (res.status === 'COMPLETED' || res.status === 'FAILED') return res
      if (Date.now() - start > timeout) {
        return { taskId, status: 'FAILED', generated: [], source: res.source }
      }
      await new Promise((r) => setTimeout(r, interval))
    }
  }

  /** Same-origin proxy URL for downloading / re-uploading a generated asset. */
  const proxyUrl = (url: string, download = false) =>
    `/api/ai/proxy?url=${encodeURIComponent(url)}${download ? '&download=1' : ''}`

  return { generate, getStatus, pollTask, proxyUrl }
}
