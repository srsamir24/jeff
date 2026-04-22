<template>
  <section ref="sectionRef" class="scroll-gallery bg-background-dark py-32 overflow-hidden relative">
    <div class="container mx-auto px-6 relative z-10 pt-24">
      <!-- Gallery Grid -->
      <div class="grid grid-cols-1 md:grid-cols-3 gap-8 md:gap-12 items-start">
        <!-- Column 1 -->
        <div ref="col1" class="gallery-col space-y-8 md:space-y-12">
          <div v-for="i in 4" :key="'c1-'+i" class="gallery-item group">
            <div class="relative overflow-hidden rounded-3xl bg-paper/5 aspect-[3/4]">
              <img 
                :src="`https://picsum.photos/seed/${10 + i}/800/1200`" 
                alt="Gallery Placeholder"
                class="w-full h-full object-cover transition-transform duration-700 group-hover:scale-110"
              />
              <div class="absolute inset-0 bg-gradient-to-t from-background-dark/80 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-500 flex items-end p-8">
                <p class="text-paper/60 text-sm font-medium tracking-tight">Perspective {{ i }}</p>
              </div>
            </div>
          </div>
        </div>

        <!-- Column 2 (Moving Slower) -->
        <div ref="col2" class="gallery-col space-y-8 md:space-y-12 md:mt-24">
          <div v-for="i in 4" :key="'c2-'+i" class="gallery-item group">
            <div class="relative overflow-hidden rounded-3xl bg-paper/5 aspect-square">
              <img 
                :src="`https://picsum.photos/seed/${20 + i}/800/800`" 
                alt="Gallery Placeholder"
                class="w-full h-full object-cover transition-transform duration-700 group-hover:scale-110"
              />
              <div class="absolute inset-0 bg-gradient-to-t from-background-dark/80 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-500 flex items-end p-8">
                <p class="text-paper/60 text-sm font-medium tracking-tight">Abstract {{ i }}</p>
              </div>
            </div>
          </div>
        </div>

        <!-- Column 3 (Moving Faster) -->
        <div ref="col3" class="gallery-col space-y-8 md:space-y-12">
          <div v-for="i in 4" :key="'c3-'+i" class="gallery-item group">
            <div class="relative overflow-hidden rounded-3xl bg-paper/5 aspect-[3/4]">
              <img 
                :src="`https://picsum.photos/seed/${30 + i}/800/1200`" 
                alt="Gallery Placeholder"
                class="w-full h-full object-cover transition-transform duration-700 group-hover:scale-110"
              />
              <div class="absolute inset-0 bg-gradient-to-t from-background-dark/80 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-500 flex items-end p-8">
                <p class="text-paper/60 text-sm font-medium tracking-tight">Texture {{ i }}</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Decorative Background Splatter -->
    <div class="absolute top-1/2 left-0 -translate-y-1/2 w-[800px] h-[800px] bg-electric-violet/5 blur-[160px] rounded-full pointer-events-none -translate-x-1/2"></div>
    <div class="absolute bottom-0 right-0 w-[600px] h-[600px] bg-neon-teal/5 blur-[140px] rounded-full pointer-events-none translate-x-1/4"></div>
  </section>
</template>

<script setup>
import { onMounted, onUnmounted, ref } from 'vue'
import gsap from 'gsap'
import { ScrollTrigger } from 'gsap/ScrollTrigger'

// Register GSAP plugin
if (process.client) {
  gsap.registerPlugin(ScrollTrigger)
}

const sectionRef = ref(null)
const col1 = ref(null)
const col2 = ref(null)
const col3 = ref(null)

let ctx

onMounted(() => {
  ctx = gsap.context(() => {
    // Parallax logic for columns
    // Column 1 moves slightly up
    gsap.to(col1.value, {
      y: -150,
      ease: 'none',
      scrollTrigger: {
        trigger: sectionRef.value,
        start: 'top bottom',
        end: 'bottom top',
        scrub: true
      }
    })

    // Column 2 moves slightly down (relative to center)
    gsap.to(col2.value, {
      y: 100,
      ease: 'none',
      scrollTrigger: {
        trigger: sectionRef.value,
        start: 'top bottom',
        end: 'bottom top',
        scrub: true
      }
    })

    // Column 3 moves significantly up
    gsap.to(col3.value, {
      y: -300,
      ease: 'none',
      scrollTrigger: {
        trigger: sectionRef.value,
        start: 'top bottom',
        end: 'bottom top',
        scrub: true
      }
    })

    // Individual item entrance staggered reveal
    gsap.from('.gallery-item', {
      scale: 0.8,
      opacity: 0,
      duration: 1,
      stagger: {
        amount: 0.5,
        grid: [4, 3],
        from: 'center'
      },
      ease: 'power2.out',
      scrollTrigger: {
        trigger: sectionRef.value,
        start: 'top 80%',
      }
    })
  }, sectionRef.value)
})

onUnmounted(() => {
  if (ctx) ctx.revert()
})
</script>

<style scoped>
.scroll-gallery {
  background-color: #080210;
}

.gallery-item {
  will-change: transform, opacity;
}

.gallery-col {
  will-change: transform;
}
</style>
