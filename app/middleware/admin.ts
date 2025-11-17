export default defineNuxtRouteMiddleware((to, from) => {
  const user = useSupabaseUser()

  // If trying to access admin routes without being logged in
  if (!user.value) {
    return navigateTo('/login')
  }

  // User is authenticated, allow access
  return
})
