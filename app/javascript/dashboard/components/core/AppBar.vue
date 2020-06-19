<template>
  <!-- please refer to AppVar in the https://vuetifyjs.com/ -->
  <v-app-bar
    id="app-bar"
    absolute
    app
    color="transparent"
    flat
    height="75"
  >
    <!-- please refer to Vbtn in the https://vuetifyjs.com/ -->
    <!-- setDrawer is from store.js, please refer to vuex, vuex map. https://qiita.com/terufumi1122/items/6f9470c8d416a4af7502 -->
    <v-btn
      class="mr-3"
      elevation="1"
      fab
      small
      @click="setDrawer(!drawer)"
    >
      <v-icon v-if="!drawer">
        mdi-view-quilt
      </v-icon> 

      <v-icon v-else>
        mdi-dots-vertical
      </v-icon>
    </v-btn>

    <v-toolbar-title
      class="hidden-sm-and-down font-weight-light"
    >
      <!-- showing up article id when user access to heatmap page -->
      {{ this.$route.params.id ? '記事 ID : ' + this.$route.params.id : 'ダッシュボード' }}
    </v-toolbar-title>

    <v-spacer />

    <div class="mx-3" />
    <v-tooltip
      content-class="bottom"
      bottom
    >
      <!-- please refer to https://qiita.com/aotoriii/items/06ae49c135061a12b75e -->
      <template v-slot:activator="{ attrs, on }">
        <v-btn
          class="ml-2"
          min-width="0"
          text
          to="/"
        >
          <v-icon
            v-bind="attrs"
            v-on="on"
          >
            mdi-chart-areaspline
          </v-icon>
        </v-btn>
      </template>
      <span>メインダッシュボード</span>
    </v-tooltip>

    <v-tooltip
      content-class="bottom"
      bottom
    >
      <template v-slot:activator="{ attrs, on }">
        <v-btn
          class="ml-2"
          min-width="0"
          text
          to="/"
        >
          <v-icon
            v-bind="attrs"
            v-on="on"
          >
            mdi-account
          </v-icon>
        </v-btn>
      </template>
      <span>Terms</span>
    </v-tooltip>
  </v-app-bar>
</template>

<script>
  // Utilities
  import { mapState, mapMutations } from 'vuex'

  export default {
    name: 'DashboardCoreAppBar',
    computed: {
      ...mapState(['drawer']),
    },

    methods: {
      ...mapMutations({
        setDrawer: 'SET_DRAWER',
      }),
    },
  }
</script>