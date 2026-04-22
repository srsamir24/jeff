<template>
  <div class="min-h-screen bg-[#080210] flex items-center justify-center px-6 py-12 font-['Inter']">
    <div class="w-full max-w-md">
      <div class="space-y-12">
        <!-- Logo/Brand -->
        <div class="text-center">
          <h1 class="text-4xl font-bold text-white mb-4 tracking-tighter" style="font-family: 'Space Grosskesk', sans-serif;">
            ANNA ERICYAN
          </h1>
          <p class="text-white/40 text-sm uppercase tracking-widest">Set New Password</p>
        </div>

        <!-- Success Message -->
        <div v-if="successMessage" class="space-y-8 text-center animate-fade-in">
          <p class="text-white/60 leading-relaxed max-w-xs mx-auto">
            {{ successMessage }}
          </p>
          <div class="pt-4">
            <NuxtLink to="/login" class="group inline-flex flex-col items-center">
              <span class="text-white text-sm font-medium mb-1">Proceed to Login</span>
              <div class="h-px w-0 bg-white group-hover:w-full transition-all duration-500"></div>
            </NuxtLink>
          </div>
        </div>

        <template v-else>
          <!-- Error Message -->
          <div v-if="errorMessage" class="p-4 bg-red-500/10 text-red-400 text-xs text-center rounded-sm border border-red-500/10">
            {{ errorMessage }}
          </div>

          <!-- Reset Password Form -->
          <form @submit.prevent="handlePasswordReset" class="space-y-8">
            <div class="space-y-6">
              <div class="space-y-2">
                <label for="newPassword" class="block text-[10px] uppercase tracking-[0.2em] text-white/30 font-medium ml-1">New Password</label>
                <input
                  id="newPassword"
                  v-model="newPassword"
                  type="password"
                  required
                  minlength="6"
                  class="w-full bg-white/5 border-none px-4 py-4 text-white placeholder-white/10 focus:ring-1 focus:ring-white/20 transition-all text-sm rounded-sm"
                  placeholder="••••••••"
                />
                <p class="text-[9px] text-white/20 uppercase tracking-wider ml-1">Minimum 6 characters</p>
              </div>

              <div class="space-y-2">
                <label for="confirmPassword" class="block text-[10px] uppercase tracking-[0.2em] text-white/30 font-medium ml-1">Confirm Password</label>
                <input
                  id="confirmPassword"
                  v-model="confirmPassword"
                  type="password"
                  required
                  class="w-full bg-white/5 border-none px-4 py-4 text-white placeholder-white/10 focus:ring-1 focus:ring-white/20 transition-all text-sm rounded-sm"
                  placeholder="••••••••"
                />
              </div>
            </div>

            <button
              type="submit"
              :disabled="loading"
              class="w-full group py-4 transition-all duration-500 relative overflow-hidden"
            >
              <div class="relative z-10 flex items-center justify-center">
                <span v-if="!loading" class="text-white text-xs uppercase tracking-[0.3em] font-medium group-hover:tracking-[0.4em] transition-all duration-500">Reset Password</span>
                <span v-else class="text-white/40 text-xs uppercase tracking-[0.3em] font-medium">Resetting...</span>
              </div>
              <div class="absolute inset-0 bg-white/5 transform scale-x-0 group-hover:scale-x-100 transition-transform duration-500 origin-left"></div>
            </button>
          </form>

          <!-- Back to Login -->
          <div class="text-center pt-8">
            <NuxtLink to="/login" class="group inline-flex flex-col items-center">
              <span class="text-white/30 group-hover:text-white text-[10px] uppercase tracking-widest transition-colors duration-500">Back to Login</span>
              <div class="h-px w-0 bg-white group-hover:w-full transition-all duration-500 mt-1"></div>
            </NuxtLink>
          </div>
        </template>
      </div>
    </div>
  </div>
</template>

<script setup>
const supabase = useSupabaseClient()

const newPassword = ref('')
const confirmPassword = ref('')
const loading = ref(false)
const errorMessage = ref('')
const successMessage = ref('')

const handlePasswordReset = async () => {
  loading.value = true
  errorMessage.value = ''
  successMessage.value = ''

  if (newPassword.value !== confirmPassword.value) {
    errorMessage.value = 'Passwords do not match'
    loading.value = false
    return
  }

  if (newPassword.value.length < 6) {
    errorMessage.value = 'Password must be at least 6 characters'
    loading.value = false
    return
  }

  try {
    const { error } = await supabase.auth.updateUser({
      password: newPassword.value,
    })

    if (error) {
      errorMessage.value = error.message
    } else {
      successMessage.value = 'Password reset successfully! You can now log in with your new password.'
      newPassword.value = ''
      confirmPassword.value = ''
    }
  } catch (error) {
    errorMessage.value = 'An unexpected error occurred'
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.animate-fade-in {
  animation: fadeIn 1s ease-out forwards;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(10px); }
  to { opacity: 1; transform: translateY(0); }
}
</style>

