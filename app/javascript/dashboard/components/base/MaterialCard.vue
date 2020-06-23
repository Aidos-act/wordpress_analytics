<template>
  <v-card
    v-bind="$attrs"
    :class="classes"
    class="v-card--material pa-3"
  >
    <div class="d-flex grow flex-wrap">
      <!-- please refer to v-sheet part in the vuetify docs. https://vuetifyjs.com/en/components/sheets/#sheets -->
      <!-- data(props) is from parent components. for example, Dashboard.vue -> MaterialStatsCard.vue -> here -->
      <v-sheet
        :class="{
          'pa-7': true
        }"
        :color="color"
        :max-height="icon ? 90 : undefined"
        :width="icon ? 'auto' : '100%'"
        :height="sheetHeight"
        elevation="6"
        class="text-start v-card--material__heading mb-n6"
        dark
      >
        <slot
          v-if="$slots.heading"
          name="heading"
        />

        <v-icon
          v-else-if="icon"
          size="32"
          v-text="icon"
        />

      </v-sheet>

      <div
        v-if="$slots['after-heading']"
        class="ml-6"
      >
        <slot name="after-heading" />
      </div>

    </div>
    
    <!-- slot for sub part -->
    <slot />

  </v-card>
</template>

<script>
  export default {
    name: 'MaterialCard',

    props: {
      color: {
        type: String,
        default: 'success',
      },
      text: {
        type: String,
        default: '',
      },
      icon: {
        type: String,
        default: undefined,
      },
      title: {
        type: String,
        default: '',
      },
      sheetHeight: {
        type: Number,
        default: undefined
      }
    },

    computed: {
      classes () {
        return {
          'v-card--material--has-heading': this.hasHeading,
        }
      },
      hasHeading () {
        return Boolean(this.$slots.heading || this.title || this.icon)
      },
    },
  }
</script>

<style lang="scss">
  .v-card--material {
  	&__heading{
  		position: relative;
     	top: -40px;
      	transition: .3s ease;
      	z-index: 1;
  	}
  }

</style>
