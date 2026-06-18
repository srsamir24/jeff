import { setTask } from '~~/server/utils/taskStore'

/**
 * Receives async task results from Freepik (production only).
 * Protected by the ?token= query matching FREEPIK_WEBHOOK_SECRET.
 *
 * Per Freepik docs the webhook payload mirrors the GET status response but
 * without the `data` wrapper: { task_id, status, generated: [...] }.
 */
export default defineEventHandler(async (event) => {
  const config = useRuntimeConfig()
  const token = getQuery(event).token

  if (config.freepikWebhookSecret && token !== config.freepikWebhookSecret) {
    throw createError({ statusCode: 401, statusMessage: 'Invalid webhook token' })
  }

  const body = await readBody<any>(event)
  const payload = body?.data ?? body
  const taskId = payload?.task_id

  if (taskId) {
    setTask(String(taskId), {
      status: payload?.status ?? 'COMPLETED',
      generated: payload?.generated ?? []
    })
  }

  return { received: true }
})
