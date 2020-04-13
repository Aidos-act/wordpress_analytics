import Vue from 'vue'
import VueRouter from 'vue-router'
import DashboardIndex from '../dashboard/DashboardIndex.vue'
import HeatmapPage from '../heatmap/HeatmapPage.vue'

Vue.use(VueRouter)

const routes = [
  { path: '/',  name: 'DashboardIndex', component: DashboardIndex },
  { path: '/api/v1/articles/:id',  name: 'HeatmapPage', component: HeatmapPage }
];

export default new VueRouter({ routes }); 