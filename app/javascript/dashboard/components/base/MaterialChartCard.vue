<template>
  <material-card
    class="v-card--material-chart"
    v-bind="$attrs"
  >
    <template v-slot:heading>
      <barChart
        :chartdata="data"
        :options="options"
        :styles="styles"
        :height="200"
      />
    </template>

    <slot />

    <slot
      slot="actions"
      name="actions"
    />
  </material-card>
</template>

<script>
  import MaterialCard from './MaterialCard.vue'
  import barChart from '../barChart.js'
  export default {
    name: 'MaterialChartCard',

    components: {
      barChart,
      MaterialCard
    },
    inheritAttrs: false,

    props: {
      data: {
        type: Object,
        default: () => ({}),
      },
      styles: {
        type: Object,
        default: () => ({}),
      },
      options: {
        type: Object,
        default: () => ({}),
      },
      responsiveOptions: {
        type: Array,
        default: () => ([]),
      },
      type: {
        type: String,
        required: true,
        validator: v => ['Bar', 'Line', 'Pie'].includes(v),
      },
    },
  }
</script>

<style lang="scss">
  .v-card--material-chart{
  	> p{
  		color: #999;
  	}
  	.v-card--material__heading{
  		max-height: 185px;

  		.ct-label{
  			color: inherit;
	        opacity: .7;
	        font-size: 0.975rem;
	        font-weight: 100;
  		}
  		.ct-grid{
  			stroke: rgba(255, 255, 255, 0.2);
  		}
  		.ct-series-a .ct-point,
        .ct-series-a .ct-line,
        .ct-series-a .ct-bar,
        .ct-series-a .ct-slice-donut{
        	stroke: rgba(255,255,255,.8);
        }
        .ct-series-a .ct-slice-pie,
        .ct-series-a .ct-area{
          fill: rgba(255,255,255,.4);
        }
  	}
  }
</style>
