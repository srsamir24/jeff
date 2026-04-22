<template>
  <section
    ref="sectionRef"
    class="material-thinking bg-charcoal section-padding overflow-hidden relative"
    data-theme="dark"
  >
    <div class="max-w-[1440px] mx-auto px-6 md:px-12 lg:px-[48px]">
      <!-- Header -->
      <div ref="headerRef" class="mb-16">
        <span class="text-overline text-stone block mb-4">MATERIAL STUDIES</span>
        <h2
          class="font-display text-[clamp(32px,5vw,64px)] font-medium text-paper tracking-tight leading-[1.1] max-w-[700px]"
        >
          Material Thinking
        </h2>
        <p class="text-body text-stone mt-4 max-w-[500px]">
          Exploring the tactile world of textures, finishes, and materiality in design.
        </p>
      </div>

      <!-- Bento Grid -->
      <div
        ref="gridRef"
        class="bento-grid grid grid-cols-2 md:grid-cols-4 gap-3 md:gap-4"
      >
        <!-- Feature (large) -->
        <div class="bento-card col-span-2 row-span-2 group cursor-pointer">
          <div class="relative overflow-hidden rounded w-full h-full">
            <img
              src="https://loremflickr.com/800/800/marble?lock=10"
              alt="Carrara Marble study"
              loading="lazy"
              decoding="async"
              class="w-full h-full object-cover transition-transform duration-700 group-hover:scale-105"
            />
            <div
              class="absolute inset-0 bg-gradient-to-t from-charcoal/80 via-charcoal/20 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-500"
            />
            <div class="absolute bottom-0 left-0 p-6 translate-y-4 opacity-0 group-hover:translate-y-0 group-hover:opacity-100 transition-all duration-500">
              <span class="text-overline text-neon-teal block mb-1">STONE</span>
              <h3 class="font-display text-2xl font-medium text-paper">Carrara Marble</h3>
            </div>
          </div>
        </div>

        <!-- Tall -->
        <div class="bento-card col-span-1 row-span-2 group cursor-pointer">
          <div class="relative overflow-hidden rounded w-full h-full">
            <img
              src="https://loremflickr.com/600/900/fabric?lock=11"
              alt="Raw Linen study"
              loading="lazy"
              decoding="async"
              class="w-full h-full object-cover transition-transform duration-700 group-hover:scale-105"
            />
            <div
              class="absolute inset-0 bg-gradient-to-t from-charcoal/80 via-charcoal/20 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-500"
            />
            <div class="absolute bottom-0 left-0 p-4 translate-y-4 opacity-0 group-hover:translate-y-0 group-hover:opacity-100 transition-all duration-500">
              <span class="text-overline text-neon-teal block mb-1">TEXTILE</span>
              <h3 class="font-display text-lg font-medium text-paper">Raw Linen</h3>
            </div>
          </div>
        </div>

        <!-- Standard -->
        <div class="bento-card col-span-1 row-span-1 group cursor-pointer">
          <div class="relative overflow-hidden rounded w-full h-full">
            <img
              src="https://loremflickr.com/600/600/metal?lock=12"
              alt="Brushed Brass study"
              loading="lazy"
              decoding="async"
              class="w-full h-full object-cover transition-transform duration-700 group-hover:scale-105"
            />
            <div
              class="absolute inset-0 bg-gradient-to-t from-charcoal/80 via-charcoal/20 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-500"
            />
            <div class="absolute bottom-0 left-0 p-4 translate-y-4 opacity-0 group-hover:translate-y-0 group-hover:opacity-100 transition-all duration-500">
              <span class="text-overline text-neon-teal block mb-1">METAL</span>
              <h3 class="font-display text-base font-medium text-paper">Brushed Brass</h3>
            </div>
          </div>
        </div>

        <!-- Standard -->
        <div class="bento-card col-span-1 row-span-1 group cursor-pointer">
          <div class="relative overflow-hidden rounded w-full h-full">
            <img
              src="https://loremflickr.com/600/600/concrete?lock=13"
              alt="Poured Concrete study"
              loading="lazy"
              decoding="async"
              class="w-full h-full object-cover transition-transform duration-700 group-hover:scale-105"
            />
            <div
              class="absolute inset-0 bg-gradient-to-t from-charcoal/80 via-charcoal/20 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-500"
            />
            <div class="absolute bottom-0 left-0 p-4 translate-y-4 opacity-0 group-hover:translate-y-0 group-hover:opacity-100 transition-all duration-500">
              <span class="text-overline text-neon-teal block mb-1">CONCRETE</span>
              <h3 class="font-display text-base font-medium text-paper">Poured Concrete</h3>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
import { onMounted, onUnmounted, ref } from 'vue'
import gsap from 'gsap'
import { ScrollTrigger } from 'gsap/ScrollTrigger'

if (process.client) {
  gsap.registerPlugin(ScrollTrigger)
}

const sectionRef = ref(null)
const headerRef = ref(null)
const gridRef = ref(null)

let ctx

onMounted(() => {
  ctx = gsap.context(() => {
    // Header entrance
    gsap.fromTo(
      headerRef.value?.children || [],
      { y: 80, opacity: 0 },
      {
        y: 0,
        opacity: 1,
        duration: 1,
        stagger: 0.15,
        ease: 'expo.out',
        scrollTrigger: {
          trigger: sectionRef.value,
          start: 'top 75%',
          toggleActions: 'play none none none',
        },
      }
    )

    // Bento cards stagger entrance
    const cards = gridRef.value?.querySelectorAll('.bento-card')
    if (cards) {
      gsap.fromTo(
        cards,
        { y: 80, scale: 0.95, opacity: 0 },
        {
          y: 0,
          scale: 1,
          opacity: 1,
          duration: 1,
          stagger: 0.1,
          ease: 'expo.out',
          scrollTrigger: {
            trigger: gridRef.value,
            start: 'top 80%',
            toggleActions: 'play none none none',
          },
        }
      )
    }
  }, sectionRef.value)
})

onUnmounted(() => {
  if (ctx) ctx.revert()
})
</script>

<style scoped>
.material-thinking {
  padding-top: 120px;
  padding-bottom: 120px;
}

.bento-grid {
  grid-auto-rows: 200px;
}

@media (min-width: 768px) {
  .bento-grid {
    grid-auto-rows: 240px;
  }
}

.bento-card {
  border-radius: 8px;
  overflow: hidden;
}
</style>
