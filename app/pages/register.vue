<template>
  <div class="min-h-screen bg-linear-to-br from-light-blue/20 via-portfolio-white to-lighter-pink/20 flex items-center justify-center px-6 py-12">
    <div class="w-full max-w-md">
      <div class="bg-portfolio-white rounded-3xl shadow-2xl p-8 border border-light-blue/20">
        <!-- Logo/Brand -->
        <div class="text-center mb-8">
          <h1 class="text-3xl font-bold bg-clip-text text-transparent bg-linear-to-r from-bright-pink via-blue-purple to-light-blue mb-2" style="font-family: 'Gendy', sans-serif;">
            Anna Ericyan
          </h1>
          <p class="text-gray-600">Create Admin Account</p>
        </div>

        <!-- Error Message -->
        <div v-if="errorMessage" class="mb-6 p-4 bg-bright-pink/10 border border-bright-pink/20 rounded-lg text-bright-pink text-sm">
          {{ errorMessage }}
        </div>

        <!-- Success Message -->
        <div v-if="successMessage" class="mb-6 p-4 bg-light-green/10 border border-light-green/20 rounded-lg text-light-green text-sm">
          {{ successMessage }}
        </div>

        <!-- Registration Form -->
        <form @submit.prevent="handleRegister" class="space-y-6">
          <div>
            <label for="email" class="block text-sm font-medium text-gray-700 mb-2">Email</label>
            <input
              id="email"
              v-model="email"
              type="email"
              required
              class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-purple focus:border-transparent transition-all"
              placeholder="admin@annaericyan.com"
            />
          </div>

          <div>
            <label for="password" class="block text-sm font-medium text-gray-700 mb-2">Password</label>
            <input
              id="password"
              v-model="password"
              type="password"
              required
              minlength="6"
              class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-purple focus:border-transparent transition-all"
              placeholder="••••••••"
            />
            <p class="mt-1 text-xs text-gray-500">Minimum 6 characters</p>
          </div>

          <div>
            <label for="confirmPassword" class="block text-sm font-medium text-gray-700 mb-2">Confirm Password</label>
            <input
              id="confirmPassword"
              v-model="confirmPassword"
              type="password"
              required
              class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-purple focus:border-transparent transition-all"
              placeholder="••••••••"
            />
          </div>

          <button
            type="submit"
            :disabled="loading"
            class="w-full px-6 py-3 bg-blue-purple text-portfolio-white rounded-lg font-semibold hover:bg-bright-pink transition-all duration-300 shadow-lg hover:shadow-xl disabled:opacity-50 disabled:cursor-not-allowed"
          >
            <span v-if="!loading">Create Account</span>
            <span v-else class="flex items-center justify-center">
              <svg class="animate-spin -ml-1 mr-3 h-5 w-5 text-portfolio-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
              </svg>
              Creating account...
            </span>
          </button>
        </form>

        <!-- Already have account -->
        <div class="mt-6 text-center">
          <NuxtLink to="/login" class="text-sm text-gray-600 hover:text-blue-purple transition-colors">
            Already have an account? Sign in
          </NuxtLink>
        </div>

        <!-- Back to Home -->
        <div class="mt-4 text-center">
          <NuxtLink to="/" class="text-sm text-gray-600 hover:text-blue-purple transition-colors">
            ← Back to Home
          </NuxtLink>
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
const confirmPassword = ref('')
const loading = ref(false)
const errorMessage = ref('')
const successMessage = ref('')

// Redirect if already logged in
watchEffect(() => {
  if (user.value) {
    navigateTo('/admin')
  }
})

const handleRegister = async () => {
  loading.value = true
  errorMessage.value = ''
  successMessage.value = ''

  // Validate passwords match
  if (password.value !== confirmPassword.value) {
    errorMessage.value = 'Passwords do not match'
    loading.value = false
    return
  }

  // Validate password length
  if (password.value.length < 6) {
    errorMessage.value = 'Password must be at least 6 characters'
    loading.value = false
    return
  }

  try {
    const { data, error } = await supabase.auth.signUp({
      email: email.value,
      password: password.value,
      options: {
        emailRedirectTo: `${window.location.origin}/confirm`,
      },
    })

    if (error) {
      errorMessage.value = error.message
    } else {
      successMessage.value = 'Account created! Please check your email to confirm your account.'
      // Clear form
      email.value = ''
      password.value = ''
      confirmPassword.value = ''
    }
  } catch (error) {
    errorMessage.value = 'An unexpected error occurred'
  } finally {
    loading.value = false
  }
}
</script>
