<template>
  <div class="min-h-screen bg-portfolio-white">
    <!-- Hero Section -->
    <section class="relative overflow-hidden bg-linear-to-br from-portfolio-white via-blue-purple/10 to-light-green/10 pt-32 pb-16">
      <!-- Animated background elements -->
      <div class="absolute top-0 left-0 w-96 h-96 bg-blue-purple/20 rounded-full blur-3xl -translate-x-1/2 -translate-y-1/2 animate-blob"></div>
      <div class="absolute bottom-0 right-0 w-96 h-96 bg-light-green/20 rounded-full blur-3xl translate-x-1/2 translate-y-1/2 animate-blob animation-delay-2000"></div>

      <div class="container mx-auto px-6 relative z-10">
        <div class="text-center max-w-3xl mx-auto">
          <h1 class="text-5xl md:text-6xl font-bold mb-6">
            <span class="bg-clip-text text-transparent bg-linear-to-r from-blue-purple via-bright-pink to-light-green">
              Let's Connect
            </span>
          </h1>
          <p class="text-xl text-gray-600 leading-relaxed">
            Have a project in mind? I'd love to hear about it. Drop me a message and let's create something amazing together.
          </p>
        </div>
      </div>
    </section>

    <!-- Contact Section -->
    <section class="py-20 bg-gray-50">
      <div class="container mx-auto px-6">
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-12 max-w-6xl mx-auto">
          <!-- Contact Info -->
          <div class="space-y-8">
            <div>
              <h2 class="text-3xl font-bold mb-6">
                <span class="bg-clip-text text-transparent bg-linear-to-r from-bright-pink to-blue-purple">
                  Get In Touch
                </span>
              </h2>
              <p class="text-lg text-gray-600 leading-relaxed">
                I'm currently available for freelance projects and collaborations. Whether you need branding, illustrations, or any creative design work, I'm here to help bring your vision to life.
              </p>
            </div>

            <!-- Contact Cards -->
            <div class="space-y-4">
              <!-- Email -->
              <div class="group bg-portfolio-white rounded-2xl p-6 shadow-md hover:shadow-xl transition-all border border-gray-100 hover:border-bright-pink/20">
                <div class="flex items-center gap-4">
                  <div class="flex-shrink-0 w-12 h-12 bg-linear-to-br from-bright-pink to-lighter-pink rounded-xl flex items-center justify-center group-hover:scale-110 transition-transform">
                    <svg class="w-6 h-6 text-portfolio-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                    </svg>
                  </div>
                  <div>
                    <h3 class="font-semibold text-gray-900 mb-1">Email</h3>
                    <a href="mailto:hello@annaericyan.com" class="text-bright-pink hover:text-lighter-pink transition-colors">
                      hello@annaericyan.com
                    </a>
                  </div>
                </div>
              </div>

              <!-- Phone -->
              <div class="group bg-portfolio-white rounded-2xl p-6 shadow-md hover:shadow-xl transition-all border border-gray-100 hover:border-light-blue/20">
                <div class="flex items-center gap-4">
                  <div class="flex-shrink-0 w-12 h-12 bg-linear-to-br from-light-blue to-light-blue/70 rounded-xl flex items-center justify-center group-hover:scale-110 transition-transform">
                    <svg class="w-6 h-6 text-portfolio-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z" />
                    </svg>
                  </div>
                  <div>
                    <h3 class="font-semibold text-gray-900 mb-1">Phone</h3>
                    <a href="tel:+1234567890" class="text-light-blue hover:text-blue-purple transition-colors">
                      +1 (234) 567-890
                    </a>
                  </div>
                </div>
              </div>

              <!-- Location -->
              <div class="group bg-portfolio-white rounded-2xl p-6 shadow-md hover:shadow-xl transition-all border border-gray-100 hover:border-light-green/20">
                <div class="flex items-center gap-4">
                  <div class="flex-shrink-0 w-12 h-12 bg-linear-to-br from-light-green to-light-green/70 rounded-xl flex items-center justify-center group-hover:scale-110 transition-transform">
                    <svg class="w-6 h-6 text-portfolio-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
                    </svg>
                  </div>
                  <div>
                    <h3 class="font-semibold text-gray-900 mb-1">Location</h3>
                    <p class="text-light-green">San Francisco, CA</p>
                  </div>
                </div>
              </div>
            </div>

            <!-- Social Links -->
            <div>
              <h3 class="font-semibold text-gray-900 mb-4">Follow Me</h3>
              <div class="flex gap-3">
                <a href="https://facebook.com/annaericyan" target="_blank" rel="noopener noreferrer" class="w-12 h-12 bg-linear-to-br from-bright-pink to-lighter-pink rounded-xl flex items-center justify-center text-portfolio-white hover:scale-110 transition-transform shadow-md" aria-label="Facebook">
                  <svg class="w-6 h-6" fill="currentColor" viewBox="0 0 24 24">
                    <path d="M24 12.073c0-6.627-5.373-12-12-12s-12 5.373-12 12c0 5.99 4.388 10.954 10.125 11.854v-8.385H7.078v-3.47h3.047V9.43c0-3.007 1.792-4.669 4.533-4.669 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.925-1.956 1.874v2.25h3.328l-.532 3.47h-2.796v8.385C19.612 23.027 24 18.062 24 12.073z"/>
                  </svg>
                </a>
                <a href="https://twitter.com/annaericyan" target="_blank" rel="noopener noreferrer" class="w-12 h-12 bg-linear-to-br from-light-blue to-blue-purple rounded-xl flex items-center justify-center text-portfolio-white hover:scale-110 transition-transform shadow-md" aria-label="Twitter">
                  <svg class="w-6 h-6" fill="currentColor" viewBox="0 0 24 24">
                    <path d="M23.953 4.57a10 10 0 01-2.825.775 4.958 4.958 0 002.163-2.723c-.951.555-2.005.959-3.127 1.184a4.92 4.92 0 00-8.384 4.482C7.69 8.095 4.067 6.13 1.64 3.162a4.822 4.822 0 00-.666 2.475c0 1.71.87 3.213 2.188 4.096a4.904 4.904 0 01-2.228-.616v.06a4.923 4.923 0 003.946 4.827 4.996 4.996 0 01-2.212.085 4.936 4.936 0 004.604 3.417 9.867 9.867 0 01-6.102 2.105c-.39 0-.779-.023-1.17-.067a13.995 13.995 0 007.557 2.209c9.053 0 13.998-7.496 13.998-13.985 0-.21 0-.42-.015-.63A9.935 9.935 0 0024 4.59z"/>
                  </svg>
                </a>
                <a href="https://instagram.com/annaericyan" target="_blank" rel="noopener noreferrer" class="w-12 h-12 bg-linear-to-br from-light-green to-light-green/70 rounded-xl flex items-center justify-center text-portfolio-white hover:scale-110 transition-transform shadow-md" aria-label="Instagram">
                  <svg class="w-6 h-6" fill="currentColor" viewBox="0 0 24 24">
                    <path d="M12 0C8.74 0 8.333.015 7.053.072 5.775.132 4.905.333 4.14.63c-.789.306-1.459.717-2.126 1.384S.935 3.35.63 4.14C.333 4.905.131 5.775.072 7.053.012 8.333 0 8.74 0 12s.015 3.667.072 4.947c.06 1.277.261 2.148.558 2.913.306.788.717 1.459 1.384 2.126.667.666 1.336 1.079 2.126 1.384.766.296 1.636.499 2.913.558C8.333 23.988 8.74 24 12 24s3.667-.015 4.947-.072c1.277-.06 2.148-.262 2.913-.558.788-.306 1.459-.718 2.126-1.384.666-.667 1.079-1.335 1.384-2.126.296-.765.499-1.636.558-2.913.06-1.28.072-1.687.072-4.947s-.015-3.667-.072-4.947c-.06-1.277-.262-2.149-.558-2.913-.306-.789-.718-1.459-1.384-2.126C21.319 1.347 20.651.935 19.86.63c-.765-.297-1.636-.499-2.913-.558C15.667.012 15.26 0 12 0zm0 2.16c3.203 0 3.585.016 4.85.071 1.17.055 1.805.249 2.227.415.562.217.96.477 1.382.896.419.42.679.819.896 1.381.164.422.36 1.057.413 2.227.057 1.266.07 1.646.07 4.85s-.015 3.585-.074 4.85c-.061 1.17-.256 1.805-.421 2.227-.224.562-.479.96-.899 1.382-.419.419-.824.679-1.38.896-.42.164-1.065.36-2.235.413-1.274.057-1.649.07-4.859.07-3.211 0-3.586-.015-4.859-.074-1.171-.061-1.816-.256-2.236-.421-.569-.224-.96-.479-1.379-.899-.421-.419-.69-.824-.9-1.38-.165-.42-.359-1.065-.42-2.235-.045-1.26-.061-1.649-.061-4.844 0-3.196.016-3.586.061-4.861.061-1.17.255-1.814.42-2.234.21-.57.479-.96.9-1.381.419-.419.81-.689 1.379-.898.42-.166 1.051-.361 2.221-.421 1.275-.045 1.65-.06 4.859-.06l.045.03zm0 3.678c-3.405 0-6.162 2.76-6.162 6.162 0 3.405 2.76 6.162 6.162 6.162 3.405 0 6.162-2.76 6.162-6.162 0-3.405-2.76-6.162-6.162-6.162zM12 16c-2.21 0-4-1.79-4-4s1.79-4 4-4 4 1.79 4 4-1.79 4-4 4zm7.846-10.405c0 .795-.646 1.44-1.44 1.44-.795 0-1.44-.646-1.44-1.44 0-.794.646-1.439 1.44-1.439.793-.001 1.44.645 1.44 1.439z"/>
                  </svg>
                </a>
              </div>
            </div>
          </div>

          <!-- Contact Form -->
          <div class="bg-portfolio-white rounded-3xl p-8 shadow-xl border border-gray-100">
            <h3 class="text-2xl font-bold text-gray-900 mb-6">Send Me a Message</h3>

            <form @submit.prevent="handleSubmit" class="space-y-6">
              <!-- Name -->
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Name *</label>
                <input
                  v-model="form.name"
                  type="text"
                  required
                  class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-bright-pink focus:border-transparent transition-all"
                  placeholder="Your name"
                />
              </div>

              <!-- Email -->
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Email *</label>
                <input
                  v-model="form.email"
                  type="email"
                  required
                  class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-bright-pink focus:border-transparent transition-all"
                  placeholder="your.email@example.com"
                />
              </div>

              <!-- Subject -->
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Subject *</label>
                <input
                  v-model="form.subject"
                  type="text"
                  required
                  class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-bright-pink focus:border-transparent transition-all"
                  placeholder="What's this about?"
                />
              </div>

              <!-- Message -->
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Message *</label>
                <textarea
                  v-model="form.message"
                  required
                  rows="5"
                  class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-bright-pink focus:border-transparent transition-all resize-none"
                  placeholder="Tell me about your project..."
                ></textarea>
              </div>

              <!-- Submit Button -->
              <AppButton
                type="submit"
                variant="secondary"
                size="lg"
                :loading="submitting"
                loading-text="Sending..."
                class="w-full"
              >
                Send Message
                <template #iconRight>
                  <svg class="w-5 h-5 group-hover:translate-x-1 transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 19l9 2-9-18-9 18 9-2zm0 0v-8" />
                  </svg>
                </template>
              </AppButton>
            </form>

            <!-- Success Message -->
            <transition
              enter-active-class="transition duration-300 ease-out"
              enter-from-class="opacity-0 translate-y-2"
              enter-to-class="opacity-100 translate-y-0"
              leave-active-class="transition duration-200 ease-in"
              leave-from-class="opacity-100 translate-y-0"
              leave-to-class="opacity-0 translate-y-2"
            >
              <div v-if="showSuccess" class="mt-6 p-4 bg-light-green/10 border border-light-green/30 rounded-xl">
                <div class="flex items-center gap-3 text-light-green">
                  <svg class="w-6 h-6 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>
                  </svg>
                  <p class="font-medium">Message sent successfully! I'll get back to you soon.</p>
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
