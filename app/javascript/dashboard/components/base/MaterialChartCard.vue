<template>
  <material-card
    class="v-card--material-chart"
    v-bind="$attrs"
    :sheetHeight="sheetHeight"
  >
    <template v-slot:heading>
        <v-progress-circular  
          v-if="graphType === 'goal'"
          :value="50"
          :rotate="-90"
          :size="chartsize"
          :width="20"
          color="‎teal"
        >
          <h1>50%</h1>
        </v-progress-circular>
        <!-- <line-chart
          v-if="graphType === 'linel'"
          :data="{'2017-05-13': 2, '2017-05-14': 5}"
          :height="chartheight"
          :colors="['#FFFFF3', '#FFFFF3']"
          backgroundColor="#FFFFF3"
        /> -->
        <pie-chart
          v-if="graphType === 'pie'"
          :data="piedata"
          :height="chartheight"
          :colors="['#c8e6c9', '#e0f7fa']"
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
        <v-col 
          v-if="graphType === 'linel'"
          class="display-3" 
        >
          {{ mcvdata }}
        </v-col>
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
    data() {
      return {
        testdata: [
          {
            name: "Male",
            data: [["18-24", 24], ["25-34", 22], ["35-44", 19], ["45-54", 30], ["55-64", 11], ["65+", 12]],
            stack: "stack 1" 
          },
          {
            name: "Female", 
            data: [["18-24", 32], ["25-34", 14], ["35-44", 17], ["45-54", 12], ["55-64", 10], ["65+", 14]],
            stack: "stack 2"
          }
        ], 
      }
    },
    props: {
      data: {
        type: Object,
        default: () => ({}),
      },
      piedata: {
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
  .v-progress-circular {
    margin: 1rem;
    margin-top: 0rem;
  }
  .v-application .text-start {
    text-align: center;
  }
</style>
