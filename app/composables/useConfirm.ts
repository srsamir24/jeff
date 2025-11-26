export const useConfirm = () => {
  const showDialog = ref(false);
  const message = ref("");
  const resolvePromise = ref<((value: boolean) => void) | null>(null);

  const confirm = (msg: string): Promise<boolean> => {
    message.value = msg;
    showDialog.value = true;

    return new Promise((resolve) => {
      resolvePromise.value = resolve;
    });
  };

  const handleConfirm = () => {
    showDialog.value = false;
    if (resolvePromise.value) {
      resolvePromise.value(true);
      resolvePromise.value = null;
    }
  };

  const handleCancel = () => {
    showDialog.value = false;
    if (resolvePromise.value) {
      resolvePromise.value(false);
      resolvePromise.value = null;
    }
  };

  return {
    showDialog,
    message,
    confirm,
    handleConfirm,
    handleCancel,
  };
};
