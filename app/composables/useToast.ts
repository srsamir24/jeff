export interface Toast {
  id: string;
  message: string;
  type?: "success" | "error" | "info" | "warning";
  duration?: number;
}

export const useToast = () => {
  const toasts = useState<Toast[]>("toasts", () => []);

  const add = (toast: Omit<Toast, "id">) => {
    const id = Date.now().toString();
    const newToast: Toast = {
      id,
      type: "success", // success, error, info, warning
      duration: 3000,
      ...toast,
    };
    toasts.value.push(newToast);

    if (toast.duration !== 0) {
      setTimeout(() => {
        remove(id);
      }, toast.duration || 3000);
    }
  };

  const remove = (id: string) => {
    toasts.value = toasts.value.filter((t) => t.id !== id);
  };

  return {
    toasts,
    add,
    remove,
    success: (message: string, duration?: number) =>
      add({ message, type: "success", duration }),
    error: (message: string, duration?: number) =>
      add({ message, type: "error", duration }),
    info: (message: string, duration?: number) =>
      add({ message, type: "info", duration }),
    warning: (message: string, duration?: number) =>
      add({ message, type: "warning", duration }),
  };
};
