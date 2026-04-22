<template>
  <footer class="bg-charcoal text-paper py-20 px-6 md:px-12 flex flex-col items-center gap-12 transition-colors duration-300">
    <div class="w-full flex flex-col md:flex-row justify-between items-center gap-8">
      <!-- Title/Logo in Footer -->
      <NuxtLink to="/" class="font-hero text-2xl opacity-60 hover:opacity-100 transition-opacity">
        Anna Ericyan
      </NuxtLink>

      <!-- Minimal Socials -->
      <div v-if="footerLinks.length > 0" class="flex items-center gap-8">
        <a
          v-for="link in footerLinks"
          :key="link.id"
          :href="link.url"
          target="_blank"
          rel="noopener noreferrer"
          class="text-overline opacity-50 hover:opacity-100 hover:text-primary transition-all"
        >
          {{ link.name }}
        </a>
      </div>

      <!-- Location/Info -->
      <div class="text-overline opacity-40">
        Based in Yerevan, Armenia
      </div>
    </div>

    <!-- Divider -->
    <div class="w-full h-px bg-paper opacity-5" />

    <!-- Bottom Legals -->
    <div class="w-full flex flex-col md:flex-row justify-between items-center gap-4 text-[10px] uppercase tracking-[0.2em] opacity-30">
      <p>&copy; {{ new Date().getFullYear() }} Anna Ericyan. All rights reserved.</p>
      <div class="flex gap-6">
        <NuxtLink to="/privacy" class="hover:opacity-100">Privacy Policy</NuxtLink>
        <NuxtLink to="/terms" class="hover:opacity-100">Terms of Service</NuxtLink>
      </div>
    </div>
  </footer>
</template>

<script setup>
const supabase = useSupabaseClient()
const footerLinks = ref([])

const fetchSocialLinks = async () => {
  try {
    const { data, error } = await supabase
      .from('social_links')
      .select('*')
      .eq('is_active', true)
      .contains('display_location', ['footer'])
      .order('sort_order', { ascending: true })

    if (!error && data) footerLinks.value = data
  } catch (err) {
    console.error('Error fetching footer social links:', err)
  }
}

onMounted(() => {
  fetchSocialLinks()
})
</script>

<style scoped>
.font-hero {
  font-family: 'Gendy', serif !important;
}
</style>
