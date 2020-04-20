import Vue from 'vue'
import VueRouter from 'vue-router'

Vue.use(VueRouter)

const routes = [
  { 
  	path: '/',
  	name: 'DashboardIndex',
  	component: () =>
  		import(/* webpackChunkName: "dashboardIndex"*/ "../dashboard/DashboardIndex.vue") 
  },
  { 
  	path: '/api/v1/articles/:id',
  	name: 'HeatmapPage',
  	component: () =>
  		import(/* webpackChunkName: "heatmapPage"*/ "../heatmap/HeatmapPage.vue")
  }
];

export default new VueRouter({ mode: 'history', routes });