import type { H3Event } from 'h3'

/**
 * Registry of allowed Freepik/Magnific AI endpoints.
 *
 * This map is the security boundary for the proxy: the client may only ask the
 * server to call models listed here. Each model exposes a single POST `path`;
 * the matching status endpoint is always `path + '/' + taskId` (Freepik's
 * convention across all async AI endpoints).
 *
 * Endpoint paths verified against https://docs.magnific.com/llms.txt
 */
export interface FreepikModel {
  path: string
  kind: 'image' | 'video'
}

export const FREEPIK_MODELS: Record<string, FreepikModel> = {
  // ---- Image: text-to-image ---- (all paths verified against the live API)
  'mystic': { path: '/v1/ai/mystic', kind: 'image' },
  'flux-2-pro': { path: '/v1/ai/text-to-image/flux-2-pro', kind: 'image' },
  'flux-2-turbo': { path: '/v1/ai/text-to-image/flux-2-turbo', kind: 'image' },
  'flux-pro-1-1': { path: '/v1/ai/text-to-image/flux-pro-v1-1', kind: 'image' },
  'flux-dev': { path: '/v1/ai/text-to-image/flux-dev', kind: 'image' },
  'hyperflux': { path: '/v1/ai/text-to-image/hyperflux', kind: 'image' },
  'seedream-v4': { path: '/v1/ai/text-to-image/seedream-v4', kind: 'image' },
  'seedream-v4-5': { path: '/v1/ai/text-to-image/seedream-v4-5', kind: 'image' },
  'imagen3': { path: '/v1/ai/text-to-image/imagen3', kind: 'image' },
  'runway-t2i': { path: '/v1/ai/text-to-image/runway', kind: 'image' },

  // ---- Video: image-to-video ----
  'kling-v2': { path: '/v1/ai/image-to-video/kling-v2', kind: 'video' },
  'kling-v2-5-pro': { path: '/v1/ai/image-to-video/kling-v2-5-pro', kind: 'video' },
  'minimax-hailuo-02-1080p': { path: '/v1/ai/image-to-video/minimax-hailuo-02-1080p', kind: 'video' },
  'minimax-hailuo-2-3-1080p': { path: '/v1/ai/image-to-video/minimax-hailuo-2-3-1080p', kind: 'video' },
  'wan-v2-6-1080p': { path: '/v1/ai/image-to-video/wan-v2-6-1080p', kind: 'video' },

  // ---- Video: start/end frame (image + image_tail) ----
  'kling-pro': { path: '/v1/ai/image-to-video/kling-pro', kind: 'video' },

  // ---- Video: text-to-video ----
  'ltx-2-pro': { path: '/v1/ai/text-to-video/ltx-2-pro', kind: 'video' }
}

export function resolveModel(id: unknown): FreepikModel {
  const model = typeof id === 'string' ? FREEPIK_MODELS[id] : undefined
  if (!model) {
    throw createError({ statusCode: 400, statusMessage: `Unknown model: ${String(id)}` })
  }
  return model
}

/**
 * Call the Freepik API with the server-side key attached. Normalises Freepik
 * error responses into readable H3 errors so the UI can show what went wrong.
 */
export async function freepikFetch<T = any>(
  path: string,
  options: { method?: string; body?: unknown } = {}
): Promise<T> {
  const config = useRuntimeConfig()
  const apiKey = config.freepikApiKey

  if (!apiKey) {
    throw createError({
      statusCode: 500,
      statusMessage: 'FREEPIK_API_KEY is not configured on the server.'
    })
  }

  const base = (config.freepikBaseUrl || 'https://api.freepik.com').replace(/\/$/, '')

  try {
    return await $fetch<T>(`${base}${path}`, {
      method: (options.method as any) || 'GET',
      body: options.body as any,
      headers: {
        'x-freepik-api-key': apiKey,
        'Content-Type': 'application/json'
      }
    })
  } catch (err: any) {
    // $fetch throws FetchError; surface the upstream message + status.
    const status = err?.response?.status || err?.statusCode || 502
    const data = err?.data
    const message =
      data?.message ||
      (Array.isArray(data?.errors) ? data.errors.map((e: any) => e?.message || e).join('; ') : null) ||
      data?.error ||
      err?.message ||
      'Freepik API request failed'
    throw createError({ statusCode: status, statusMessage: message, data })
  }
}

/**
 * Build the public webhook callback URL for this deployment, or null when the
 * app is running locally (Freepik can't reach localhost, so we rely on polling).
 */
export function buildWebhookUrl(event: H3Event): string | null {
  const config = useRuntimeConfig()
  const host = getRequestHost(event, { xForwardedHost: true })
  if (!host || host.includes('localhost') || host.startsWith('127.') || host.startsWith('0.0.0.0')) {
    return null
  }
  const proto = getRequestProtocol(event, { xForwardedProto: true }) || 'https'
  const token = config.freepikWebhookSecret
  const query = token ? `?token=${encodeURIComponent(token)}` : ''
  return `${proto}://${host}/api/ai/webhook${query}`
}
