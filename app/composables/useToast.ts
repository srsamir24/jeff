export const useToast = () => {
  const toasts = useState('toasts', () => [])

  const add = (toast) => {
    const id = Date.now().toString()
    toasts.value.push({
      id,
      type: 'success', // success, error, info, warning
      duration: 3000,
      ...toast
    })

    if (toast.duration !== 0) {
      setTimeout(() => {
        remove(id)
      }, toast.duration || 3000)
    }
  }

  const remove = (id) => {
    toasts.value = toasts.value.filter(t => t.id !== id)
  }

  return {
    toasts,
    add,
    remove,
    success: (message, duration) => add({ message, type: 'success', duration }),
    error: (message, duration) => add({ message, type: 'error', duration }),
    info: (message, duration) => add({ message, type: 'info', duration }),
    warning: (message, duration) => add({ message, type: 'warning', duration })
  }
}
