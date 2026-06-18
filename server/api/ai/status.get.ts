import { serverSupabaseUser } from '#supabase/server'
import { resolveModel, freepikFetch } from '~~/server/utils/freepik'
import { getTask } from '~~/server/utils/taskStore'

/**
 * Poll the status of a generation task.
 * Query: ?model=<id>&taskId=<uuid>
 * Returns: { taskId, status, generated: string[], source }
 *
 * Prefers a webhook-delivered result (instant) and falls back to polling the
 * Freepik status endpoint when no webhook arrived (e.g. local development).
 */
export default defineEventHandler(async (event) => {
  const user = await serverSupabaseUser(event).catch(() => null)
  if (!user) {
    throw createError({ statusCode: 401, statusMessage: 'Authentication required' })
  }

  const query = getQuery(event)
  const model = resolveModel(query.model)
  const taskId = String(query.taskId || '')
  if (!taskId) {
    throw createError({ statusCode: 400, statusMessage: 'taskId is required' })
  }

  // Webhook short-circuit.
  const cached = getTask(taskId)
  if (cached && (cached.status === 'COMPLETED' || cached.status === 'FAILED')) {
    return { taskId, status: cached.status, generated: cached.generated, source: 'webhook' }
  }

  const statusBase = model.statusPath || model.path
  const res = await freepikFetch<{ data?: any } & any>(`${statusBase}/${taskId}`, { method: 'GET' })
  const data = res?.data ?? res
  return {
    taskId,
    status: data?.status ?? 'IN_PROGRESS',
    generated: data?.generated ?? [],
    source: 'poll'
  }
})
