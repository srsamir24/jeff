<template>
  <div class="fixed top-4 right-4 z-50 flex flex-col gap-2 pointer-events-none">
    <TransitionGroup
      enter-active-class="transition duration-300 ease-out"
      enter-from-class="-translate-y-2 opacity-0"
      enter-to-class="translate-y-0 opacity-100"
      leave-active-class="transition duration-200 ease-in"
      leave-from-class="translate-y-0 opacity-100"
      leave-to-class="-translate-y-2 opacity-0"
      move-class="transition duration-300 ease-in-out"
    >
      <div
        v-for="toast in toasts"
        :key="toast.id"
        class="pointer-events-auto min-w-[300px] max-w-md p-4 rounded-xl shadow-lg border-l-4 flex items-start gap-3 bg-portfolio-white dark:bg-neutral-900 text-neutral-800 dark:text-neutral-200"
        :class="{
          'border-light-green': toast.type === 'success',
          'border-bright-pink': toast.type === 'error',
          'border-light-blue': toast.type === 'info',
          'border-lighter-pink': toast.type === 'warning'
        }"
      >
        <div class="shrink-0 mt-0.5">
          <UIcon
            v-if="toast.type === 'success'"
            name="lucide:check-circle"
            class="w-5 h-5 text-light-green"
          />
          <UIcon
            v-else-if="toast.type === 'error'"
            name="lucide:x-circle"
            class="w-5 h-5 text-bright-pink"
          />
          <UIcon
            v-else-if="toast.type === 'warning'"
            name="lucide:alert-triangle"
            class="w-5 h-5 text-lighter-pink"
          />
          <UIcon
            v-else
            name="lucide:info"
            class="w-5 h-5 text-light-blue"
          />
        </div>

        <div class="flex-1">
          <p class="text-sm font-medium">{{ toast.message }}</p>
        </div>

        <button
          class="shrink-0 text-neutral-400 dark:text-neutral-600 hover:text-neutral-600 dark:hover:text-neutral-300 transition-colors"
          @click="remove(toast.id)"
        >
          <UIcon name="lucide:x" class="w-4 h-4" />
        </button>
      </div>
    </TransitionGroup>
  </div>
</template>

<script setup>
const { toasts, remove } = useAppToast()
</script>
