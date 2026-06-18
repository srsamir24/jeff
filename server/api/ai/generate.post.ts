import { serverSupabaseUser } from '#supabase/server'
import { resolveModel, freepikFetch, buildWebhookUrl } from '~~/server/utils/freepik'

/**
 * Submit an image or video generation task to Freepik.
 * Body: { model: string, payload: Record<string, any> }
 * Returns: { taskId, status, model }
 */
export default defineEventHandler(async (event) => {
  // Only authenticated admins may spend account credits.
  const user = await serverSupabaseUser(event).catch(() => null)
  if (!user) {
    throw createError({ statusCode: 401, statusMessage: 'Authentication required' })
  }

  const body = await readBody<{ model?: string; payload?: Record<string, any> }>(event)
  const model = resolveModel(body?.model)
  const payload = { ...(body?.payload || {}) }

  // Attach a callback URL in production so results arrive via webhook too.
  const webhookUrl = buildWebhookUrl(event)
  if (webhookUrl) payload.webhook_url = webhookUrl

  const res = await freepikFetch<{ data?: any } & any>(model.path, {
    method: 'POST',
    body: payload
  })

  const data = res?.data ?? res
  return {
    taskId: data?.task_id,
    status: data?.status ?? 'CREATED',
    model: body!.model
  }
})
