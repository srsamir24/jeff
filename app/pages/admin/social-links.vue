<template>
  <div class="min-h-screen bg-gray-50">
    <!-- Admin Header -->
    <header class="bg-portfolio-white border-b border-gray-200 sticky top-0 z-50">
      <div class="container mx-auto px-6 py-4">
        <div class="flex items-center justify-between">
          <div class="flex items-center space-x-4">
            <NuxtLink to="/admin" class="text-gray-500 hover:text-blue-purple">
              <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18">
                </path>
              </svg>
            </NuxtLink>
            <h1 class="text-2xl font-bold text-gray-900">Social Links & External URLs</h1>
          </div>
          <button @click="addNewLink"
            class="px-6 py-3 bg-blue-purple text-portfolio-white rounded-lg font-semibold hover:bg-bright-pink transition-all">
            + Add New Link
          </button>
        </div>
      </div>
    </header>

    <!-- Main Content -->
    <main class="container mx-auto px-6 py-8 max-w-6xl">
      <!-- Loading State -->
      <div v-if="loading" class="text-center py-12">
        <div class="inline-block animate-spin rounded-full h-12 w-12 border-b-2 border-blue-purple"></div>
        <p class="text-gray-500 mt-4">Loading social links...</p>
      </div>

      <!-- Social Links List -->
      <div v-else class="space-y-4">
        <div v-for="link in socialLinks" :key="link.id"
          class="bg-portfolio-white rounded-xl p-6 shadow-md border border-gray-100 hover:shadow-lg transition-all">
          <div class="flex items-center gap-6">
            <!-- Icon Preview -->
            <div class="flex-shrink-0">
              <div
                :class="['w-16 h-16 rounded-xl flex items-center justify-center text-portfolio-white', getIconBgClass(link.icon_type)]">
                <component :is="getIconComponent(link.icon_type)" class="w-8 h-8" />
              </div>
            </div>

            <!-- Link Info -->
            <div class="flex-1 min-w-0">
              <div class="flex items-center gap-3 mb-2">
                <h3 class="text-lg font-bold text-gray-900">{{ link.name }}</h3>
                <span v-if="!link.is_active" class="px-2 py-1 bg-gray-100 text-gray-500 text-xs rounded-full">
                  Inactive
                </span>
                <span v-for="location in link.display_location" :key="location"
                  class="px-2 py-1 bg-light-blue/10 text-light-blue text-xs rounded-full">
                  {{ location }}
                </span>
              </div>
              <p class="text-sm text-gray-600 truncate">{{ link.url }}</p>
              <p class="text-xs text-gray-400 mt-1">Icon Type: {{ link.icon_type }} • Order: {{ link.sort_order }}</p>
            </div>

            <!-- Actions -->
            <div class="flex items-center gap-2">
              <button @click="editLink(link)"
                class="p-2 text-blue-purple hover:bg-blue-purple/10 rounded-lg transition-all">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                    d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                </svg>
              </button>
              <button @click="deleteLink(link)"
                class="p-2 text-bright-pink hover:bg-bright-pink/10 rounded-lg transition-all">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                    d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                </svg>
              </button>
            </div>
          </div>
        </div>

        <!-- Empty State -->
        <div v-if="socialLinks.length === 0" class="text-center py-12 bg-portfolio-white rounded-xl">
          <svg class="w-16 h-16 mx-auto text-gray-300 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
              d="M13.828 10.172a4 4 0 00-5.656 0l-4 4a4 4 0 105.656 5.656l1.102-1.101m-.758-4.899a4 4 0 005.656 0l4-4a4 4 0 00-5.656-5.656l-1.1 1.1" />
          </svg>
          <p class="text-gray-500 mb-4">No social links yet</p>
          <button @click="addNewLink"
            class="px-6 py-3 bg-blue-purple text-portfolio-white rounded-lg font-semibold hover:bg-bright-pink transition-all">
            Add Your First Link
          </button>
        </div>
      </div>
    </main>

    <!-- Edit/Add Modal -->
    <div v-if="showModal"
      class="fixed inset-0 bg-black/50 backdrop-blur-sm z-50 flex items-center justify-center p-4"
      @click.self="closeModal">
      <div class="bg-portfolio-white rounded-2xl shadow-2xl max-w-2xl w-full max-h-[90vh] overflow-y-auto">
        <div class="sticky top-0 bg-portfolio-white border-b border-gray-200 p-6 flex items-center justify-between">
          <h2 class="text-2xl font-bold text-gray-900">{{ editingLink.id ? 'Edit Link' : 'Add New Link' }}</h2>
          <button @click="closeModal" class="text-gray-400 hover:text-gray-600">
            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </div>

        <div class="p-6 space-y-6">
          <!-- Name -->
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2">Link Name</label>
            <input v-model="editingLink.name" type="text"
              class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-purple focus:border-transparent"
              placeholder="e.g., Instagram, LinkedIn, Upwork">
          </div>

          <!-- URL -->
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2">URL</label>
            <input v-model="editingLink.url" type="url"
              class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-purple focus:border-transparent"
              placeholder="https://...">
          </div>

          <!-- Icon Type -->
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2">Icon Type</label>
            <select v-model="editingLink.icon_type"
              class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-purple focus:border-transparent">
              <option value="instagram">Instagram</option>
              <option value="behance">Behance</option>
              <option value="dribbble">Dribbble</option>
              <option value="linkedin">LinkedIn</option>
              <option value="twitter">Twitter</option>
              <option value="facebook">Facebook</option>
              <option value="upwork">Upwork</option>
              <option value="link">Generic Link</option>
            </select>
          </div>

          <!-- Display Location -->
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2">Display Location</label>
            <div class="space-y-2">
              <label class="flex items-center">
                <input type="checkbox" :checked="editingLink.display_location?.includes('footer')"
                  @change="toggleLocation('footer')" class="mr-2">
                <span>Footer</span>
              </label>
              <label class="flex items-center">
                <input type="checkbox" :checked="editingLink.display_location?.includes('nav')"
                  @change="toggleLocation('nav')" class="mr-2">
                <span>Navigation Bar</span>
              </label>
            </div>
          </div>

          <!-- Sort Order -->
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2">Sort Order</label>
            <input v-model.number="editingLink.sort_order" type="number"
              class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-purple focus:border-transparent"
              placeholder="0">
          </div>

          <!-- Active Status -->
          <div>
            <label class="flex items-center">
              <input v-model="editingLink.is_active" type="checkbox" class="mr-2">
              <span class="text-sm font-medium text-gray-700">Active (visible on site)</span>
            </label>
          </div>
        </div>

        <div class="border-t border-gray-200 p-6 flex justify-end gap-3">
          <button @click="closeModal"
            class="px-6 py-3 bg-gray-100 text-gray-700 rounded-lg font-semibold hover:bg-gray-200 transition-all">
            Cancel
          </button>
          <button @click="saveLink" :disabled="saving"
            class="px-6 py-3 bg-blue-purple text-portfolio-white rounded-lg font-semibold hover:bg-bright-pink transition-all disabled:opacity-50">
            {{ saving ? 'Saving...' : 'Save Link' }}
          </button>
        </div>
      </div>
    </div>
  </div>
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
    useToast().error('Failed to load social links')
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
    useToast().error('Please fill in all required fields')
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
      useToast().success('Link updated successfully')
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
      useToast().success('Link added successfully')
    }

    closeModal()
    fetchSocialLinks()
  } catch (error) {
    console.error('Error saving link:', error)
    useToast().error('Failed to save link')
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
    useToast().success('Link deleted successfully')
    fetchSocialLinks()
  } catch (error) {
    console.error('Error deleting link:', error)
    useToast().error('Failed to delete link')
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
