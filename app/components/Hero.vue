<template>
  <section class="relative overflow-hidden bg-linear-to-br from-portfolio-white via-light-blue/10 to-lighter-pink/10 pt-24 pb-16 md:pt-28 md:pb-20">
    <!-- Animated background elements -->
    <div class="absolute top-0 left-0 w-96 h-96 bg-light-green/20 rounded-full blur-3xl -translate-x-1/2 -translate-y-1/2 animate-blob"></div>
    <div class="absolute bottom-0 right-0 w-96 h-96 bg-bright-pink/20 rounded-full blur-3xl translate-x-1/2 translate-y-1/2 animate-blob animation-delay-2000"></div>
    <div class="absolute top-1/2 left-1/2 w-96 h-96 bg-blue-purple/10 rounded-full blur-3xl -translate-x-1/2 -translate-y-1/2 animate-blob animation-delay-4000"></div>

    <div class="container mx-auto px-6 relative z-10">
      <div class="flex flex-col lg:flex-row items-center justify-between gap-16">
        <!-- Hero Text -->
        <div class="flex-1 text-center lg:text-left space-y-6 max-w-2xl">
          <h1 class="text-5xl md:text-6xl lg:text-7xl font-bold leading-tight">
            <span class="block text-gray-800 mb-2">Hi, I'm</span>
            <span class="block bg-clip-text text-transparent bg-linear-to-r from-bright-pink via-blue-purple to-light-blue animate-gradient">
              Anna Ericyan
            </span>
          </h1>

          <p class="text-xl md:text-2xl text-gray-600 leading-relaxed max-w-xl">
            {{ subtitle || 'A passionate graphics designer crafting beautiful, meaningful visual experiences that tell your story and captivate your audience.' }}
          </p>

          <div class="flex flex-col sm:flex-row gap-4 justify-center lg:justify-start pt-4">
            <NuxtLink to="/work">
              <AppButton variant="secondary" size="lg">
                View My Work
              </AppButton>
            </NuxtLink>

            <NuxtLink to="/contact">
              <AppButton variant="outline" size="lg">
                Let's Connect
              </AppButton>
            </NuxtLink>
          </div>
        </div>

        <!-- Hero Visual -->
        <div class="flex-1 flex justify-center lg:justify-end">
          <div class="relative w-full max-w-md lg:max-w-lg">
            <!-- Main image container -->
            <div class="relative aspect-square rounded-3xl overflow-hidden shadow-2xl">
              <div class="absolute inset-0 bg-linear-to-br from-light-green/40 via-light-blue/40 to-lighter-pink/40 backdrop-blur-sm flex items-center justify-center">
                <div class="text-center p-8">
                  <div class="w-40 h-40 mx-auto bg-portfolio-white/60 backdrop-blur-md rounded-full flex items-center justify-center mb-6 shadow-lg">
                    <svg class="w-24 h-24 text-blue-purple" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                    </svg>
                  </div>
                  <p class="text-gray-700 font-medium text-sm">Your portrait or creative artwork here</p>
                </div>
              </div>
            </div>

            <!-- Decorative floating elements -->
            <div class="absolute -top-6 -left-6 w-20 h-20 bg-bright-pink rounded-2xl shadow-xl transform rotate-12 opacity-80 hover:rotate-0 transition-transform duration-300 -z-10"></div>
            <div class="absolute -bottom-6 -right-6 w-28 h-28 bg-light-green rounded-full shadow-xl opacity-80 -z-10"></div>
            <div class="absolute top-1/4 -right-4 w-16 h-16 bg-blue-purple/20 rounded-lg transform rotate-45 backdrop-blur-sm -z-10"></div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
defineProps({
  subtitle: {
    type: String,
    default: ''
  }
})
</script>
