/**
 * In-memory store for webhook-delivered task results.
 *
 * When Freepik posts a completed task to /api/ai/webhook (production only), we
 * stash the result here so the status endpoint can return it instantly without
 * re-polling Freepik. In dev (no public URL) this stays empty and the status
 * endpoint falls back to polling — both paths work.
 *
 * Kept on globalThis so it survives Nitro hot-reloads during development.
 */
export interface TaskResult {
  status: string
  generated: string[]
  at: number
}

const TTL_MS = 60 * 60 * 1000 // 1 hour

const store: Map<string, TaskResult> =
  (globalThis as any).__aiTaskStore || ((globalThis as any).__aiTaskStore = new Map())

function prune() {
  const now = Date.now()
  for (const [key, value] of store) {
    if (now - value.at > TTL_MS) store.delete(key)
  }
}

export function setTask(id: string, result: Omit<TaskResult, 'at'>) {
  store.set(id, { ...result, at: Date.now() })
  prune()
}

export function getTask(id: string): TaskResult | undefined {
  return store.get(id)
}
