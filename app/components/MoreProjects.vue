<template>
  <section ref="sectionRef" class="more-projects bg-paper overflow-hidden relative">
    <!-- Header -->
    <div
      ref="headerRef"
      class="flex justify-between items-baseline px-6 md:px-12 lg:px-[48px] pt-12 pb-6 border-b border-charcoal/[0.08]"
      style="opacity: 0; transform: translateY(60px); transition: opacity 0.8s cubic-bezier(0.16, 1, 0.3, 1), transform 0.8s cubic-bezier(0.16, 1, 0.3, 1);"
    >
      <h2 class="font-display text-[clamp(32px,4vw,48px)] font-medium text-charcoal tracking-tight leading-[1.1]">
        More Projects
      </h2>
      <span class="text-overline text-stone hidden md:block">
        ← Scroll to explore →
      </span>
    </div>

    <!-- Horizontally-scrolling track -->
    <div
      ref="trackRef"
      class="flex gap-6 px-6 md:px-12 lg:px-[48px] pt-12 pb-[120px] will-change-transform"
    >
      <div
        v-for="(project, i) in projects"
        :key="project.name"
        class="flex-shrink-0 w-[320px] md:w-[400px] more-project-card"
        :style="{ animationDelay: `${i * 0.05}s` }"
      >
        <div
          class="relative overflow-hidden rounded bg-charcoal/5 cursor-pointer group"
          style="aspect-ratio: 4/3;"
          @mouseenter="onCardEnter"
          @mouseleave="onCardLeave"
        >
          <img
            :src="project.image"
            :alt="project.name"
            width="400"
            height="300"
            loading="eager"
            decoding="async"
            class="w-full h-full object-cover transition-transform duration-700 group-hover:scale-[1.02]"
          />
          <div
            class="img-overlay absolute inset-0 bg-neon-teal opacity-0 transition-opacity duration-300 pointer-events-none"
          />
        </div>
        <h3 class="font-display text-xl font-medium text-charcoal mt-4 tracking-tight">
          {{ project.name }}
        </h3>
        <p class="text-overline text-stone mt-1">
          {{ project.category }}
        </p>
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

const projects = [
  { name: 'Meridian Wines', category: 'IDENTITY', image: 'https://loremflickr.com/800/600/branding?lock=1' },
  { name: 'Nova Tech', category: 'DIGITAL', image: 'https://loremflickr.com/800/600/technology?lock=2' },
  { name: 'Ritual Skincare', category: 'PACKAGING', image: 'https://loremflickr.com/800/600/packaging?lock=3' },
  { name: 'The Archive', category: 'EDITORIAL', image: 'https://loremflickr.com/800/600/magazine?lock=4' },
  { name: 'Lumen Lighting', category: 'IDENTITY', image: 'https://loremflickr.com/800/600/product?lock=5' },
  { name: 'Pulse Fitness', category: 'DIGITAL', image: 'https://loremflickr.com/800/600/app?lock=6' },
  { name: 'Botanical Gardens', category: 'IDENTITY', image: 'https://loremflickr.com/800/600/poster?lock=7' },
  { name: 'Cipher Security', category: 'IDENTITY', image: 'https://loremflickr.com/800/600/design?lock=8' },
]

const sectionRef = ref(null)
const trackRef = ref(null)
const headerRef = ref(null)

let ctx
let headerObserver
let resizeObserver = null

const onCardEnter = (e) => {
  const overlay = e.currentTarget.querySelector('.img-overlay')
  if (overlay) overlay.style.opacity = '0.1'
}

const onCardLeave = (e) => {
  const overlay = e.currentTarget.querySelector('.img-overlay')
  if (overlay) overlay.style.opacity = '0'
}

onMounted(() => {
  if (headerRef.value) {
    headerObserver = new IntersectionObserver(
      ([entry]) => {
        if (entry.isIntersecting) {
          headerRef.value.style.opacity = '1'
          headerRef.value.style.transform = 'translateY(0)'
          headerObserver.disconnect()
        }
      },
      { threshold: 0.15 }
    )
    headerObserver.observe(headerRef.value)
  }

  ctx = gsap.context(() => {
    const section = sectionRef.value
    const track = trackRef.value
    if (!section || !track) return

    const init = () => {
      const totalWidth = track.scrollWidth - window.innerWidth
      if (totalWidth <= 0) return

      gsap.to(track, {
        x: -totalWidth,
        ease: 'none',
        scrollTrigger: {
          trigger: section,
          pin: true,
          start: 'top top',
          end: () => `+=${totalWidth}`,
          scrub: 1,
          invalidateOnRefresh: true,
        },
      })
    }

    // Init immediately — card widths are fixed, so track width is known
    // even before images load. We just refresh after images arrive.
    init()

    // Refresh after images load to pick up any layout shifts
    const imgs = track.querySelectorAll('img')
    let pending = imgs.length
    if (pending > 0) {
      const onImgDone = () => {
        pending--
        if (pending <= 0) {
          ScrollTrigger.refresh()
        }
      }
      imgs.forEach((img) => {
        if (img.complete) onImgDone()
        else {
          img.addEventListener('load', onImgDone, { once: true })
          img.addEventListener('error', onImgDone, { once: true })
        }
      })
    }

    // Also refresh on resize
    const onResize = () => ScrollTrigger.refresh()
    window.addEventListener('resize', onResize)

    // Cleanup
    return () => {
      window.removeEventListener('resize', onResize)
    }
  }, sectionRef.value)
})

onUnmounted(() => {
  if (ctx) ctx.revert()
  if (headerObserver) headerObserver.disconnect()
  if (resizeObserver) resizeObserver.disconnect()
})
</script>

<style scoped>
.more-project-card {
  opacity: 0;
  transform: translateY(20px);
  animation: fadeInUp 0.6s cubic-bezier(0.16, 1, 0.3, 1) forwards;
}

@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
</style>
