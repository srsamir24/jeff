<template>
  <div class="min-h-screen bg-gray-50">
    <!-- Admin Header -->
    <header class="bg-portfolio-white border-b border-gray-200 sticky top-0 z-50">
      <div class="container mx-auto px-6 py-4">
        <div class="flex items-center space-x-4">
          <NuxtLink to="/admin" class="text-gray-500 hover:text-blue-purple">
            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18">
              </path>
            </svg>
          </NuxtLink>
          <h1 class="text-2xl font-bold text-gray-900">Manage Projects</h1>
          <span class="text-sm text-gray-500">({{ projects.length }} total)</span>
        </div>
      </div>
    </header>

    <!-- Main Content -->
    <main class="container mx-auto px-6 py-8">
      <!-- Loading State -->
      <div v-if="loading" class="text-center py-12">
        <div class="inline-block animate-spin rounded-full h-12 w-12 border-b-2 border-blue-purple"></div>
        <p class="text-gray-500 mt-4">Loading projects...</p>
      </div>

      <!-- Projects Grid -->
      <div v-else class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        <!-- Add Project Card -->
        <div @click="showAddModal = true"
          class="group cursor-pointer bg-linear-to-br from-blue-purple/5 to-bright-pink/5 rounded-2xl border-2 border-dashed border-blue-purple/30 hover:border-bright-pink/50 transition-all hover:shadow-xl flex items-center justify-center min-h-[400px]">
          <div class="text-center p-8">
            <div
              class="w-20 h-20 mx-auto bg-blue-purple/10 group-hover:bg-bright-pink/10 rounded-full flex items-center justify-center mb-4 transition-all group-hover:scale-110">
              <svg class="w-10 h-10 text-blue-purple group-hover:text-bright-pink transition-colors" fill="none"
                stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"></path>
              </svg>
            </div>
            <h3 class="text-lg font-bold text-gray-900 group-hover:text-blue-purple transition-colors">Add New Project
            </h3>
            <p class="text-sm text-gray-500 mt-2">Click to create a project</p>
          </div>
        </div>

        <!-- Project Cards -->
        <div v-for="project in displayedProjects" :key="project.id"
          class="bg-portfolio-white rounded-2xl overflow-hidden shadow-md hover:shadow-xl transition-all border border-gray-100">
          <!-- Project Image -->
          <div class="relative aspect-4/3 bg-gray-100">
            <img v-if="project.image_url" :src="project.image_url" :alt="project.title"
              class="w-full h-full object-cover" />
            <div v-else class="w-full h-full flex items-center justify-center">
              <svg class="w-16 h-16 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                  d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
              </svg>
            </div>
          </div>

          <!-- Project Info -->
          <div class="p-6">
            <h3 class="text-xl font-bold text-gray-900 mb-2">{{ project.title }}</h3>
            <p class="text-gray-600 text-sm mb-4 line-clamp-2">{{ project.description }}</p>

            <!-- Tags -->
            <div v-if="project.tags && project.tags.length > 0" class="flex flex-wrap gap-2 mb-4">
              <span v-for="(tag, index) in project.tags" :key="index"
                :class="['px-3 py-1 text-xs rounded-full font-medium', tag.class || 'bg-blue-purple/10 text-blue-purple']">
                {{ tag.label }}
              </span>
            </div>

            <!-- Actions -->
            <div class="flex flex-col gap-2">
              <NuxtLink :to="`/admin/project-content/${project.id}`"
                class="px-4 py-2 bg-blue-purple/10 text-blue-purple rounded-lg text-sm font-medium hover:bg-blue-purple/20 transition-all text-center">
                Edit Content
              </NuxtLink>
              <div class="flex gap-2">
                <button @click="editProject(project)"
                  class="flex-1 px-4 py-2 bg-light-blue/10 text-light-blue rounded-lg text-sm font-medium hover:bg-light-blue/20 transition-all">
                  Edit Info
                </button>
                <button @click="deleteProject(project.id)"
                  class="flex-1 px-4 py-2 bg-bright-pink/10 text-bright-pink rounded-lg text-sm font-medium hover:bg-bright-pink/20 transition-all">
                  Delete
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Show More Button -->
      <div v-if="!loading && projects.length > itemsToShow && displayedProjects.length < projects.length"
        class="text-center mt-8">
        <button @click="showMore"
          class="px-8 py-3 bg-blue-purple text-portfolio-white rounded-full font-semibold hover:bg-bright-pink transition-all shadow-lg hover:shadow-xl">
          Show More ({{ projects.length - displayedProjects.length }} remaining)
        </button>
      </div>
    </main>

    <!-- Add/Edit Modal -->
    <div v-if="showAddModal"
      class="fixed inset-0 bg-black/50 backdrop-blur-sm flex items-center justify-center z-50 p-6"
      @click.self="closeModal">
      <div class="bg-portfolio-white rounded-3xl shadow-2xl max-w-2xl w-full max-h-[90vh] overflow-y-auto">
        <div class="p-8">
          <h2 class="text-2xl font-bold text-gray-900 mb-6">
            {{ editingProject ? 'Edit Project' : 'Add New Project' }}
          </h2>

          <form @submit.prevent="saveProject" class="space-y-6">
            <!-- Title -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">Project Title</label>
              <input v-model="formData.title" type="text" required
                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-purple focus:border-transparent"
                placeholder="Brand Identity Design" />
            </div>

            <!-- Description -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">Description</label>
              <textarea v-model="formData.description" required rows="3"
                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-purple focus:border-transparent"
                placeholder="Brief description for project cards"></textarea>
            </div>

            <!-- Image Upload -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">Project Image</label>
              <div
                class="border-2 border-dashed border-gray-300 rounded-lg p-6 text-center hover:border-blue-purple transition-colors">
                <input ref="fileInput" type="file" accept="image/*" @change="handleFileUpload" class="hidden" />
                <button type="button" @click="$refs.fileInput.click()"
                  class="px-6 py-3 bg-light-blue/10 text-light-blue rounded-lg font-medium hover:bg-light-blue/20 transition-all">
                  {{ formData.image_url ? 'Change Image' : 'Upload Image' }}
                </button>
                <p class="text-sm text-gray-500 mt-2">PNG, JPG up to 5MB</p>

                <!-- Image Preview -->
                <div v-if="formData.image_url" class="mt-4">
                  <img :src="formData.image_url" alt="Preview" class="max-h-48 mx-auto rounded-lg" />
                </div>
              </div>
            </div>

            <!-- Project Type -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">Project Type</label>
              <select v-model="formData.project_type" required
                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-purple focus:border-transparent">
                <option value="">Select a project type</option>
                <option value="branding">Branding & Identity</option>
                <option value="print">Print Design</option>
                <option value="digital">Digital Design</option>
                <option value="packaging">Packaging Design</option>
                <option value="illustration">Illustration</option>
                <option value="ui-ux">UI/UX Design</option>
                <option value="photography">Photography</option>
                <option value="web">Web Design</option>
              </select>
              <p class="text-xs text-gray-500 mt-1">Choose the primary type for this project</p>
            </div>

            <!-- Actions -->
            <div class="flex gap-4">
              <button type="button" @click="closeModal"
                class="flex-1 px-6 py-3 bg-gray-100 text-gray-700 rounded-lg font-semibold hover:bg-gray-200 transition-all">
                Cancel
              </button>
              <button type="submit" :disabled="uploading"
                class="flex-1 px-6 py-3 bg-blue-purple text-portfolio-white rounded-lg font-semibold hover:bg-bright-pink transition-all disabled:opacity-50">
                {{ uploading ? 'Uploading...' : (editingProject ? 'Update' : 'Create') }} Project
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>

  <!-- Confirm Dialog -->
  <ConfirmDialog :show="confirmDialog.showDialog.value" :message="confirmDialog.message.value"
    @confirm="confirmDialog.handleConfirm()" @cancel="confirmDialog.handleCancel()" />
</template>

<script setup>
import ConfirmDialog from '~/components/ConfirmDialog.vue'
import { useConfirm } from '~/composables/useConfirm'

definePageMeta({
  middleware: 'admin',
  layout: false
})

const supabase = useSupabaseClient()
const toast = useToast()
const confirmDialog = useConfirm()

// State
const projects = ref([])
const loading = ref(true)
const showAddModal = ref(false)
const editingProject = ref(null)
const uploading = ref(false)
const fileInput = ref(null)
const itemsToShow = ref(5) // Show 5 projects initially

const formData = ref({
  title: '',
  description: '',
  image_url: '',
  project_type: ''
})

// Map project types to tags with styling
const projectTypeToTags = (type) => {
  const tagMap = {
    'branding': [
      { label: 'Branding', class: 'bg-bright-pink/20 text-bright-pink' },
      { label: 'Identity', class: 'bg-blue-purple/20 text-blue-purple' }
    ],
    'print': [
      { label: 'Print Design', class: 'bg-light-green/20 text-light-green' }
    ],
    'digital': [
      { label: 'Digital Design', class: 'bg-light-blue/20 text-light-blue' }
    ],
    'packaging': [
      { label: 'Packaging', class: 'bg-blue-purple/20 text-blue-purple' },
      { label: 'Product Design', class: 'bg-light-green/20 text-light-green' }
    ],
    'illustration': [
      { label: 'Illustration', class: 'bg-bright-pink/20 text-bright-pink' },
      { label: 'Digital Art', class: 'bg-light-blue/20 text-light-blue' }
    ],
    'ui-ux': [
      { label: 'UI/UX Design', class: 'bg-light-blue/20 text-light-blue' },
      { label: 'Mobile', class: 'bg-blue-purple/20 text-blue-purple' }
    ],
    'photography': [
      { label: 'Photography', class: 'bg-light-green/20 text-light-green' }
    ],
    'web': [
      { label: 'Web Design', class: 'bg-light-blue/20 text-light-blue' },
      { label: 'Development', class: 'bg-blue-purple/20 text-blue-purple' }
    ]
  }
  return tagMap[type] || []
}

// Extract project type from tags
const tagsToProjectType = (tags) => {
  if (!tags || tags.length === 0) return ''

  const firstTag = tags[0]?.label?.toLowerCase() || ''

  if (firstTag.includes('branding') || firstTag.includes('identity')) return 'branding'
  if (firstTag.includes('print')) return 'print'
  if (firstTag.includes('digital') && !firstTag.includes('art')) return 'digital'
  if (firstTag.includes('packaging') || firstTag.includes('product')) return 'packaging'
  if (firstTag.includes('illustration') || firstTag.includes('art')) return 'illustration'
  if (firstTag.includes('ui') || firstTag.includes('ux') || firstTag.includes('mobile')) return 'ui-ux'
  if (firstTag.includes('photo')) return 'photography'
  if (firstTag.includes('web')) return 'web'

  return ''
}

// Computed: Projects to display (with pagination)
const displayedProjects = computed(() => {
  return projects.value.slice(0, itemsToShow.value)
})

// Show more projects
const showMore = () => {
  itemsToShow.value += 5
}

// Fetch projects
const fetchProjects = async () => {
  loading.value = true
  const { data, error } = await supabase
    .from('projects')
    .select('*')
    .order('created_at', { ascending: false })

  if (error) {
    console.error('Error fetching projects:', error)
    toast.error('Failed to load projects')
  } else {
    projects.value = data
  }
  loading.value = false
}

// Handle file upload
const handleFileUpload = async (event) => {
  const file = event.target.files[0]
  if (!file) return

  uploading.value = true

  try {
    const fileExt = file.name.split('.').pop()
    const fileName = `${Math.random().toString(36).substring(2)}-${Date.now()}.${fileExt}`
    const filePath = `${fileName}`

    const { data, error: uploadError } = await supabase.storage
      .from('projects')
      .upload(filePath, file)

    if (uploadError) throw uploadError

    const { data: { publicUrl } } = supabase.storage
      .from('projects')
      .getPublicUrl(filePath)

    formData.value.image_url = publicUrl
    toast.success('Image uploaded successfully')
  } catch (error) {
    console.error('Error uploading file:', error)
    toast.error('Error uploading file. Please try again.')
  } finally {
    uploading.value = false
  }
}

// Save project
const saveProject = async () => {
  try {
    const projectData = {
      title: formData.value.title,
      description: formData.value.description,
      image_url: formData.value.image_url,
      tags: projectTypeToTags(formData.value.project_type)
    }

    if (editingProject.value) {
      // Update existing project
      const { error } = await supabase
        .from('projects')
        .update(projectData)
        .eq('id', editingProject.value.id)

      if (error) throw error
      toast.success('Project updated successfully')
    } else {
      // Create new project
      const { error } = await supabase
        .from('projects')
        .insert([projectData])

      if (error) throw error
      toast.success('Project created successfully')
    }

    itemsToShow.value = 5 // Reset to show first 5
    await fetchProjects()
    closeModal()
  } catch (error) {
    console.error('Error saving project:', error)
    toast.error('Error saving project. Please try again.')
  }
}

// Edit project
const editProject = (project) => {
  editingProject.value = project
  formData.value = {
    title: project.title,
    description: project.description,
    image_url: project.image_url,
    project_type: tagsToProjectType(project.tags)
  }
  showAddModal.value = true
}

// Delete project
const deleteProject = async (id) => {
  const confirmed = await confirmDialog.confirm('This project and all its content will be permanently deleted.')
  if (!confirmed) return

  try {
    const { error } = await supabase
      .from('projects')
      .delete()
      .eq('id', id)

    if (error) throw error

    itemsToShow.value = 5 // Reset to show first 5
    await fetchProjects()
    toast.success('Project deleted successfully')
  } catch (error) {
    console.error('Error deleting project:', error)
    toast.error('Error deleting project. Please try again.')
  }
}

// Close modal
const closeModal = () => {
  showAddModal.value = false
  editingProject.value = null
  formData.value = {
    title: '',
    description: '',
    image_url: '',
    project_type: ''
  }
}

// Load projects on mount
onMounted(() => {
  fetchProjects()
})
</script>
