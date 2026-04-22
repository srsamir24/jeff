<template>
  <section class="relative min-h-[90vh] flex items-center justify-center overflow-hidden pt-20">
    <!-- Subtle animated background blobs -->
    <div class="absolute inset-0 pointer-events-none">
      <div
        class="absolute top-1/4 left-1/4 w-72 h-72 md:w-96 md:h-96 bg-light-green/15 dark:bg-light-green/10 rounded-full blur-3xl animate-blob"
      />
      <div
        class="absolute bottom-1/4 right-1/4 w-72 h-72 md:w-96 md:h-96 bg-lighter-pink/15 dark:bg-lighter-pink/10 rounded-full blur-3xl animate-blob animation-delay-2000"
      />
      <div
        class="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-72 h-72 md:w-96 md:h-96 bg-light-blue/15 dark:bg-light-blue/10 rounded-full blur-3xl animate-blob animation-delay-4000"
      />
    </div>

    <div class="relative z-10 max-w-5xl mx-auto px-6 text-center">
      <p class="text-sm md:text-base tracking-widest uppercase text-neutral-500 dark:text-neutral-400 mb-6">
        Graphic Designer
      </p>
      <h1 class="font-[Gendy] text-5xl sm:text-6xl md:text-7xl lg:text-8xl text-neutral-900 dark:text-neutral-50 mb-6 leading-tight">
        Anna Ericyan
      </h1>
      <p class="text-lg md:text-xl text-neutral-600 dark:text-neutral-400 max-w-2xl mx-auto mb-10 leading-relaxed">
        {{ subtitle }}
      </p>
      <div class="flex flex-col sm:flex-row items-center justify-center gap-4">
        <NuxtLink to="/work">
          <AppButton variant="primary" size="lg">
            View My Work
            <template #iconRight>
              <UIcon name="lucide:arrow-right" class="w-5 h-5" />
            </template>
          </AppButton>
        </NuxtLink>
        <NuxtLink to="/contact">
          <AppButton variant="ghost" size="lg">
            Let's Connect
          </AppButton>
        </NuxtLink>
      </div>
    </div>

    <!-- Scroll indicator -->
    <div class="absolute bottom-8 left-1/2 -translate-x-1/2 flex flex-col items-center gap-2 text-neutral-400 dark:text-neutral-600">
      <span class="text-xs tracking-widest uppercase">Scroll</span>
      <div class="w-px h-8 bg-neutral-300 dark:bg-neutral-700 animate-pulse" />
    </div>
  </section>
</template>

<script setup>
defineProps({
  subtitle: {
    type: String,
    required: true
  }
})
</script>
