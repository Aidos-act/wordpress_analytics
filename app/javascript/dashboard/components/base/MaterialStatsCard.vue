<template>
  <!-- refer to dashboard/components/base/MaterialCard.vue -->
  <!-- $attrs is the attributions including color, title , ... , from parent component. in this case, Dashboard.vue -->
  <material-card
    :icon="icon"
    class="v-card--material-stats"
    v-bind="$attrs"
  >
    <!-- slot part for material card -->
    <template v-slot:after-heading>
      <div class="ml-auto text-right">
        <div
          class="body-3 grey--text font-weight-light"
          v-text="title"
        />

        <h3 class="display-2 font-weight-light text--primary">
          {{ title=='MCVR' ? value +'%' : value }}
        </h3>
      </div>
    </template>

    <v-col
      cols="12"
      class="px-0"
    >
      <v-divider />
    </v-col>
    
    <template v-if="subData">
      <v-icon
        :color="subData.color"
        size="16"
        class="ml-2 mr-1"
      >
        {{ subData.icon }}
      </v-icon>

      <span
        :class="subTextColor"
        class="caption grey--text font-weight-light" 
      >
       {{ subData.text }}{{ subData.calculatedData }}% <v-icon>{{ subData.subIcon }}</v-icon> 
      </span>
      <span
        class="caption grey--text font-weight-light"
        style="text-align: right;"
      >
            {{ subData.date }}と比較する
      </span>
    </template>    
  </material-card>
</template>

<script>
  import Card from './Card.vue'
  import MaterialCard from './MaterialCard.vue'

  export default {
    name: 'MaterialStatsCard',
    components: {
      MaterialCard,
    },
    inheritAttrs: false,

    props: {
      ...Card.props,
      icon: {
        type: String,
        required: true,
      },
      subIcon: {
        type: String,
        default: undefined,
      },
      subIconColor: {
        type: String,
        default: undefined,
      },
      subTextColor: {
        type: String,
        default: undefined,
      },
      subText: {
        type: String,
        default: undefined,
      },
      subData: {
        type: Array,
        default: undefined,
      },
      title: {
        type: String,
        default: undefined,
      },
      value: {
        type: String,
        default: undefined,
      },
      smallValue: {
        type: String,
        default: undefined,
      },
    },
  }
</script>

<style lang="scss">
.v-card--material-stats{
	display: flex;
  flex-wrap: wrap;
  position: relative;

  	> div:first-child{
    	justify-content: space-between;
  	}

  .v-card{
  	border-radius: 4px;
    flex: 0 1 auto;
  }

  .v-card__text{
  	display: inline-block;
    flex: 1 0 calc(100% - 120px);
    position: absolute;
    top: 0;
    right: 0;
    width: 100%;
  }

  .v-card__actions{
  	flex: 1 0 100%;
  }
}

.v-application .display-2{
  font-size: 1.5625rem !important;
  line-height: 1.4em;
  letter-spacing: normal !important;
}
  
</style>