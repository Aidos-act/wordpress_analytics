<template>
  <v-navigation-drawer
    id="core-navigation-drawer"
    v-model="drawer"
    :dark="true"
    :expand-on-hover="expandOnHover"
    mobile-break-point="960"
    app
    width="260"
    v-bind="$attrs"
  >

    <v-list
      dense
      nav
    >
      <v-list-item>
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
          title: 'dashboard',
          to: '/',
        },
        {
          title: 'icons',
          icon: 'mdi-chart-bubble',
          to: '/components/icons',
        },
      ],
    }),

    computed: {
      drawer: {
        get () {
          return this.$store.state.drawer
        },
        set (val) {
          this.$store.commit('SET_DRAWER', val)
        },
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
