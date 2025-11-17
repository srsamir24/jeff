<template>
  <div class="min-h-screen bg-linear-to-br from-light-blue/20 via-portfolio-white to-lighter-pink/20 flex items-center justify-center px-6">
    <div class="text-center">
      <div class="w-20 h-20 bg-light-green/20 rounded-full flex items-center justify-center mx-auto mb-6">
        <svg class="w-10 h-10 text-light-green" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
        </svg>
      </div>
      <h1 class="text-3xl font-bold text-gray-900 mb-4">Email Confirmed!</h1>
      <p class="text-gray-600 mb-8">Your email has been successfully verified.</p>
      <NuxtLink
        to="/admin"
        class="inline-block px-8 py-3 bg-blue-purple text-portfolio-white rounded-full font-semibold hover:bg-bright-pink transition-all duration-300 shadow-lg"
      >
        Go to Dashboard
      </NuxtLink>
    </div>
  </div>
</template>

<script setup>
// This page handles email confirmation callbacks from Supabase
</script>
