<template>
  <NuxtLayout name="admin">
    <div class="max-w-7xl mx-auto">
      <!-- Header Area -->
      <div class="flex flex-col md:flex-row md:items-center justify-between gap-6 mb-12">
        <div>
          <h1 class="text-4xl font-bold tracking-tight text-white mb-2 font-display">Manage Projects</h1>
          <p class="text-white/40 font-medium">Coordinate and showcase your body of work ({{ projects.length }} total)
          </p>
        </div>
        <button @click="showAddModal = true"
          class="group flex items-center justify-center gap-2 px-6 py-3 bg-white text-black rounded-full font-bold hover:bg-bright-pink hover:text-white transition-all duration-300">
          <svg class="w-5 h-5 transition-transform group-hover:rotate-90" fill="none" stroke="currentColor"
            viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M12 4v16m8-8H4"></path>
          </svg>
          Create Project
        </button>
      </div>

      <!-- Loading State -->
      <div v-if="loading" class="flex flex-col items-center justify-center py-24">
        <div class="w-12 h-12 border-2 border-white/10 border-t-white rounded-full animate-spin mb-4"></div>
        <p class="text-white/40 font-medium animate-pulse">Retrieving projects...</p>
      </div>

      <!-- Projects Grid -->
      <div v-else class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
        <!-- Add Project Placeholder (Only visible if no projects) -->
        <div v-if="projects.length === 0" @click="showAddModal = true"
          class="group cursor-pointer aspect-4/3 rounded-3xl border-2 border-dashed border-white/5 hover:border-white/20 hover:bg-white/[0.02] transition-all flex flex-col items-center justify-center gap-4">
          <div class="w-16 h-16 rounded-full bg-white/5 flex items-center justify-center group-hover:scale-110 transition-transform">
            <svg class="w-8 h-8 text-white/20 group-hover:text-white/40" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"></path>
            </svg>
          </div>
          <p class="text-white/20 font-bold group-hover:text-white/40 transition-colors">Start your first project</p>
        </div>

        <!-- Project Cards -->
        <div v-for="project in displayedProjects" :key="project.id"
          class="group relative bg-white/[0.03] rounded-3xl overflow-hidden hover:bg-white/[0.05] transition-all duration-500 flex flex-col">
          <!-- Project Image -->
          <div class="relative aspect-4/3 overflow-hidden bg-white/5">
            <img v-if="project.image_url" :src="project.image_url" :alt="project.title"
              class="w-full h-full object-cover grayscale opacity-60 group-hover:grayscale-0 group-hover:opacity-100 transition-all duration-700 group-hover:scale-105" />
            <div v-else class="w-full h-full flex items-center justify-center opacity-20">
              <svg class="w-16 h-16 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1"
                  d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
              </svg>
            </div>

            <!-- Absolute Overlay for critical status -->
            <div class="absolute top-4 right-4 flex gap-2">
              <button @click.stop="editProject(project)"
                class="w-10 h-10 rounded-full bg-black/60 backdrop-blur-md flex items-center justify-center text-white/70 hover:text-white hover:bg-white/20 transition-all">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                    d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z" />
                </svg>
              </button>
              <button @click.stop="deleteProject(project.id)"
                class="w-10 h-10 rounded-full bg-black/60 backdrop-blur-md flex items-center justify-center text-white/70 hover:text-bright-pink hover:bg-white/20 transition-all">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                    d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                </svg>
              </button>
            </div>
          </div>

          <!-- Project Info -->
          <div class="p-8 flex-1 flex flex-col">
            <div class="flex items-start justify-between gap-4 mb-4">
              <h3 class="text-xl font-bold text-white group-hover:text-bright-pink transition-colors line-clamp-1 font-display">
                {{ project.title }}
              </h3>
            </div>
            <p class="text-white/40 text-sm leading-relaxed mb-6 line-clamp-2">
              {{ project.description }}
            </p>

            <!-- Tags -->
            <div v-if="project.tags && project.tags.length > 0" class="flex flex-wrap gap-2 mb-8">
              <span v-for="(tag, index) in project.tags" :key="index"
                class="px-3 py-1 text-[10px] uppercase tracking-widest bg-white/[0.05] text-white/60 rounded-full font-bold">
                {{ tag.label }}
              </span>
            </div>

            <!-- Main Action -->
            <div class="mt-auto">
              <NuxtLink :to="`/admin/project-content/${project.id}`"
                class="block w-full py-3 bg-white/5 border border-white/5 text-white/80 rounded-2xl text-center text-sm font-bold hover:bg-white hover:text-black hover:border-white transition-all duration-300">
                Manage Content
              </NuxtLink>
            </div>
          </div>
        </div>
      </div>

      <!-- Show More Button -->
      <div v-if="!loading && projects.length > itemsToShow && displayedProjects.length < projects.length"
        class="flex justify-center mt-16">
        <button @click="showMore"
          class="px-10 py-4 bg-white/5 text-white rounded-full font-bold hover:bg-white hover:text-black transition-all duration-300 border border-white/10">
          Load More ({{ projects.length - displayedProjects.length }} remaining)
        </button>
      </div>
    </div>

    <!-- Add/Edit Modal (Premium Borderless) -->
    <div v-if="showAddModal"
      class="fixed inset-0 bg-[#080210]/80 backdrop-blur-xl flex items-center justify-center z-[100] p-6"
      @click.self="closeModal">
      <div class="bg-white/5 border border-white/10 rounded-[2.5rem] shadow-2xl max-w-xl w-full max-h-[90vh] overflow-hidden flex flex-col">
        <div class="p-10 overflow-y-auto">
          <div class="flex items-center justify-between mb-10">
            <h2 class="text-3xl font-bold text-white font-display">
              {{ editingProject ? 'Edit Project' : 'New Project' }}
            </h2>
            <button @click="closeModal" class="text-white/40 hover:text-white transition-colors">
              <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
              </svg>
            </button>
          </div>

          <form @submit.prevent="saveProject" class="space-y-8">
            <!-- Title -->
            <div class="space-y-3">
              <label class="block text-xs font-bold text-white/40 uppercase tracking-widest ml-1">Project Title</label>
              <input v-model="formData.title" type="text" required
                class="w-full px-6 py-4 bg-white/5 border border-white/10 text-white rounded-2xl focus:ring-2 focus:ring-bright-pink focus:border-transparent outline-hidden transition-all placeholder:text-white/20"
                placeholder="Unique brand identity..." />
            </div>

            <!-- Description -->
            <div class="space-y-3">
              <label class="block text-xs font-bold text-white/40 uppercase tracking-widest ml-1">Summary</label>
              <textarea v-model="formData.description" required rows="3"
                class="w-full px-6 py-4 bg-white/5 border border-white/10 text-white rounded-2xl focus:ring-2 focus:ring-bright-pink focus:border-transparent outline-hidden transition-all placeholder:text-white/20 resize-none"
                placeholder="A brief overview of this work..."></textarea>
            </div>

            <!-- Image Upload -->
            <div class="space-y-3">
              <label class="block text-xs font-bold text-white/40 uppercase tracking-widest ml-1">Cover Image</label>
              <div class="relative group">
                <div v-if="formData.image_url" class="relative rounded-3xl overflow-hidden mb-4 aspect-16/9 bg-white/5 border border-white/10">
                  <img :src="formData.image_url" alt="Preview" class="w-full h-full object-cover" />
                  <div class="absolute inset-0 bg-black/40 opacity-0 group-hover:opacity-100 transition-opacity flex items-center justify-center gap-4">
                    <button type="button" @click="$refs.fileInput.click()" class="px-5 py-2 bg-white text-black rounded-full font-bold text-sm transform translate-y-4 group-hover:translate-y-0 transition-all">Change</button>
                  </div>
                </div>
                <div v-else @click="$refs.fileInput.click()" 
                  class="cursor-pointer py-12 rounded-3xl border-2 border-dashed border-white/10 hover:border-white/20 hover:bg-white/[0.02] transition-all text-center flex flex-col items-center justify-center">
                  <div class="w-12 h-12 rounded-full bg-white/5 flex items-center justify-center mb-3">
                    <svg class="w-6 h-6 text-white/20" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
                    </svg>
                  </div>
                  <span class="text-white/40 font-bold">Select high-quality visual</span>
                  <span class="text-white/20 text-xs mt-1">PNG, JPG or WebP</span>
                </div>
                <input ref="fileInput" type="file" accept="image/*" @change="handleFileUpload" class="hidden" />
              </div>
            </div>

            <!-- Project Type -->
            <div class="space-y-3">
              <label class="block text-xs font-bold text-white/40 uppercase tracking-widest ml-1">Category</label>
              <div class="relative">
                <select v-model="formData.project_type" required
                  class="w-full px-6 py-4 bg-white/5 border border-white/10 text-white rounded-2xl focus:ring-2 focus:ring-bright-pink focus:border-transparent outline-hidden transition-all appearance-none cursor-pointer">
                  <option value="branding" class="bg-[#080210] font-sans">Branding & Identity</option>
                  <option value="print" class="bg-[#080210] font-sans">Print Design</option>
                  <option value="digital" class="bg-[#080210] font-sans">Digital Design</option>
                  <option value="packaging" class="bg-[#080210] font-sans">Packaging Design</option>
                  <option value="illustration" class="bg-[#080210] font-sans">Illustration</option>
                  <option value="ui-ux" class="bg-[#080210] font-sans">UI/UX Design</option>
                  <option value="photography" class="bg-[#080210] font-sans">Photography</option>
                  <option value="web" class="bg-[#080210] font-sans">Web Design</option>
                  <option value="motion" class="bg-[#080210] font-sans">Motion Design</option>
                  <option value="other" class="bg-[#080210] font-sans">Logo</option>
                </select>
                <div class="absolute right-4 top-1/2 -translate-y-1/2 pointer-events-none text-white/20">
                  <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
                  </svg>
                </div>
              </div>
            </div>

            <!-- Form Actions -->
            <div class="flex items-center gap-4 pt-4">
              <button type="button" @click="closeModal"
                class="flex-1 px-8 py-4 bg-white/5 text-white rounded-2xl font-bold hover:bg-white/10 transition-all">
                Cancel
              </button>
              <button type="submit" :disabled="uploading"
                class="flex-1 px-8 py-4 bg-white text-black rounded-2xl font-bold hover:bg-bright-pink hover:text-white transition-all disabled:opacity-50">
                <span v-if="uploading">Processing...</span>
                <span v-else>{{ editingProject ? 'Update' : 'Launch' }} Project</span>
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>

    <!-- Confirm Dialog -->
    <ConfirmDialog :show="confirmDialog.showDialog.value" :message="confirmDialog.message.value"
      @confirm="confirmDialog.handleConfirm()" @cancel="confirmDialog.handleCancel()" />
  </NuxtLayout>
</template>

<script setup>
import ConfirmDialog from '~/components/ConfirmDialog.vue'
import { useConfirm } from '~/composables/useConfirm'

definePageMeta({
  middleware: 'admin',
  layout: false
})

const supabase = useSupabaseClient()
const toast = useAppToast()
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
