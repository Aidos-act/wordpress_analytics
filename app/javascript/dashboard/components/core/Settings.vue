<template>
  <div id="settings-wrapper">
    <v-card
      id="settings"
      class="py-2 px-4"
      color="rgba(0, 0, 0, .3)"
      dark
      flat
      link
      min-width="100"
      style="position: fixed; top: 115px; right: -35px; border-radius: 8px;"
    >
      <v-icon large>
        mdi-filter
      </v-icon>
    </v-card>

    <v-menu
      :close-on-content-click="false"
      activator="#settings"
      bottom
      content-class="v-settings"
      left
      nudge-left="8"
      offset-x
      origin="top right"
      transition="scale-transition"
    >
      <v-card
        class="text-center mb-0"
        width="300"
      >
      

        <v-card-text>
          <strong class="mb-3 d-inline-block">Goal Setting</strong>
          <v-row
            align="center"
            no-gutters
          >
            <v-col cols="auto">
              Please Set up Company's Goal
            </v-col>
          </v-row>
          <v-row>
            <v-col class="pr-4">
              <v-slider
                v-model="slider"
                class="align-center"
                :max="setPV()[1]"
                :min="setPV()[0]"
                hide-details
              >
                <template v-slot:append>
                  <v-text-field
                    v-model="slider"
                    class="mt-0 pt-0"
                    hide-details
                    single-line
                    type="number"
                    style="width: 60px"
                  ></v-text-field>
                </template>
              </v-slider>
            </v-col>
          </v-row>

          <v-btn
            block
            class="mb-3"
            color="success"
            default
            @click="setGoal()"
          >
            ADD
          </v-btn>

          <div class="my-12" />

          <div>
            <strong class="mb-3 d-inline-block">It's Coming!</strong>
          </div>
        </v-card-text>
      </v-card>
    </v-menu>
  </div>
</template>

<script>

  export default {
    name: 'DashboardCoreSettings',
    data() {
      return{
        goalData: 0,
        arr: [],
        slider: '',
      }
    },
    methods: {
      setGoal() {
        console.log(this.slider);
        this.$store.state.goalData = this.slider;
      },
      setPV(){
        var totalValue = this.$store.state.totalgainfos[0];
        var int=0;
        for(var key in totalValue){
          int = parseInt(totalValue['pageviews'], 10);
        }

        this.arr[0] = int;
        this.arr[1] = int*1.5;

        return this.arr;
      },

    }
  }
</script>

<style>
  .v-settings{
  	.v-item-group > * {
      cursor: pointer;
  	}

    &__item{
    	border-width: 3px;
      	border-style: solid;
      	border-color: transparent !important;
      	&--active{
      		border-color: #00cae3 !important;
      	}
        
    }
  }

</style>