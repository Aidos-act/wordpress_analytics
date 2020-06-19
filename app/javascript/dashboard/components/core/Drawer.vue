<template>
  <!-- please refer to navigation drawer in the https://vuetifyjs.com/ -->
  <!-- drawer is from store.js -->
  <v-navigation-drawer
    id="core-navigation-drawer"
    v-model="drawer"
    :dark="true"
    mobile-break-point="960"
    app
    width="260"
  >
    <v-list
      dense
      nav
    >
      <v-list-item
        to="/"
      >
        <v-list-item-avatar
          class="align-self-center"
          color="white"
          contain
        >
          <v-img
            src="https://fullout.jp/wp-content/uploads/2019/04/fullout_logo-1.jpg?1588916070"
            max-height="50"
          />
        </v-list-item-avatar>

        <v-list-item-content>
          <v-list-item-title class="display-1">Fullout Analytics</v-list-item-title>
        </v-list-item-content>
      </v-list-item>
    </v-list>

    <v-divider class="mb-2" />

    <v-list
      expand
      nav
    >
      <template v-for="(item, i) in items">
          <v-list-item
            :key="`item-${i}`"
            :to="item.to"
            :active-class="`error white--text`"
          >
            <v-list-item-icon>
              <v-icon v-text="item.icon" />
            </v-list-item-icon>

            <v-list-item-content>
              <v-list-item-title v-text="item.title" />
            </v-list-item-content>
          </v-list-item>
      </template>
    </v-list>
  </v-navigation-drawer>
</template>

<script>
  export default {
    name: 'DashboardCoreDrawer',
    props: {
      expandOnHover: {
        type: Boolean,
        default: false,
      },
    },

    data: () => ({
      items: [
        {
          icon: 'mdi-view-dashboard',
          title: 'メインダッシュボード',
          to: '/',
        },
        {
          title: '記事ダッシュボード',
          icon: 'mdi-align-vertical-bottom',
          to: '/articleDashboard',
        },
        {
          title: 'ヒートマップ',
          icon: 'mdi-chart-bubble',
          to: '/api/v1/articles/1',
        }
      ]
    }),

    computed: {
      drawer: {
        get () {
          return this.$store.state.drawer
        }
      },
    },
  }
</script>

<style scoped>
  .v-application .display-1{
    font-size: 1.125rem !important;
    font-weight: initial;
  }
  
</style>
