<template>
  <v-app>
    <dashboard-core-app-bar />
    <dashboard-core-drawer />
    <dashboard-core-view />
    <dashboard-core-settings />
  </v-app>
</template>

<script>
  export default {
    name: 'DashboardMainIndex',

    // lazy load(chunk)
    components: {
      // header part
      DashboardCoreAppBar: () => import('./components/core/AppBar'),
      // side part
      DashboardCoreDrawer: () => import('./components/core/Drawer'),
      // pop up part
      DashboardCoreSettings: () => import('./components/core/Settings'),
      // main view
      DashboardCoreView: () => import('./components/core/View'),
    }
  }
</script>
