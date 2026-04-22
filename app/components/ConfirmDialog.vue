<template>
  <Teleport to="body">
    <Transition name="fade">
      <div v-if="show" class="fixed inset-0 z-[1000] flex items-center justify-center p-6 bg-[#080210]/90 backdrop-blur-md">
        <div 
          class="w-full max-w-sm space-y-12 animate-fade-in"
          @click.stop
        >
          <div class="space-y-6 text-center">
            <h3 class="text-3xl font-bold text-white tracking-tighter" style="font-family: 'Space Grotesk', sans-serif;">
              Are you sure?
            </h3>
            <p class="text-white/40 text-sm leading-relaxed max-w-[280px] mx-auto">
              {{ message }}
            </p>
          </div>

          <div class="space-y-4">
            <button
              @click="$emit('confirm')"
              class="w-full group py-4 transition-all duration-500 relative overflow-hidden bg-white/5"
            >
              <div class="relative z-10 flex items-center justify-center">
                <span class="text-white text-[10px] uppercase tracking-[0.3em] font-medium group-hover:tracking-[0.4em] transition-all duration-500">Confirm Action</span>
              </div>
              <div class="absolute inset-0 bg-white/5 transform scale-x-0 group-hover:scale-x-100 transition-transform duration-500 origin-left"></div>
            </button>

            <button
              @click="$emit('cancel')"
              class="w-full group py-4 transition-all duration-500 relative overflow-hidden"
            >
              <div class="relative z-10 flex items-center justify-center">
                <span class="text-white/30 group-hover:text-white text-[10px] uppercase tracking-[0.3em] font-medium transition-all duration-500">Cancel</span>
              </div>
            </button>
          </div>
        </div>
      </div>
    </Transition>
  </Teleport>
</template>

<script setup>
defineProps({
  show: { type: Boolean, required: true },
  message: { type: String, required: true }
})

defineEmits(['confirm', 'cancel'])
</script>

<style scoped>
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.4s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

.animate-fade-in {
  animation: fadeIn 0.8s cubic-bezier(0.16, 1, 0.3, 1) forwards;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(20px); }
  to { opacity: 1; transform: translateY(0); }
}
</style>

