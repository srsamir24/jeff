<template>
  <div class="min-h-screen flex flex-col bg-portfolio-white dark:bg-[#080210] transition-colors duration-300">
    <Nav />
    <main class="grow">
      <slot />
    </main>
    <Footer />
  </div>
</template>

<script setup>
</script>
