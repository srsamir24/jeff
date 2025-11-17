<template>
  <div class="min-h-screen bg-linear-to-br from-light-blue/20 via-portfolio-white to-lighter-pink/20 flex items-center justify-center px-6 py-12">
    <div class="w-full max-w-md">
      <div class="bg-portfolio-white rounded-3xl shadow-2xl p-8 border border-light-blue/20">
        <!-- Logo/Brand -->
        <div class="text-center mb-8">
          <h1 class="text-3xl font-bold bg-clip-text text-transparent bg-linear-to-r from-bright-pink via-blue-purple to-light-blue mb-2" style="font-family: 'Gendy', sans-serif;">
            Anna Ericyan
          </h1>
          <p class="text-gray-600">Reset Your Password</p>
        </div>

        <!-- Error Message -->
        <div v-if="errorMessage" class="mb-6 p-4 bg-bright-pink/10 border border-bright-pink/20 rounded-lg text-bright-pink text-sm">
          {{ errorMessage }}
        </div>

        <!-- Success Message -->
        <div v-if="successMessage" class="mb-6 p-4 bg-light-green/10 border border-light-green/20 rounded-lg text-light-green text-sm">
          {{ successMessage }}
        </div>

        <!-- Instructions -->
        <div v-if="!successMessage" class="mb-6 text-sm text-gray-600 text-center">
          Enter your email address and we'll send you a link to reset your password.
        </div>

        <!-- Reset Password Form -->
        <form v-if="!successMessage" @submit.prevent="handleResetRequest" class="space-y-6">
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

          <button
            type="submit"
            :disabled="loading"
            class="w-full px-6 py-3 bg-blue-purple text-portfolio-white rounded-lg font-semibold hover:bg-bright-pink transition-all duration-300 shadow-lg hover:shadow-xl disabled:opacity-50 disabled:cursor-not-allowed"
          >
            <span v-if="!loading">Send Reset Link</span>
            <span v-else class="flex items-center justify-center">
              <svg class="animate-spin -ml-1 mr-3 h-5 w-5 text-portfolio-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
              </svg>
              Sending...
            </span>
          </button>
        </form>

        <!-- Back to Login -->
        <div class="mt-6 text-center">
          <NuxtLink to="/login" class="text-sm text-gray-600 hover:text-blue-purple transition-colors">
            ← Back to Login
          </NuxtLink>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
const supabase = useSupabaseClient()

const email = ref('')
const loading = ref(false)
const errorMessage = ref('')
const successMessage = ref('')

const handleResetRequest = async () => {
  loading.value = true
  errorMessage.value = ''
  successMessage.value = ''

  try {
    const { error } = await supabase.auth.resetPasswordForEmail(email.value, {
      redirectTo: `${window.location.origin}/reset-password`,
    })

    if (error) {
      errorMessage.value = error.message
    } else {
      successMessage.value = 'Password reset link sent! Please check your email.'
    }
  } catch (error) {
    errorMessage.value = 'An unexpected error occurred'
  } finally {
    loading.value = false
  }
}
</script>
