<template>
  <v-app id="app"> 
    <Header/>
    <router-view></router-view>
  </v-app> 
</template>

<script>
  import Header from './components/Header.vue'
  export default {
    name: 'App',
    components: {
      Header
    },
  }

</script>

<style scoped>
</style>