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
            :items="dropdownitems"
            label="Select"
            dense
            @input="getDropDwn"
          ></v-select>
        </v-container>
      </v-col>
      
      <!-- line chart start -->
      <v-container class="chart-container">
        <line-chart :data="setLineChartData()"></line-chart>
      </v-container>
      <!-- line chart end -->


      <!-- dropdown graph end -->


      <!-- card data start -->
      <template v-for="data in totalgainfos">

        <!-- stats card 1 start - pageview -->
        <v-col
          cols="12"
          sm="6"
          lg="3"
        >
          <material-stats-card
            color="info"
            icon="mdi-baby-face-outline"
            title="Page views (PV)"
            :value="data.pageviews"
            :sub-data="compareCheck(data.pageviews, 'pageviews')"
          />
        </v-col>
        <!-- stats card 1 end -->

        <!-- stats card 2 start - user -->
        <v-col
          cols="12"
          sm="6"
          lg="3"
        >
          <material-stats-card
            color="#fcba03"
            icon="mdi-poll"
            title="User"
            :value="data.users"
            :sub-data="compareCheck(data.users, 'users')"
          />
        </v-col>
        <!-- stats card 2 end -->

        <!-- stats card 3 start - time on page -->
        <v-col
          cols="12"
          sm="6"
          lg="3"
        >
          <material-stats-card
            color="success"
            icon="mdi-store"
            title="Avg.Time on Page"
            :value="setMinute(data.avgTimeOnPage)"
            :sub-data="compareCheck(data.avgTimeOnPage, 'avgTimeOnPage')"
          />
        </v-col>
        <!-- stats card 3 end -->

        <!-- stats card 4 start - mcv -->
        <v-col
          cols="12"
          sm="6"
          lg="3"
        >
          <material-stats-card
            color="orange"
            icon="mdi-sofa"
            title="MCV temporary"
            :value="setMcv('mcv')"
            :sub-data="compareCheck(data.bounces, 'bounces')"
          />
        </v-col>
        <!-- stats card 4 end -->

        <!-- stats card 5 start - mcvr -->
        <v-col
          cols="12"
          sm="6"
          lg="3"
        >
          <material-stats-card
            color="info"
            icon="mdi-duck"
            title="mcvr temporary"
            :value="setMcv('mcvr')"
            :sub-data="compareCheck(data.pageviews, 'pageviews')"
          />
        </v-col>
        <!-- stats card 5 end -->

        <!-- stats card 6 start - mcv/uv -->
        <v-col
          cols="12"
          sm="6"
          lg="3"
        >
          <material-stats-card
            color="#fcba03"
            icon="mdi-poll"
            title="mcv/uv temporary"
            :value="setMcv('mcvPerUv')"
            :sub-data="compareCheck(data.pageviews, 'pageviews')"
          />
        </v-col>
        <!-- stats card 6 end -->

        <!-- stats card 7 start - pv/uv -->
        <v-col
          cols="12"
          sm="6"
          lg="3"
        >
          <material-stats-card
            color="success"
            icon="mdi-store"
            title="PV/UV temporary"
            :value="setMcv('pvPerUv')"
            :sub-data="compareCheck(data.pageviews, 'pageviews')"
          />
        </v-col>
        <!-- stats card 7 end -->

        <!-- stats card 8 start - bounce rate -->
        <v-col
          cols="12"
          sm="6"
          lg="3"
        >
          <material-stats-card
            color="orange"
            icon="mdi-sofa"
            title="%Bounce"
            :value="getBounceRate(data.bounces, data.sessions)"
            :sub-data="compareCheck(data.bounces, 'bounces')"
          />
        </v-col>
        <!-- stats card 8 end -->  

      </template>
      <!-- card data end -->

      <!-- progress circular start -->
      <v-col
        cols="12"
        lg="4"
      >
        <material-chart-card
          color="info"
          type="Bar"
          :sheetHeight="300"
          :chartsize="250"
          graphType="goal"
        >
          <h4 class="card-title font-weight-light mt-2 ml-2">
            MCV Goal Achievement Rate {{ getGoalData }}
          </h4>

          <p class="d-inline-flex font-weight-light ml-2 mt-1">
            cheer up!
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
      <!-- progress circular end -->

      <!-- mcvr line graph data start -->
      <v-col
        cols="12"
        lg="4"
      >
        <material-chart-card
          :mcvdata="setMcv('mcvr')"
          color="success"
          type="Line"
          :sheetHeight="300"
          chartheight="250px"
          graphType="linel"
        >
          <!-- <v-col class="display-3" cols="6">
            23&deg;C
          </v-col> -->
          <h4 class="card-title font-weight-light mt-2 ml-2">
            MCVR
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
      <!-- mcvr line graph data end -->

      <!-- pie chart data start-->
      <v-col
        cols="12"
        lg="4"
      >
        <material-chart-card
          :piedata="getPieChartData()"
          color="#E91E63"
          type="Pie"
          :sheetHeight="300"
          chartheight="250px"
          graphType="pie"
        >
          <h4 class="card-title font-weight-light mt-2 ml-2">
            New User VS Returning User
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
      <!-- pie chart data end-->


      {{ setMcv() }}

      <!-- ranking list start -->
      <v-col
        cols="12"
        md="12"
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
              :sort-desc="[false, true]"
              multi-sort
            > 
              <template v-slot:body="{ items }">
                <tbody>
                  <tr v-for="(data, index) in items">
                    <td>{{ index+1 }}</td>
                    <td class="page-title-wrapper">
                      <p class="ranking-page-title">{{ data.pageTitle | truncate(45, '...') }}</p>
                      <small class="ranking-page-path">{{ data.pagePath }}</small>
                    </td>
                    <td>{{ data.pageviews }}</td>
                    <td>{{ data.pageviews }}</td>
                    <td>{{ data.pageviews }}</td>
                  </tr>
                </tbody>
              </template>
            </v-data-table>
          </v-card-text>
        </material-card>
      </v-col>
      <!-- ranking list end -->

    </v-row>
  </v-container>
</template>

<script>
  // import LineChart from './components/lineChart.js'
  import MaterialCard from './components/base/MaterialCard.vue'
  import MaterialChartCard from './components/base/MaterialChartCard.vue'
  import MaterialStatsCard from './components/base/MaterialStatsCard.vue'
  import bus from './utils/bus.js'

  export default {
    name: 'Dashboard',
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
        isActive: true,
        compareDates: [],
        piechartData: [],
        linechartData: [],
        selectedValue: '',
        testdata: [
          {
            name: "Male",
            data: [["18-24", 24], ["25-34", 22], ["35-44", 19], ["45-54", 30], ["55-64", 11]],
            stack: "stack 1" 
          },
          {
            name: "Female", 
            data: [["18-24", 32], ["25-34", 14], ["35-44", 17], ["45-54", 12], ["55-64", 10]],
            stack: "stack 2"
          }
        ],
        selectedItem: { key: "pageView", item: "ga:pageviews"},
        dropdownitems: [
          { key: "pageView", item: "ga:pageviews"},
          { key: "User", item: "ga:users"},
          { key: "bounce rate", item: "ga:bounces"},
          { key: "avgTimeOnPage", item: "ga:avgTimeOnPage"},
          
        ],
        datacollection: null,
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
          { text: 'MCV', value: 'mcv' },
          { text: '滞留時間', value: 'time on page' }
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
    created() {
      // bus.$emit('start:spinner');
      // bus.$emit('end:spinner');
    },
    computed: {
      dateError () {
        var currentdate =  new Date().toISOString().substr(0, 10);
        if(currentdate < this.dates[0] || currentdate < this.dates[1] || this.dates.length < 2) {
          
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
      clickcount() {
        return this.$store.state.clickcount
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
      compareDropInfos(){
        return this.$store.state.compareDropInfos
      },
      rankingInfos() {
        console.log(typeof this.$store.state.rankingInfos)
        return this.$store.state.rankingInfos
      },
      getGoalData() {
        return this.$store.state.goalData;
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
      this.$store.commit('getDropDown',{
        startdate: this.dates[0],
        enddate: this.dates[1],
        selectedDrop: this.selectedItem.item
      });
      this.$store.commit('getCompareDropDown',{
        startdate: this.compareDates[0],
        enddate: this.compareDates[1],
        selectedDrop: this.selectedItem.item
      });
      this.$store.commit('getRanking',{
        startdate: this.dates[0],
        enddate: this.dates[1]
      });
      this.$store.commit('fetchClicks',{
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
        this.$store.commit('getCompareDropDown',{
          startdate: this.compareDates[0],
          enddate: this.compareDates[1],
          selectedDrop: this.selectedItem.item
        });
        this.$store.commit('getRanking',{
          startdate: this.dates[0],
          enddate: this.dates[1]
        });
      },
      getDropDwn(value){
        this.selectedValue = value;
        this.$store.commit('getDropDown',{
          startdate: this.dates[0],
          enddate: this.dates[1],
          selectedDrop: value
        })
        this.$store.commit('getCompareDropDown',{
          startdate: this.compareDates[0],
          enddate: this.compareDates[1],
          selectedDrop: value
        })
      },
      setMcv(value){
        var clickData = this.$store.state.clickcount.length;
        var totalValue = this.$store.state.totalgainfos[0];
        var pv;
        var uv;

        if(value == 'mcv'){
          return clickData;
        }

        for(var key in totalValue){
          if(value == 'mcvr'){
            pv = parseInt(totalValue['pageviews'], 10);
            return ((clickData/pv)*100).toFixed(2) + '%';
          }else if(value == 'mcvPerUv'){
            uv = parseInt(totalValue['users'], 10);
            return ((clickData/uv)*100).toFixed(2) + '%';
          }else if(value == 'pvPerUv'){
            pv = parseInt(totalValue['pageviews'], 10);
            uv = parseInt(totalValue['users'], 10);
            return ((pv/uv)*100).toFixed(2) + '%';
          }
        }
      },
      compareCheck(value, text){
        var compareValue = this.$store.state.compareGaInfos[0];
        var arr = [];
        var value_num = parseInt(value, 10);
        var compare_num;
        var calculatedData;

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
      getPieChartData(){
        var totalValue = this.$store.state.totalgainfos[0];
        var arr = [];
        var newUsersArr = [];
        var returningUsersArr = [];
        var users;
        var newUsers;
        var returningUsers;
        
        for(var key in totalValue){
          if(key == 'users') {
            users = parseInt(totalValue[key], 10);
          }
          if(key == 'newUsers') {
            newUsers = parseInt(totalValue[key], 10);
          }
        };

        returningUsers = users - newUsers;

        newUsersArr = ['NewUser', newUsers];
        returningUsersArr = ['ReturningUser', returningUsers]

        
        var test1=['test1', 10];
        var test2=['test2', 20];
        

        this.piechartData[0] = newUsersArr;
        this.piechartData[1] = returningUsersArr;


        // this.piechartData.push(newUsersArr);
        // this.piechartData.push(returningUsersArr);

        // console.log(this.piechartData);
        return this.piechartData;

      },
      setLineChartData() {
        var arr=[];
        var compareset={};
        var dropdwn = this.$store.state.dropdwninfos;
        var comparedata = this.$store.state.compareDropInfos;
        var compareValueArr = Object.values(this.$store.state.compareDropInfos);
        var i = 0;

        for(var key in dropdwn) {
          if(this.dates[0] == this.dates[1]){
            for(var j in comparedata) {
              if(j == key){
                compareset[j] = comparedata[j]
              }
            }
          } else {
            compareset[key] = compareValueArr[i]
            i++;
          }
        }

        var dropdwndata = {
          name: this.dates.join(' ~ '),
          color: '#2962ff',
          data: dropdwn
        };
        
        var setcompare = {
          name: this.compareDates.join(' ~ '),
          color: '#E91E63',
          data: compareset
        } 
        
        // console.log(setcompare['data'])
        // console.log(setdatatest['data'])

        arr[0] = dropdwndata;
        arr[1] = setcompare;

        return arr
      },
      setMinute(avgTimeOnPage){
        console.log(avgTimeOnPage);
        var m = Math.floor(avgTimeOnPage/60);
        var h = Math.floor(avgTimeOnPage/3600);

        var s = Math.floor(avgTimeOnPage - (m*60));

        var seconds = Math.floor((avgTimeOnPage / 1000) % 60),
          minutes = Math.floor((avgTimeOnPage / (1000 * 60)) % 60),
          hours = Math.floor((avgTimeOnPage / (1000 * 60 * 60)) % 24);

        h = (h < 10) ? "0" + h : h;
        m = (m < 10) ? "0" + m : m;
        s = (s < 10) ? "0" + s : s;

        return h + ":" + m + ":" + s;
      },
      getBounceRate(bounce, session) {
        var bounceRate = ((bounce/session)*100).toFixed(2)
        return bounceRate + "%";
      }
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
