import { serverSupabaseUser } from '#supabase/server'

/**
 * Same-origin proxy for fetching generated assets, so the browser can download
 * or re-upload them without hitting CORS on Freepik's CDN.
 * Query: ?url=<asset url>&download=1 (optional, forces attachment)
 *
 * Restricted to known Freepik / Magnific / Google Storage hosts.
 */
const ALLOWED_HOST_SUFFIXES = [
  'freepik.com',
  'magnific.com',
  'googleapis.com',
  'storage.googleapis.com',
  'cloudfront.net',
  'amazonaws.com'
]

export default defineEventHandler(async (event) => {
  const user = await serverSupabaseUser(event).catch(() => null)
  if (!user) {
    throw createError({ statusCode: 401, statusMessage: 'Authentication required' })
  }

  const query = getQuery(event)
  const rawUrl = String(query.url || '')
  if (!rawUrl) {
    throw createError({ statusCode: 400, statusMessage: 'url is required' })
  }

  let target: URL
  try {
    target = new URL(rawUrl)
  } catch {
    throw createError({ statusCode: 400, statusMessage: 'Invalid url' })
  }

  if (target.protocol !== 'https:' || !ALLOWED_HOST_SUFFIXES.some((h) => target.hostname.endsWith(h))) {
    throw createError({ statusCode: 403, statusMessage: 'Host not allowed' })
  }

  const upstream = await fetch(target.toString())
  if (!upstream.ok || !upstream.body) {
    throw createError({ statusCode: 502, statusMessage: `Failed to fetch asset (${upstream.status})` })
  }

  const contentType = upstream.headers.get('content-type') || 'application/octet-stream'
  setHeader(event, 'content-type', contentType)
  setHeader(event, 'cache-control', 'private, max-age=300')

  if (query.download) {
    const ext = contentType.includes('video') ? 'mp4' : contentType.split('/')[1] || 'bin'
    const name = `generation-${Date.now()}.${ext}`
    setHeader(event, 'content-disposition', `attachment; filename="${name}"`)
  }

  return upstream.body
})
