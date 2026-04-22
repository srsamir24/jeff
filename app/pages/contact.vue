<template>
  <div class="contact-page">
    <!-- Hero Section -->
    <section class="section-padding relative overflow-hidden flex flex-col justify-center min-h-[60vh]">
      <div class="container mx-auto relative z-10">
        <div class="max-w-4xl">
          <p class="text-overline mb-6">Get in touch</p>
          <h1 class="text-5xl md:text-8xl mb-8 leading-[0.9] lg:leading-[0.85]">
            Let's build <br/> 
            <span class="opacity-40">something great.</span>
          </h1>
          <p class="text-xl md:text-2xl opacity-60 max-w-2xl leading-relaxed">
            I'm currently available for freelance projects and collaborations. 
            Whether you have a specific idea or just want to chat, feel free to reach out.
          </p>
        </div>
      </div>
      
      <!-- Background Accents -->
      <div class="absolute top-1/4 -right-20 w-[500px] h-[500px] bg-[var(--color-neon-teal)] opacity-[0.03] blur-[120px] rounded-full"></div>
      <div class="absolute -bottom-20 -left-20 w-[400px] h-[400px] bg-[var(--color-electric-violet)] opacity-[0.03] blur-[100px] rounded-full"></div>
    </section>

    <!-- Main Content -->
    <section class="section-padding pt-0">
      <div class="container mx-auto">
        <div class="grid grid-cols-1 lg:grid-cols-12 gap-16 lg:gap-24">
          
          <!-- Contact Details -->
          <div class="lg:col-span-5 space-y-16">
            <div class="space-y-8">
              <div>
                <h3 class="text-2xl mb-4">Contact Details</h3>
                <div class="space-y-6">
                  <div class="group">
                    <p class="text-overline opacity-40 mb-1">Email</p>
                    <a href="mailto:hello@annaericyan.com" class="text-2xl hover:opacity-100 transition-opacity flex items-center gap-2">
                      hello@annaericyan.com
                      <span class="w-2 h-2 rounded-full bg-[var(--color-neon-teal)]"></span>
                    </a>
                  </div>
                  
                  <div class="group">
                    <p class="text-overline opacity-40 mb-1">Location</p>
                    <p class="text-2xl">Europe / Remote</p>
                  </div>
                </div>
              </div>

              <div>
                <h3 class="text-2xl mb-4">Social</h3>
                <div class="flex flex-wrap gap-x-8 gap-y-4">
                  <a href="#" class="text-xl opacity-60 hover:opacity-100 transition-opacity">Instagram</a>
                  <a href="#" class="text-xl opacity-60 hover:opacity-100 transition-opacity">LinkedIn</a>
                  <a href="#" class="text-xl opacity-60 hover:opacity-100 transition-opacity">Twitter</a>
                </div>
              </div>
            </div>

            <!-- Availability -->
            <div class="p-8 bg-[var(--color-charcoal)] dark:bg-white/5 rounded-2xl">
              <div class="flex items-start gap-4">
                <div class="w-3 h-3 rounded-full bg-green-500 mt-2 animate-pulse"></div>
                <div>
                  <h4 class="text-lg font-medium mb-2">Available for new slots</h4>
                  <p class="opacity-60 text-sm">I'm currently accepting new projects for Q3 2024. Response time is usually within 24 hours.</p>
                </div>
              </div>
            </div>
          </div>

          <!-- Contact Form -->
          <div class="lg:col-span-7">
            <h3 class="text-2xl mb-8">Send a message</h3>
            <form @submit.prevent="handleSubmit" class="space-y-12">
              <div class="grid grid-cols-1 md:grid-cols-2 gap-12">
                <div class="relative group">
                  <label class="text-overline mb-2 block opacity-40">My name is</label>
                  <input v-model="form.name" type="text" placeholder="Your name" required
                    class="w-full bg-transparent border-b border-white/10 py-4 text-xl focus:outline-none focus:border-[var(--color-neon-teal)] transition-colors placeholder:opacity-20" />
                </div>
                
                <div class="relative group">
                  <label class="text-overline mb-2 block opacity-40">My email is</label>
                  <input v-model="form.email" type="email" placeholder="email@example.com" required
                    class="w-full bg-transparent border-b border-white/10 py-4 text-xl focus:outline-none focus:border-[var(--color-neon-teal)] transition-colors placeholder:opacity-20" />
                </div>
              </div>

              <div class="relative group">
                <label class="text-overline mb-2 block opacity-40">I'm interested in</label>
                <input v-model="form.subject" type="text" placeholder="Project type, collaboration, etc." required
                  class="w-full bg-transparent border-b border-white/10 py-4 text-xl focus:outline-none focus:border-[var(--color-neon-teal)] transition-colors placeholder:opacity-20" />
              </div>

              <div class="relative group">
                <label class="text-overline mb-2 block opacity-40">Your message</label>
                <textarea v-model="form.message" rows="4" placeholder="Tell me about your vision..." required
                  class="w-full bg-transparent border-b border-white/10 py-4 text-xl focus:outline-none focus:border-[var(--color-neon-teal)] transition-colors resize-none placeholder:opacity-20"></textarea>
              </div>

              <div class="pt-8">
                <button type="submit" :disabled="submitting"
                  class="group flex items-center gap-4 text-2xl font-medium transition-all hover:gap-6 disabled:opacity-50">
                  <span class="relative">
                    {{ submitting ? 'Sending...' : 'Send Message' }}
                    <span class="absolute bottom-0 left-0 w-full h-[1px] bg-current"></span>
                  </span>
                  <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="group-hover:translate-x-1 transition-transform">
                    <line x1="5" y1="12" x2="19" y2="12"></line>
                    <polyline points="12 5 19 12 12 19"></polyline>
                  </svg>
                </button>
              </div>
            </form>

            <!-- Success Portal -->
            <transition name="fade">
              <div v-if="showSuccess" class="fixed inset-0 z-[100] flex items-center justify-center bg-[var(--bg-color)]/90 backdrop-blur-md">
                <div class="text-center p-12 max-w-lg">
                  <div class="w-20 h-20 bg-[var(--color-neon-teal)] rounded-full flex items-center justify-center mx-auto mb-8">
                    <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="3">
                      <polyline points="20 6 9 17 4 12"></polyline>
                    </svg>
                  </div>
                  <h2 class="text-4xl mb-4 leading-tight">Message Received.</h2>
                  <p class="text-xl opacity-60 mb-12">Thanks for reaching out. I'll get back to you as soon as I can.</p>
                  <button @click="showSuccess = false" class="text-overline underline underline-offset-8">Close message</button>
                </div>
              </div>
            </transition>
          </div>
        </div>
      </div>
    </section>
  </div>
</template>

<script setup>
// SEO
useHead({
  title: 'Contact - Anna Ericyan',
  meta: [
    { name: 'description', content: 'Get in touch with Anna Ericyan for graphic design projects, branding work, and creative collaborations.' }
  ]
})

// Form state
const form = ref({
  name: '',
  email: '',
  subject: '',
  message: ''
})

const submitting = ref(false)
const showSuccess = ref(false)

// Handle form submission
const handleSubmit = async () => {
  submitting.value = true

  try {
    // Simulate API call - replace with actual email service
    await new Promise(resolve => setTimeout(resolve, 1500))

    // Show success message
    showSuccess.value = true

    // Reset form
    form.value = {
      name: '',
      email: '',
      subject: '',
      message: ''
    }

    // Hide success message after 5 seconds
    setTimeout(() => {
      showSuccess.value = false
    }, 5000)
  } catch (error) {
    console.error('Error sending message:', error)
    alert('There was an error sending your message. Please try again.')
  } finally {
    submitting.value = false
  }
}
</script>
