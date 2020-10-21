<template>
  <material-card
    class="v-card--material-chart"
    v-bind="$attrs"
    :sheetHeight="sheetHeight"
  >
    <!-- shows the chart according to its graphtype which is from parent side -->
    <template v-slot:heading>
        <v-progress-circular  
          v-if="graphType === 'goal'"
          :value="progressdata[0]"
          :indeterminate="loadingStatus"
          :rotate="-90"
          :size="chartsize"
          :width="20"
          color="‎teal"
        >
          <h1 v-if="!loadingStatus">{{ progressdata[0] }}%</h1>
        </v-progress-circular>

        <pie-chart
          v-if="graphType === 'pie'"
          :data="piedata"
          :height="chartheight"
          :colors="['#f8bbd0', '#FFFFFF']"
          :dataset="{borderWidth: 0}"
        />

        <column-chart
          v-if="graphType === 'column'"
          :data="columndata"
          :height="chartheight"
          :colors="['#2962ff', '#E91E63']"
        />

        <column-chart
          v-if="graphType === 'stacked'"
          :data="columndata"
          :stacked="true"
          :height="chartheight"
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
      piedata: {
        type: Array,
        default: () => ([]),
      },
      progressdata: {
        type: Array,
        default: () => ([]),
      },
      columndata: {
        type: Array,
        default: () => ([]),
      },
      mcvdata: {
        type: String,
        default: ''
      },
      styles: {
        type: Object,
        default: () => ({}),
      },
      sheetHeight: {
        type: Number,
        default: undefined
      },
      chartheight: {
        type: String,
        default: ''
      },
      chartsize: {
        type: Number,
        default: undefined
      },
      graphType:{
        type: String,
        default: '',
      },
      loadingStatus: {
        type: Boolean,
        default: true
      },
      options: {
        type: Object,
        default: () => ({}),
      },
      responsiveOptions: {
        type: Array,
        default: () => ([]),
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
  .v-progress-circular ‎teal--text {
    margin: 1rem;
    margin-top: 0rem;
  }

  .v-application .text-start {
    text-align: center !important;
  }
  

</style>
