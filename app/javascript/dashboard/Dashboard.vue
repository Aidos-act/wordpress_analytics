<template>
  <v-container
    id="dashboard"
    fluid
    tag="section"
  >
    <v-row>
      <!-- datepicker start -->
      <v-col cols="12" sm="3">
        <v-menu
        ref="menu"
        v-model="menu"
        :close-on-content-click="false"
        :return-value.sync="dates"
        transition="scale-transition"
        offset-y
        min-width="200px"
      >
          <template v-slot:activator="{ on }">
            <v-text-field v-model="dateRangeText" label="Date range" readonly v-on="on"></v-text-field>
          </template>
          <v-date-picker v-model="dates" range no-title scrollable>
            <v-btn text color="primary" @click="menu = false">Cancel</v-btn>
            <v-btn text color="primary" @click="getDate(dates)" :disabled="dateError">
              <span @click="$refs.menu.save(dates)">OK</span>
            </v-btn>
          </v-date-picker>
        </v-menu>
      </v-col>
      <!-- datepicker end -->


      <!-- dropdown graph start -->
      <v-col class="d-flex" cols="12" sm="6">
        <v-container fluid>
          <v-select
            v-model="selectedItem.item"
            item-text="key"
            item-value="item"
            :items="items"
            label="Select"
            dense
            @input="getDropDwn"
          ></v-select>
        </v-container>
      </v-col>

      <!-- line chart start -->
      <v-container class="chart-container">
        <line-chart :data="dropdwninfos"></line-chart>
      </v-container>
      <!-- line chart end -->
      <!-- dropdown graph end -->
 
      {{ getCompaerDates }}

      <!-- card data start -->
      <template v-for="data in totalgainfos">

        <!-- stats card 1 start -->
        <v-col
        cols="12"
        sm="6"
        lg="3"
        >
          <material-stats-card
            color="info"
            icon="mdi-baby-face-outline"
            title="Visists"
            :value="data.sessions"
            :sub-data="compareCheck(data.sessions, 'sessions')"
          />
        </v-col>
        <!-- stats card 1 end -->

        <!-- stats card 2 start -->
        <v-col
          cols="12"
          sm="6"
          lg="3"
        >
          <material-stats-card
            color="#fcba03"
            icon="mdi-poll"
            title="Unique visitors"
            :value="data.uniquePageviews"
            :sub-data="compareCheck(data.uniquePageviews, 'uniquePageviews')"
          />
        </v-col>
        <!-- stats card 2 end -->

        <!-- stats card 3 start -->
        <v-col
          cols="12"
          sm="6"
          lg="3"
        >
          <material-stats-card
            color="success"
            icon="mdi-store"
            title="Page views (PV)"
            :value="data.pageviews"
            :sub-data="compareCheck(data.pageviews, 'pageviews')"
          />
        </v-col>
        <!-- stats card 3 end -->

        <!-- stats card 4 start -->
        <v-col
          cols="12"
          sm="6"
          lg="3"
        >
          <material-stats-card
            color="orange"
            icon="mdi-sofa"
            title="% New visits"
            :value="data.bounces"
            :sub-data="compareCheck(data.bounces, 'bounces')"
          />
        </v-col>
        <!-- stats card 4 end -->

        <!-- stats card 5 start -->
        <v-col
          cols="12"
          sm="6"
          lg="3"
        >
          <material-stats-card
            color="info"
            icon="mdi-duck"
            title="Visits / UV"
            :value="data.pageviews"
            :sub-data="compareCheck(data.pageviews, 'pageviews')"
          />
        </v-col>
        <!-- stats card 5 end -->

        <!-- stats card 6 start -->
        <v-col
          cols="12"
          sm="6"
          lg="3"
        >
          <material-stats-card
            color="#fcba03"
            icon="mdi-poll"
            title="PV / UV"
            :value="data.pageviews"
            :sub-data="compareCheck(data.pageviews, 'pageviews')"
          />
        </v-col>
        <!-- stats card 6 end -->

        <!-- stats card 7 start -->
        <v-col
          cols="12"
          sm="6"
          lg="3"
        >
          <material-stats-card
            color="success"
            icon="mdi-store"
            title="Visit duration"
            :value="data.sessionDuration"
            :sub-data="compareCheck(data.sessionDuration, 'sessionDuration')"
          />
        </v-col>
        <!-- stats card 7 end -->

        <!-- stats card 8 start -->
        <v-col
          cols="12"
          sm="6"
          lg="3"
        >
          <material-stats-card
            color="orange"
            icon="mdi-sofa"
            title="%Bounce"
            :value="data.bounces"
            :sub-data="compareCheck(data.bounces, 'bounces')"
          />
        </v-col>
        <!-- stats card 8 end -->  

      </template>
      <!-- card data end -->

      <!-- chart data1 start -->
      <v-col
        cols="12"
        lg="4"
      >
        <material-chart-card
          :data="simpleTest.chartdata"
          :options="simpleTest.options"
          :styles="simpleTest.myStyles"
          :responsive-options="emailsSubscriptionChart.responsiveOptions"
          color="#E91E63"
          type="Bar"
        >
          <h4 class="card-title font-weight-light mt-2 ml-2">
            Mock Data
          </h4>

          <p class="d-inline-flex font-weight-light ml-2 mt-1">
            will be updated
          </p>

          <template v-slot:actions>
            <v-icon
              class="mr-1"
              small
            >
              mdi-clock-outline
            </v-icon>
            <span class="caption grey--text font-weight-light">NNNNNNNNNNN</span>
          </template>
        </material-chart-card>
      </v-col>
      <!-- chart data1 staendrt -->

      <!-- chart data2 start -->
      <v-col
        cols="12"
        lg="4"
      >
        <material-chart-card
          :data="dailySalesChart.data"
          :options="dailySalesChart.options"
          color="success"
          type="Line"
        >
          <h4 class="card-title font-weight-light mt-2 ml-2">
            Mock data2
          </h4>

          <p class="d-inline-flex font-weight-light ml-2 mt-1">
            <v-icon
              color="green"
              small
            >
              mdi-arrow-up
            </v-icon>
            <span class="green--text">55%</span>&nbsp;
            will be updated
          </p>

          <template v-slot:actions>
            <v-icon
              class="mr-1"
              small
            >
              mdi-clock-outline
            </v-icon>
            <span class="caption grey--text font-weight-light">NNNNNNNNNNN</span>
          </template>
        </material-chart-card>
      </v-col>
      <!-- chart data2 end -->

      <!-- chart data3 start -->
      <v-col
        cols="12"
        lg="4"
      >
        <material-chart-card
          :data="dataCompletedTasksChart.data"
          :options="dataCompletedTasksChart.options"
          color="info"
          type="Line"
        >
          <h3 class="card-title font-weight-light mt-2 ml-2">
            Mock data3
          </h3>

          <p class="d-inline-flex font-weight-light ml-2 mt-1">
            will be updated
          </p>

          <template v-slot:actions>
            <v-icon
              class="mr-1"
              small
            >
              mdi-clock-outline
            </v-icon>
            <span class="caption grey--text font-weight-light">NNNNNNNNNNN</span>
          </template>
        </material-chart-card>
      </v-col>
      <!-- chart data3 end -->


      <!-- ranking list start -->
      <v-col
        cols="12"
        md="6"
      >
        <material-card
          color="accent"
          class="px-5 py-3"
        >
          <template v-slot:heading>
            <div class="display-2 font-weight-light">
              Ranking List
            </div>

            <div class="subtitle-1 font-weight-light">
              Date Range : {{ dateRangeText }}
            </div>
          </template>
          <v-card-text>
            <v-data-table
              :headers="rankingHeaders"
              :items="rankingInfos"
              :itemsPerPage= "5"
            >
              <template v-slot:body="{ items }">
                <tbody>
                  <tr v-for="(data, index) in items">
                    <td>{{ index + 1 }}</td>
                    <td class="page-title-wrapper">
                      <p class="ranking-page-title">{{ data.pageTitle | truncate(20, '...') }}</p>
                      <small class="ranking-page-path">{{ data.pagePath }}</small>
                    </td>
                    <td>{{ data.pageviews }}</td>
                  </tr>
                </tbody>
              </template>
            </v-data-table>
          </v-card-text>
        </material-card>
      </v-col>
      <!-- ranking list end -->
      

      <!-- article list part start -->
      <v-col
        cols="12"
        md="12"
      >
        <material-card
          color="warning"
          class="px-5 py-3"
        >
          <template v-slot:heading>
            <div class="display-2 font-weight-light">
              Article List
            </div>

            <v-text-field
              v-model="search"
              append-icon="mdi-magnify"
              label="Search"
              single-line
              hide-details
            ></v-text-field>
          </template>
          
          <v-data-table
            :headers="headers"
            :items="gainfos"
            :search="search"
            :sort-desc="[false, true]"
            multi-sort
            class="elevation-1"
            :footer-props="{
              showFirstLastPage: true,
              firstIcon: 'mdi-arrow-collapse-left',
              lastIcon: 'mdi-arrow-collapse-right'
            }"
          >
            <template v-slot:body="{ items }">
              <tbody>
                <tr v-for="data in items">
                  <td class="page-title-wrapper">
                    <p class="page-title" @click="getArticleData(data.pagePath)">{{ data.pageTitle | truncate(35, '...') }}</p>
                    <small class="page-path">{{ data.pagePath }}</small>
                  </td>
                  <td>{{ data.pageviews }}</td>
                  <td>{{ data.uniquePageviews }}</td>
                  <td>{{ data.timeOnPage }}</td>
                  <td>{{ data.bounces }}</td>
                  <td>{{ data.entrances }}</td>
                  <td>{{ data.exits }}</td>
                </tr>
              </tbody>
            </template>
          </v-data-table>
        </material-card>
      </v-col>
      <!-- article list part end -->


      <!-- selected aricle data - will be deleted later, just for check -->
      <v-card v-show="showSelectedBool">
        <v-data-table
          :headers="headers"
          :items="artilceData"
          class="elevation-1"
          hide-default-footer
        >
          <template v-slot:body="{ items }">
            <tbody>
              <tr v-for="data in items">
                <td>
                  <p class="page-title">{{ data.pageTitle }}</p>
                  <small class="page-path">{{ data.pagePath }}</small>
                </td>
                <td>{{ data.pageviews }}</td>
                <td>{{ data.uniquePageviews }}</td>
                <td>{{ data.timeOnPage }}</td>
                <td>{{ data.bounces }}</td>
                <td>{{ data.entrances }}</td>
                <td>{{ data.exits }}</td>
              </tr>
            </tbody>
          </template>
        </v-data-table>
      </v-card>
      <!-- selected aricle data end -->

    </v-row>
  </v-container>
</template>

<script>
  // import LineChart from './components/lineChart.js'
  import MaterialCard from './components/base/MaterialCard.vue'
  import MaterialChartCard from './components/base/MaterialChartCard.vue'
  import MaterialStatsCard from './components/base/MaterialStatsCard.vue'

  export default {
    name: 'DashboardDashboard',
    components: {
      // LineChart,
      MaterialCard,
      MaterialChartCard,
      MaterialStatsCard
    },
    data () {
      return {
        dates: [
          new Date().toISOString().substr(0, 10),
          new Date().toISOString().substr(0, 10)
        ],
        menu: false,
        dateCheckBool: true,
        showSelectedBool: false,
        search: '',
        isActive: true,
        compareDates: [],
        selectedItem: { key: "pageView", item: "ga:pageviews"},
        items: [
          { key: "pageView", item: "ga:pageviews"},
          { key: "UV", item: "ga:uniquePageviews"},
          { key: "bounce rate", item: "ga:bounces"},
          { key: "visits", item: "ga:sessions"},
          { key: "New Visits %", item: "ga:percentNewSessions"},
          { key: "duration", item: "ga:sessionDuration"},
          
        ],
        datacollection: null,
        headers: [
          {
            text: 'Title',
            align: 'start',
            sortable: false,
            value: 'pageTitle',
            width: '50%',
          },
          { text: 'PV', value: 'pageviews' },
          { text: 'UV', value: 'uniquePageviews' },
          { text: 'time on page', value: 'timeOnPage' },
          { text: 'bounce', value: 'bounces' },
          { text: 'entrance', value: 'entrances' },
          { text: 'exit', value: 'exits' }
        ],
        rankingHeaders: [
          { text: 'No.', value: 'index' },
          {
            text: 'Title',
            align: 'start',
            sortable: false,
            value: 'pageTitle',
            width: '70%',
          },
          { text: 'PV', value: 'pageviews' },
        ],
        lineSimpleTest: {
          chartdata: {
            labels: ['January', 'February', 'March', 'April', 'May', 'June'],
            datasets: [
              {
                data: [10, 50, 20, 30, 30, 40],
              },
            ],
          },
          options: {
            legend: {
              display: false,
            },
          },
        },
        simpleTest: {
          myStyles: {
            height: '500px',
            width: '100%',
            color: 'red',
          },
          chartdata: {
            labels: ['Ja', 'Fe', 'Ma', 'Ap', 'May', 'Ju', 'Jul', 'Au', 'Se', 'Oc', 'No', 'De'],
            datasets: [
              {
                label: 'Sample1',
                fillColor: '#ffff00',
                strokeColor: '#000000',
                data: [542, 443, 320, 780, 553, 453, 326, 434, 568, 610, 756, 895],
                backgroundColor: '#FFFFF3',
              },
            ],
          },
          options: {
            legend: {
              display: false,
            },
            responsive: true,
            layout: {
              padding: {
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
              },
            },
            scales: {
              xAxes: [{
                scaleLabel: {
                  fontColor: '#000000',
                },
                ticks: {
                  fontColor: '#FFFFF3',
                },
                gridLines: {
                  offsetGridLines: false,
                },
              }],
              yAxes: [{
                scaleLabel: {
                  fontColor: '#000000',
                },
                ticks: {
                  fontColor: '#FFFFF3',
                },
                gridLines: {
                  offsetGridLines: false,
                },
              }],
            },
          },
        },
        dailySalesChart: {
          data: {
            labels: ['M', 'T', 'W', 'T', 'F', 'S', 'S'],
            series: [
              [12, 17, 7, 17, 23, 18, 38],
            ],
          },
          options: {
            low: 0,
            high: 50, // creative tim: we recommend you to set the high sa the biggest value + something for a better look
            chartPadding: {
              top: 0,
              right: 0,
              bottom: 0,
              left: 0,
            },
          },
        },
        dataCompletedTasksChart: {
          data: {
            labels: ['12am', '3pm', '6pm', '9pm', '12pm', '3am', '6am', '9am'],
            series: [
              [230, 750, 450, 300, 280, 240, 200, 190],
            ],
          },
          options: {
            low: 0,
            high: 1000, // creative tim: we recommend you to set the high sa the biggest value + something for a better look
            chartPadding: {
              top: 0,
              right: 0,
              bottom: 0,
              left: 0,
            },
          },
        },
        emailsSubscriptionChart: {
          data: {
            labels: ['Ja', 'Fe', 'Ma', 'Ap', 'Mai', 'Ju', 'Jul', 'Au', 'Se', 'Oc', 'No', 'De'],
            series: [
              [542, 443, 320, 780, 553, 453, 326, 434, 568, 610, 756, 895],

            ],
          },
          options: {
            axisX: {
              showGrid: false,
            },
            low: 0,
            high: 1000,
            chartPadding: {
              top: 0,
              right: 5,
              bottom: 0,
              left: 0,
            },
          },
          responsiveOptions: [
            ['screen and (max-width: 640px)', {
              seriesBarDistance: 5,
            }],
          ],
        },
        tabs: 0,
        tasks: {
          0: [
            {
              text: 'Sign contract for "What are conference organizers afraid of?"',
              value: true,
            },
            {
              text: 'Lines From Great Russian Literature? Or E-mails From My Boss?',
              value: false,
            },
            {
              text: 'Flooded: One year later, assessing what was lost and what was found when a ravaging rain swept through metro Detroit',
              value: false,
            },
            {
              text: 'Create 4 Invisible User Experiences you Never Knew About',
              value: true,
            },
          ],
          1: [
            {
              text: 'Flooded: One year later, assessing what was lost and what was found when a ravaging rain swept through metro Detroit',
              value: true,
            },
            {
              text: 'Sign contract for "What are conference organizers afraid of?"',
              value: false,
            },
          ],
          2: [
            {
              text: 'Lines From Great Russian Literature? Or E-mails From My Boss?',
              value: false,
            },
            {
              text: 'Flooded: One year later, assessing what was lost and what was found when a ravaging rain swept through metro Detroit',
              value: true,
            },
            {
              text: 'Sign contract for "What are conference organizers afraid of?"',
              value: true,
            },
          ],
        },
        list: {
          0: false,
          1: false,
          2: false,
        },
      }
    },
    computed: {
      dateError () {
        var currentdate =  new Date().toISOString().substr(0, 10);
        if(currentdate < this.dates[0] || currentdate < this.dates[1] || this.dates.length < 2) {
          console.log(this.dateCheckBool);
          return this.dateCheckBool;
        }
      },
      dateRangeText () {
        if(this.dates[0]>this.dates[1]){
          this.dates.reverse();
        }
        return this.dates.join(' ~ ')
      },
      getCompaerDates () {
        var t1 = this.$moment(this.dates[0]);
        var t2 = this.$moment(this.dates[1]);
        var diff = 0;
        if(t1._i == t2._i) {
          diff = 1;
        } else {
          diff = t2.diff(t1, 'days')+1;
        }
        this.compareDates[0] = t1.subtract(diff,'days').format('YYYY-MM-DD')
        this.compareDates[1] = t2.subtract(diff,'days').format('YYYY-MM-DD')
      },
      articles() {
        return this.$store.state.articles
      },
      gainfos() {
        return this.$store.state.gainfos
      },
      compareGaInfos() {
        return this.$store.state.compareGaInfos
      },
      totalgainfos(){
        return this.$store.state.totalgainfos
      },
      dropdwninfos() {
        return this.$store.state.dropdwninfos
      },
      artilceData() {
        return this.$store.state.artilceData
      },
      rankingInfos() {
        return this.$store.state.rankingInfos
      }
    },
    mounted() {
      this.getCompaerDates
      this.$store.commit('fetchArticles');
      this.$store.commit('getTotalGaInfo',{
        startdate: this.dates[0],
        enddate: this.dates[1]
      });
      this.$store.commit('getCompareGaInfo',{
        startdate: this.compareDates[0],
        enddate: this.compareDates[1]
      });
      this.$store.commit('getGaInfo',{
        startdate: this.dates[0],
        enddate: this.dates[1]
      });
      this.$store.commit('getDropDown',{
        startdate: this.dates[0],
        enddate: this.dates[1],
        selectedDrop: this.selectedItem.item
      });
      this.$store.commit('getRanking',{
        startdate: this.dates[0],
        enddate: this.dates[1]
      });
    },
    methods: {
      complete (index) {
        this.list[index] = !this.list[index]
      },
      getDate(dates) {
        console.log("please")
        this.$store.commit('getTotalGaInfo',{
          startdate: this.dates[0],
          enddate: this.dates[1]
        });
        this.$store.commit('getCompareGaInfo',{
          startdate: this.compareDates[0],
          enddate: this.compareDates[1]
        });
        this.$store.commit('getDropDown',{
          startdate: this.dates[0],
          enddate: this.dates[1],
          selectedDrop: this.selectedItem.item
        });
        this.$store.commit('getRanking',{
          startdate: this.dates[0],
          enddate: this.dates[1]
        });
      },
      getDropDwn(value){
        this.$store.commit('getDropDown',{
          startdate: this.dates[0],
          enddate: this.dates[1],
          selectedDrop: value
        })
      },
      getArticleData(value){
        this.$store.commit('getAticleData',{
          startdate: this.dates[0],
          enddate: this.dates[1],
          selectedPath: value
        })
        this.showSelectedBool = true
      },
      compareCheck(value, text){
        var compareValue = this.$store.state.compareGaInfos[0];
        var arr = [];
        var value_num = parseInt(value, 10);
        var compare_num;
        var calculatedData;
        var integer = parseInt(text, 10);

        arr["date"] = this.compareDates.join(' ~ ');

        for(var key in compareValue){
          
          if(key == text){
            compare_num = parseInt(compareValue[key], 10);

            if(value_num > compare_num){
              calculatedData = (((value_num - compare_num)/compare_num)*100).toFixed(2);
              arr["color"] = 'green';
              arr["icon"] = 'mdi-arrow-up-thick';
              arr["calculatedData"] = calculatedData;
              arr["text"] = '+';
              arr["subIcon"] = 'mdi-emoticon-cool-outline';
              return arr
            }else{
              calculatedData = (((compare_num - value_num)/compare_num)*100).toFixed(2);
              arr["color"] = 'red';
              arr["icon"] = 'mdi-arrow-down-thick';
              arr["calculatedData"] = calculatedData;
              arr["text"] = '-'
              arr["subIcon"] = 'mdi-emoticon-dead-outline';
              return arr
            }
          }
        }
      },
    },
    filters: {
      truncate: function (text, length, suffix) {
          return text.substring(0, length) + suffix;
      },
    }
  }
</script>

<style scoped>
  .chart-container {
    flex-grow: 1;
    min-height: 0;

    > div {
      position: relative;
      height: 100%;
    }
}
.v-card > *:first-child:not(.v-btn):not(.v-chip), .v-card > .v-card__progress + *:not(.v-btn):not(.v-chip){
  border-top-left-radius: inherit;
  border-top-right-radius: inherit;
}

.v-picker--date {
  margin-top: 0;
  margin-bottom: 0;
}

.page-title {
    margin: 0;
  }
  
.page-title:hover {
  color: #42b883;
  cursor: pointer;
}

.ranking-page-title {
  margin: 0;
}

.ranking-page-path {
  color: #828282;
}

.ranking-page-path:hover {
  color: #42b883;
  cursor: pointer;
}

.v-label {
  backgroundColor: none;
}


.popupbtn {
  float: right;
  margin-right: 20px;
  width: 40px;
  height: 40px;
}
.white{
  background:white;
}
.black{
  background:black;
}

tr:hover {
  background-color: #ff8585;
  transition: 0.7s;
}

.title-url {
  padding-left: 10px;
  padding-right: 10px;
  border: 2px solid #ff4242;
  border-right-width: 0px;
  border-left-width: 0px;
  border-bottom-width: 0px; 
  
}
.ad-index{
  padding: 1em;
  background-color: #ff4242;
  transition: 1s;
  
  position: fixed;
  bottom: 0px;
}

</style>
