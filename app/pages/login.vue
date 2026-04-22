<template>
  <div class="login-page section-padding min-h-screen flex items-center justify-center relative overflow-hidden">
    <!-- Background Accents -->
    <div class="absolute top-0 right-0 w-[500px] h-[500px] bg-[var(--color-neon-teal)] opacity-[0.02] blur-[120px] rounded-full"></div>
    <div class="absolute bottom-0 left-0 w-[400px] h-[400px] bg-[var(--color-electric-violet)] opacity-[0.02] blur-[100px] rounded-full"></div>

    <div class="container mx-auto relative z-10 max-w-xl">
      <div class="space-y-12">
        <!-- Logo/Header -->
        <div class="text-center">
          <p class="text-overline mb-4">Secured Access</p>
          <h1 class="text-4xl md:text-5xl mb-2">Anna Ericyan</h1>
          <p class="opacity-40 font-light italic">Administrative Login</p>
        </div>

        <!-- Feedback Messages -->
        <transition name="fade">
          <div v-if="errorMessage || successMessage" class="space-y-4">
            <div v-if="errorMessage" class="p-6 bg-red-500/10 text-red-500 rounded-sm text-sm border-l-2 border-red-500">
              {{ errorMessage }}
            </div>
            <div v-if="successMessage" class="p-6 bg-[var(--color-neon-teal)]/10 text-[var(--color-neon-teal)] rounded-sm text-sm border-l-2 border-[var(--color-neon-teal)]">
              {{ successMessage }}
            </div>
          </div>
        </transition>

        <!-- Login Form -->
        <form @submit.prevent="handleLogin" class="space-y-12">
          <div class="space-y-8">
            <div class="relative group">
              <label class="text-overline mb-2 block opacity-40">Email Address</label>
              <input v-model="email" type="email" required placeholder="admin@annaericyan.com"
                class="w-full bg-transparent border-b border-white/10 py-4 text-xl focus:outline-none focus:border-[var(--color-neon-teal)] transition-colors placeholder:opacity-10" />
            </div>

            <div class="relative group">
              <div class="flex items-center justify-between">
                <label class="text-overline mb-2 block opacity-40">Password</label>
                <NuxtLink to="/forgot-password" class="text-[10px] uppercase tracking-wider opacity-40 hover:opacity-100 transition-opacity underline decoration-white/20 underline-offset-4">Reset</NuxtLink>
              </div>
              <input v-model="password" type="password" required placeholder="••••••••"
                class="w-full bg-transparent border-b border-white/10 py-4 text-xl focus:outline-none focus:border-[var(--color-neon-teal)] transition-colors placeholder:opacity-10" />
            </div>
          </div>

          <div class="pt-8">
            <button type="submit" :disabled="loading"
              class="group flex items-center gap-4 text-2xl font-medium transition-all hover:gap-6 disabled:opacity-50">
              <span class="relative">
                {{ loading ? 'Authenticating...' : 'Sign In' }}
                <span class="absolute bottom-0 left-0 w-full h-[1px] bg-current"></span>
              </span>
              <svg v-if="!loading" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="group-hover:translate-x-1 transition-transform">
                <line x1="5" y1="12" x2="19" y2="12"></line>
                <polyline points="12 5 19 12 12 19"></polyline>
              </svg>
              <div v-else class="w-5 h-5 border-2 border-current border-t-transparent rounded-full animate-spin"></div>
            </button>
          </div>
        </form>

        <div class="pt-12 text-center opacity-40">
          <NuxtLink to="/" class="text-overline hover:opacity-100 transition-opacity">Return to Main Site</NuxtLink>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
const supabase = useSupabaseClient()
const user = useSupabaseUser()

const email = ref('')
const password = ref('')
const loading = ref(false)
const errorMessage = ref('')
const successMessage = ref('')

// Redirect if already logged in
watchEffect(() => {
  if (user.value) {
    navigateTo('/admin')
  }
})

const handleLogin = async () => {
  loading.value = true
  errorMessage.value = ''
  successMessage.value = ''

  try {
    const { error } = await supabase.auth.signInWithPassword({
      email: email.value,
      password: password.value,
    })

    if (error) {
      errorMessage.value = error.message
    } else {
      successMessage.value = 'Login successful! Redirecting...'
      // Redirect will happen automatically due to watchEffect
    }
  } catch (error) {
    errorMessage.value = 'An unexpected error occurred'
  } finally {
    loading.value = false
  }
}
</script>
