// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  compatibilityDate: '2025-07-15',
  devtools: { enabled: true },
    routeRules: {
    '/users': { proxy: 'http://backend:8000/users' }
  }
})
