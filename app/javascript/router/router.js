import Vue from 'vue'
import VueRouter from 'vue-router'

Vue.use(VueRouter)
 
const routes = [
  {
    path: '/',
    component: () => import('../dashboard/Index.vue'),
    children: [
      // Dashboard
      {
        name: 'Dashboard',
        path: '',
        component: () => import('../dashboard/Dashboard.vue'),
      },
      { 
        name: 'HeatmapPage',
        path: '/api/v1/articles/:id',
        component: () =>
          import("../heatmap/HeatmapPage.vue")
      }
    ],
  },
];

export default new VueRouter({ mode: 'history', routes });