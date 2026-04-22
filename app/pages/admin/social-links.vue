<template>
  <NuxtLayout name="admin">
    <div class="max-w-6xl mx-auto">
      <!-- Header Area -->
      <div class="flex flex-col md:flex-row md:items-center justify-between gap-6 mb-12">
        <div>
          <h1 class="text-4xl font-bold tracking-tight text-white mb-2 font-display">Social Eco-system</h1>
          <p class="text-white/40 font-medium">Manage your digital presence and external touchpoints ({{ socialLinks.length }} active)</p>
        </div>
        <button @click="addNewLink"
          class="group flex items-center justify-center gap-2 px-8 py-4 bg-white text-black rounded-full font-bold hover:bg-bright-pink hover:text-white transition-all duration-300">
          <svg class="w-5 h-5 transition-transform group-hover:rotate-90" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M12 4v16m8-8H4"></path>
          </svg>
          Add New Connection
        </button>
      </div>

      <!-- Loading State -->
      <div v-if="loading" class="flex flex-col items-center justify-center py-24">
        <div class="w-12 h-12 border-2 border-white/10 border-t-white rounded-full animate-spin mb-4"></div>
        <p class="text-white/40 font-medium animate-pulse">Scanning connections...</p>
      </div>

      <!-- Social Links List -->
      <div v-else class="grid grid-cols-1 md:grid-cols-2 gap-6 pb-12">
        <div v-for="link in socialLinks" :key="link.id"
          class="group relative bg-white/[0.03] backdrop-blur-3xl rounded-[32px] p-8 hover:bg-white/[0.06] transition-all duration-500 overflow-hidden">
          
          <!-- Background Glow -->
          <div :class="['absolute -right-20 -top-20 w-48 h-48 blur-[100px] opacity-0 group-hover:opacity-20 transition-opacity duration-1000', getIconBgClass(link.icon_type)]"></div>

          <div class="relative z-10 flex items-start gap-8">
            <!-- Icon Preview -->
            <div class="flex-shrink-0">
              <div
                :class="['w-20 h-20 rounded-2xl flex items-center justify-center text-white shadow-2xl transition-transform duration-700 group-hover:scale-110', getIconBgClass(link.icon_type)]">
                <component :is="getIconComponent(link.icon_type)" class="w-10 h-10" />
              </div>
            </div>

            <!-- Link Info -->
            <div class="flex-1 min-w-0 pt-1">
              <div class="flex items-center flex-wrap gap-2 mb-3">
                <h3 class="text-xl font-bold font-display text-white">{{ link.name }}</h3>
                <div class="flex gap-2">
                   <span v-v-if="!link.is_active" class="px-2 py-0.5 bg-white/5 text-white/20 text-[9px] uppercase tracking-widest font-bold rounded-full">
                    Offline
                  </span>
                  <span v-for="location in link.display_location" :key="location"
                    class="px-2 py-0.5 bg-white/10 text-white/60 text-[9px] uppercase tracking-widest font-bold rounded-full">
                    {{ location }}
                  </span>
                </div>
              </div>
              <p class="text-[10px] uppercase tracking-[0.2em] text-white/20 mb-1 font-bold">Endpoint</p>
              <p class="text-xs text-white/40 truncate font-mono">{{ link.url }}</p>
            </div>
          </div>

          <!-- Actions Overlay -->
          <div class="absolute top-6 right-6 flex items-center gap-2 opacity-0 group-hover:opacity-100 transition-all duration-300 translate-y-2 group-hover:translate-y-0">
            <button @click="editLink(link)"
              class="p-3 bg-white/5 hover:bg-white text-white hover:text-black rounded-full transition-all">
              <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                  d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
              </svg>
            </button>
            <button @click="deleteLink(link)"
              class="p-3 bg-white/5 hover:bg-bright-pink text-white rounded-full transition-all">
              <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                  d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
              </svg>
            </button>
          </div>

          <!-- Simple order indicator -->
          <div class="absolute bottom-6 left-8 text-[10px] text-white/10 uppercase tracking-[0.4em] font-bold">
            Pos / {{ link.sort_order }}
          </div>
        </div>

        <!-- Empty State -->
        <div v-if="socialLinks.length === 0" 
          class="col-span-full py-24 bg-white/[0.02] border-2 border-dashed border-white/5 rounded-[40px] flex flex-col items-center justify-center text-center">
          <div class="w-20 h-20 bg-white/5 rounded-full flex items-center justify-center mb-6">
            <svg class="w-10 h-10 text-white/20" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                d="M13.828 10.172a4 4 0 00-5.656 0l-4 4a4 4 0 105.656 5.656l1.102-1.101m-.758-4.899a4 4 0 005.656 0l4-4a4 4 0 00-5.656-5.656l-1.1 1.1" />
            </svg>
          </div>
          <h3 class="text-xl font-bold font-display text-white/40 mb-2">No Connections Found</h3>
          <p class="text-white/20 mb-8 max-w-xs">Start building your link ecosystem by adding your first social platform.</p>
          <button @click="addNewLink"
            class="px-8 py-3 bg-white text-black rounded-full font-bold hover:bg-bright-pink hover:text-white transition-all">
            Initialize First Link
          </button>
        </div>
      </div>
    </div>

    <!-- Edit/Add Modal Overlay -->
    <Teleport to="body">
      <div v-if="showModal"
        class="fixed inset-0 bg-black/60 backdrop-blur-xl z-[200] flex items-center justify-center p-4">
        <div class="bg-[#0c051a] rounded-[40px] shadow-2xl max-w-2xl w-full max-h-[90vh] overflow-hidden flex flex-col border border-white/5">
          <!-- Modal Header -->
          <div class="px-10 py-8 flex items-center justify-between border-b border-white/5">
            <div>
              <h2 class="text-2xl font-bold font-display text-white mb-1">
                {{ editingLink.id ? 'Refine Connection' : 'Register New Connection' }}
              </h2>
              <p class="text-white/40 text-[10px] uppercase tracking-widest font-bold">Interface Configuration</p>
            </div>
            <button @click="closeModal" class="p-2 text-white/20 hover:text-white transition-colors">
              <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
              </svg>
            </button>
          </div>

          <!-- Modal Body -->
          <div class="flex-1 overflow-y-auto p-10 space-y-10 custom-scrollbar">
            <!-- Basic Details -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
              <div class="space-y-3">
                <label class="text-overline">Link Label</label>
                <input v-model="editingLink.name" type="text"
                  class="w-full px-5 py-4 bg-white/5 rounded-2xl text-white focus:ring-1 focus:ring-white/20 outline-none border-none transition-all"
                  placeholder="e.g. Behance">
              </div>
              <div class="space-y-3">
                 <label class="text-overline">Platform Type</label>
                <select v-model="editingLink.icon_type"
                  class="w-full px-5 py-4 bg-white/5 rounded-2xl text-white focus:ring-1 focus:ring-white/20 outline-none border-none appearance-none transition-all">
                  <option value="instagram">Instagram</option>
                  <option value="behance">Behance</option>
                  <option value="dribbble">Dribbble</option>
                  <option value="linkedin">LinkedIn</option>
                  <option value="twitter">Twitter</option>
                  <option value="facebook">Facebook</option>
                  <option value="upwork">Upwork</option>
                  <option value="link">Other / Website</option>
                </select>
              </div>
            </div>

            <!-- Endpoint -->
            <div class="space-y-3">
              <label class="text-overline">Destination URL</label>
              <input v-model="editingLink.url" type="url"
                class="w-full px-5 py-4 bg-white/5 rounded-2xl text-white font-mono text-sm focus:ring-1 focus:ring-white/20 outline-none border-none transition-all"
                placeholder="https://...">
            </div>

            <!-- Configuration -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-10">
              <div class="space-y-4">
                <label class="text-overline">Visibility Clusters</label>
                <div class="flex flex-col gap-4">
                  <label class="group flex items-center cursor-pointer">
                    <div class="relative w-6 h-6 mr-3">
                      <input type="checkbox" :checked="editingLink.display_location?.includes('footer')"
                       @change="toggleLocation('footer')" class="sr-only peer">
                      <div class="absolute inset-0 bg-white/5 rounded-lg peer-checked:bg-white transition-all"></div>
                      <svg class="absolute inset-0 w-6 h-6 text-black opacity-0 peer-checked:opacity-100 transition-opacity p-1" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                        <path stroke-width="3" stroke-linecap="round" stroke-linejoin="round" d="M5 13l4 4L19 7" />
                      </svg>
                    </div>
                    <span class="text-sm font-medium text-white/60 group-hover:text-white transition-colors">Site Footer</span>
                  </label>
                  <label class="group flex items-center cursor-pointer">
                    <div class="relative w-6 h-6 mr-3">
                      <input type="checkbox" :checked="editingLink.display_location?.includes('nav')"
                       @change="toggleLocation('nav')" class="sr-only peer">
                      <div class="absolute inset-0 bg-white/5 rounded-lg peer-checked:bg-white transition-all"></div>
                      <svg class="absolute inset-0 w-6 h-6 text-black opacity-0 peer-checked:opacity-100 transition-opacity p-1" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                        <path stroke-width="3" stroke-linecap="round" stroke-linejoin="round" d="M5 13l4 4L19 7" />
                      </svg>
                    </div>
                    <span class="text-sm font-medium text-white/60 group-hover:text-white transition-colors">Navigation Menu</span>
                  </label>
                </div>
              </div>

              <div class="space-y-4">
                <label class="text-overline">Sequence Order</label>
                <input v-model.number="editingLink.sort_order" type="number"
                  class="w-full px-5 py-4 bg-white/5 rounded-2xl text-white focus:ring-1 focus:ring-white/20 outline-none border-none transition-all"
                  placeholder="0">
              </div>
            </div>

            <!-- Status -->
            <div class="pt-4 border-t border-white/5 flex items-center justify-between">
               <div>
                  <h4 class="text-sm font-bold text-white mb-1">Broadcasting Status</h4>
                  <p class="text-xs text-white/40">Toggle to enable/disable on the live site</p>
               </div>
               <label class="relative inline-flex items-center cursor-pointer">
                <input v-model="editingLink.is_active" type="checkbox" class="sr-only peer">
                <div class="w-14 h-8 bg-white/5 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[4px] after:left-[4px] after:bg-white/20 peer-checked:after:bg-white after:rounded-full after:h-6 after:w-6 after:transition-all peer-checked:bg-bright-pink/40"></div>
              </label>
            </div>
          </div>

          <!-- Modal Footer -->
          <div class="px-10 py-8 bg-white/[0.02] flex justify-end gap-4">
            <button @click="closeModal"
              class="px-8 py-3 bg-white/5 hover:bg-white/10 text-white rounded-full text-xs font-bold tracking-widest uppercase transition-all">
              Abort
            </button>
            <button @click="saveLink" :disabled="saving"
              class="px-8 py-3 bg-white text-black rounded-full text-xs font-bold tracking-widest uppercase hover:bg-bright-pink hover:text-white transition-all disabled:opacity-50">
              {{ saving ? 'Syncing...' : 'Deploy Changes' }}
            </button>
          </div>
        </div>
      </div>
    </Teleport>
  </NuxtLayout>
</template>

<script setup>
definePageMeta({
  middleware: 'admin',
  layout: false
})

const supabase = useSupabaseClient()
const loading = ref(true)
const saving = ref(false)
const showModal = ref(false)
const socialLinks = ref([])
const editingLink = ref({
  name: '',
  url: '',
  icon_type: 'link',
  display_location: ['footer'],
  sort_order: 0,
  is_active: true
})

// Fetch all social links
const fetchSocialLinks = async () => {
  loading.value = true
  try {
    const { data, error } = await supabase
      .from('social_links')
      .select('*')
      .order('sort_order', { ascending: true })

    if (error) throw error
    socialLinks.value = data || []
  } catch (error) {
    console.error('Error fetching social links:', error)
    useAppToast().error('Failed to load social links')
  } finally {
    loading.value = false
  }
}

// Add new link
const addNewLink = () => {
  editingLink.value = {
    name: '',
    url: '',
    icon_type: 'link',
    display_location: ['footer'],
    sort_order: socialLinks.value.length,
    is_active: true
  }
  showModal.value = true
}

// Edit existing link
const editLink = (link) => {
  editingLink.value = { ...link }
  showModal.value = true
}

// Close modal
const closeModal = () => {
  showModal.value = false
  editingLink.value = {
    name: '',
    url: '',
    icon_type: 'link',
    display_location: ['footer'],
    sort_order: 0,
    is_active: true
  }
}

// Toggle display location
const toggleLocation = (location) => {
  if (!editingLink.value.display_location) {
    editingLink.value.display_location = []
  }
  const index = editingLink.value.display_location.indexOf(location)
  if (index > -1) {
    editingLink.value.display_location.splice(index, 1)
  } else {
    editingLink.value.display_location.push(location)
  }
}

// Save link
const saveLink = async () => {
  if (!editingLink.value.name || !editingLink.value.url) {
    useAppToast().error('Please fill in all required fields')
    return
  }

  saving.value = true
  try {
    if (editingLink.value.id) {
      // Update existing
      const { error } = await supabase
        .from('social_links')
        .update({
          name: editingLink.value.name,
          url: editingLink.value.url,
          icon_type: editingLink.value.icon_type,
          display_location: editingLink.value.display_location,
          sort_order: editingLink.value.sort_order,
          is_active: editingLink.value.is_active,
          updated_at: new Date().toISOString()
        })
        .eq('id', editingLink.value.id)

      if (error) throw error
      useAppToast().success('Link updated successfully')
    } else {
      // Insert new
      const { error } = await supabase
        .from('social_links')
        .insert([{
          name: editingLink.value.name,
          url: editingLink.value.url,
          icon_type: editingLink.value.icon_type,
          display_location: editingLink.value.display_location,
          sort_order: editingLink.value.sort_order,
          is_active: editingLink.value.is_active
        }])

      if (error) throw error
      useAppToast().success('Link added successfully')
    }

    closeModal()
    fetchSocialLinks()
  } catch (error) {
    console.error('Error saving link:', error)
    useAppToast().error('Failed to save link')
  } finally {
    saving.value = false
  }
}

// Delete link
const deleteLink = async (link) => {
  if (!confirm(`Are you sure you want to delete "${link.name}"?`)) return

  try {
    const { error } = await supabase
      .from('social_links')
      .delete()
      .eq('id', link.id)

    if (error) throw error
    useAppToast().success('Link deleted successfully')
    fetchSocialLinks()
  } catch (error) {
    console.error('Error deleting link:', error)
    useAppToast().error('Failed to delete link')
  }
}

// Helper functions for icons
const getIconBgClass = (iconType) => {
  const colors = {
    instagram: 'bg-gradient-to-br from-purple-500 via-pink-500 to-orange-400',
    behance: 'bg-blue-600',
    dribbble: 'bg-pink-500',
    linkedin: 'bg-blue-700',
    twitter: 'bg-sky-500',
    facebook: 'bg-blue-600',
    upwork: 'bg-green-600',
    link: 'bg-gray-600'
  }
  return colors[iconType] || colors.link
}

const getIconComponent = (iconType) => {
  // Return a simple function component for each icon
  const icons = {
    instagram: () => h('svg', { fill: 'currentColor', viewBox: '0 0 24 24' }, [
      h('path', { d: 'M12 2.163c3.204 0 3.584.012 4.85.07 3.252.148 4.771 1.691 4.919 4.919.058 1.265.069 1.645.069 4.849 0 3.205-.012 3.584-.069 4.849-.149 3.225-1.664 4.771-4.919 4.919-1.266.058-1.644.07-4.85.07-3.204 0-3.584-.012-4.849-.07-3.26-.149-4.771-1.699-4.919-4.92-.058-1.265-.07-1.644-.07-4.849 0-3.204.013-3.583.07-4.849.149-3.227 1.664-4.771 4.919-4.919 1.266-.057 1.645-.069 4.849-.069z' })
    ]),
    behance: () => h('svg', { fill: 'currentColor', viewBox: '0 0 24 24' }, [
      h('path', { d: 'M22 7h-7v-2h7v2zm1.726 10c-.442 1.297-2.029 3-5.101 3-3.074 0-5.564-1.729-5.564-5.675 0-3.91 2.325-5.92 5.466-5.92 3.082 0 4.964 1.782 5.375 4.426.078.506.109 1.188.095 2.14h-8.027c.13 3.211 3.483 3.312 4.588 2.029h3.168z' })
    ]),
    dribbble: () => h('svg', { fill: 'currentColor', viewBox: '0 0 24 24' }, [
      h('path', { d: 'M12 0c-6.628 0-12 5.373-12 12s5.372 12 12 12 12-5.373 12-12-5.372-12-12-12zm9.885 11.441c-2.575-.422-4.943-.445-7.103-.073-.244-.563-.497-1.125-.767-1.68 2.31-1 4.165-2.358 5.548-4.082 1.35 1.594 2.197 3.619 2.322 5.835z' })
    ]),
    linkedin: () => h('svg', { fill: 'currentColor', viewBox: '0 0 24 24' }, [
      h('path', { d: 'M20.447 20.452h-3.554v-5.569c0-1.328-.027-3.037-1.852-3.037-1.853 0-2.136 1.445-2.136 2.939v5.667H9.351V9h3.414v1.561h.046c.477-.9 1.637-1.85 3.37-1.85 3.601 0 4.267 2.37 4.267 5.455v6.286zM5.337 7.433c-1.144 0-2.063-.926-2.063-2.065 0-1.138.92-2.063 2.063-2.063 1.14 0 2.064.925 2.064 2.063 0 1.139-.925 2.065-2.064 2.065zm1.782 13.019H3.555V9h3.564v11.452zM22.225 0H1.771C.792 0 0 .774 0 1.729v20.542C0 23.227.792 24 1.771 24h20.451C23.2 24 24 23.227 24 22.271V1.729C24 .774 23.2 0 22.222 0h.003z' })
    ]),
    twitter: () => h('svg', { fill: 'currentColor', viewBox: '0 0 24 24' }, [
      h('path', { d: 'M23.953 4.57a10 10 0 01-2.825.775 4.958 4.958 0 002.163-2.723c-.951.555-2.005.959-3.127 1.184a4.92 4.92 0 00-8.384 4.482C7.69 8.095 4.067 6.13 1.64 3.162a4.822 4.822 0 00-.666 2.475c0 1.71.87 3.213 2.188 4.096a4.904 4.904 0 01-2.228-.616v.06a4.923 4.923 0 003.946 4.827 4.996 4.996 0 01-2.212.085 4.936 4.936 0 004.604 3.417 9.867 9.867 0 01-6.102 2.105c-.39 0-.779-.023-1.17-.067a13.995 13.995 0 007.557 2.209c9.053 0 13.998-7.496 13.998-13.985 0-.21 0-.42-.015-.63A9.935 9.935 0 0024 4.59z' })
    ]),
    upwork: () => h('svg', { fill: 'currentColor', viewBox: '0 0 24 24' }, [
      h('path', { d: 'M18.561 13.158c-1.102 0-2.135-.467-3.074-1.227l.228-1.076.008-.042c.207-1.143.849-3.06 2.839-3.06 1.492 0 2.703 1.212 2.703 2.703-.001 1.489-1.212 2.702-2.704 2.702zm0-8.14c-2.539 0-4.51 1.649-5.31 4.366-1.22-1.834-2.148-4.036-2.687-5.892H7.828v7.112c-.002 1.406-1.141 2.546-2.547 2.548-1.405-.002-2.543-1.143-2.545-2.548V3.492H0v7.112c0 2.914 2.37 5.303 5.281 5.303 2.913 0 5.283-2.389 5.283-5.303v-1.19c.529 1.107 1.182 2.229 1.974 3.221l-1.673 7.873h2.797l1.213-5.71c1.063.679 2.285 1.109 3.686 1.109 3 0 5.439-2.452 5.439-5.45 0-3-2.439-5.439-5.439-5.439z' })
    ]),
    link: () => h('svg', { fill: 'none', stroke: 'currentColor', viewBox: '0 0 24 24' }, [
      h('path', { 'stroke-linecap': 'round', 'stroke-linejoin': 'round', 'stroke-width': '2', d: 'M13.828 10.172a4 4 0 00-5.656 0l-4 4a4 4 0 105.656 5.656l1.102-1.101m-.758-4.899a4 4 0 005.656 0l4-4a4 4 0 00-5.656-5.656l-1.1 1.1' })
    ])
  }
  return icons[iconType] || icons.link
}

onMounted(() => {
  fetchSocialLinks()
})
</script>
