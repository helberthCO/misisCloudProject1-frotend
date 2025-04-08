import { createRouter, createWebHistory } from 'vue-router'
import Login from '@/views/Login/Login.vue'
import Register from '@/views/Register/Register.vue'
import HomeView from '@/views/HomeView/HomeView.vue'

const routes = [
  {
    path: '/',
    name: 'home',
    component: HomeView
  },
  {
    path: '/login',
    name: 'login',
    component: Login
  },
  {
    path: '/register',
    name: 'register',
    component: Register
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router