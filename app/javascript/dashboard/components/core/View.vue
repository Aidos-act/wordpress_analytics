<template>
  <v-content>
    <router-view />
    <!-- <dashboard-core-footer /> -->
  </v-content>
</template>

<script>
  // import Spinner from '../../../components/Spinner.vue'
  import bus from '../../utils/bus.js'
  export default {
    name: 'DashboardCoreView',

    // components: {
    //   DashboardCoreFooter: () => import('./Footer'),
    //   Spinner,
    // },
    // data() {
    //   return {
    //     loadingStatus: false
    //   }
    // },
    // methods: {
    //   startSpinner() {
    //     this.loadingStatus = true;
    //   },
    //   endSpinner() {
    //     this.loadingStatus = false;
    //   },
    // },
    // created() {
    //   bus.$on('start:spinner', this.startSpinner());
    // }
  }
</script>
