<template>
  <v-container
    id="dashboard"
    fluid
    tag="section"
  >
    <v-row>
      <!-- datepicker start -->
      <!-- please refer to date picker in vuetify. https://vuetifyjs.com/en/components/date-pickers/#date-month-pickers  -->
      <!-- especially Date pickers - In dialog and menu and Date pickers - Range parts -->
      <v-col cols="6" sm="3">
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
            <v-text-field v-model="dateRangeText" label="期間" readonly v-on="on"></v-text-field>
          </template>
          <v-date-picker v-model="dates" range no-title scrollable>
            <v-btn text color="primary" @click="menu = false">キャンセル</v-btn>
            <v-btn text color="primary" @click="getTotalByDate(dates)" :disabled="dateError">
              <span @click="$refs.menu.save(dates)">選擇</span>
            </v-btn> 
          </v-date-picker>
        </v-menu>
      </v-col>
      <!-- datepicker end -->
      
      <!-- dropdown for line chart --> <!-- please refer to v-select in the vuetify -->
      <v-col class="d-flex" cols="6" sm="3">
        <v-container fluid>
          <v-select
            v-model="selectedItem.item"
            item-text="key"
            item-value="item"
            :items="dropdownitems"
            label="セレクト"
            dense
          ></v-select>
        </v-container>
      </v-col>
      
      <!-- dropdown for host name -->
      <v-col class="d-flex" cols="6" sm="3">
        <v-container fluid>
          <v-select
            v-model="selectedHost.item"
            item-text="key"
            item-value="item"
            :items="dropdownHost"
            label="ページグループ"
            @input="getTotalByHost(selectedHost.item)"
            dense
          ></v-select>
        </v-container>
      </v-col>
      
      <!-- line chart start -->
      <v-container class="chart-container">
        <!-- please refer to Chartkick-vue. https://chartkick.com/vue -->
        <line-chart :data="setLineChartData()"></line-chart>
      </v-container>
      <!-- line chart end -->
      <!-- {{totalgainfos}} -->

      <!-- stats card 1 start - pageview -->
      <v-col
        cols="12"
        sm="6"
        lg="3"
      >
        <!-- please refer to dashboard/components/base/MaterialStatsCard.vue -->
        <material-stats-card
          color="info"
          icon="mdi-book-open-page-variant"
          title="PV(ページビュー)"
          :value="setCurrentTotal('pageviews')"
          :sub-data="setCompareTotal('pageviews')"
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
          icon="mdi-baby-face-outline"
          title="ユーザー"
          :value="setCurrentTotal('users')"
          :sub-data="setCompareTotal('users')"
        />
      </v-col>
      <!-- stats card 2 end -->

      <!-- stats card 3 start - mcv -->
      <v-col
        cols="12"
        sm="6"
        lg="3"
      >
        <material-stats-card
          color="success"
          icon="mdi-cursor-default-click-outline"
          title="MCV(クリック数)"
          :value="setCurrentTotal('mcv')"
          :sub-data="setCompareTotal('mcv')"
        />
      </v-col>
      <!-- stats card 3 end -->

      <!-- stats card 4 start - time on page -->
      <v-col
        cols="12"
        sm="6"
        lg="3"
      >
        <material-stats-card
          color="orange"
          icon="mdi-clock-outline"
          title="平均滞在時間"
          :value="setCurrentTotal('avgTimeOnPage')"
          :sub-data="setCompareTotal('avgTimeOnPage')"
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
          icon="mdi-poll"
          title="MCVR"
          :value="setCurrentTotal('mcvr')"
          :sub-data="setCompareTotal('mcvr')"
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
          icon="mdi-chart-line"
          title="MCV/ユーザー"
          :value="setCurrentTotal('mcvPerUv')"
          :sub-data="setCompareTotal('mcvPerUv')"
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
          icon="mdi-chart-pie"
          title="PV/ユーザー"
          :value="setCurrentTotal('pvPerUv')"
          :sub-data="setCompareTotal('pvPerUv')"
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
          icon="mdi-exit-run"
          title="直帰率"
          :value="setCurrentTotal('bounces')"
          :sub-data="setCompareTotal('bounces')"
        />
      </v-col>
      <!-- stats card 8 end -->  

      <!-- progress circular start -->
      <v-col
        cols="12"
        lg="4"
      >
        <!-- please refer to dashboard/components/base/MaterialChartCard.vue -->
        <!-- get the chart according to graphType -->
        <material-chart-card
          :progressdata="setProgressData()"
          color="info"
          :sheetHeight="300"
          :chartsize="250"
          graphType="goal"
        >
          <h4 class="card-title font-weight-light mt-2 ml-2">
            ゴール1 : 1分以上ページに滞在
          </h4>

          <p class="d-inline-flex font-weight-light ml-2 mt-1">
            ゴール1 コンバージョン率 : {{ setProgressData()[0] }}%
            <br>
            ゴール1 完了数 : {{ setProgressData()[1] }}
          </p>

        </material-chart-card>
      </v-col>
      <!-- progress circular end -->

      <!-- mcvr line graph data start -->
      <v-col
        cols="12"
        lg="4"
      >
        <material-chart-card
          :columndata="setColumnChartData()"
          color="success"
          :sheetHeight="300"
          chartheight="250px"
          graphType="column"
        >
          <h4 class="card-title font-weight-light mt-2 ml-2">
              MCV
            </h4>

            <p class="d-inline-flex font-weight-light ml-2 mt-1">
              現在({{dateRangeText}}) : {{ setColumnChartData()[0][1] }} 
              <br>
              比較({{compareRangeText}}) : {{ setColumnChartData()[1][1] }}
            </p>

        </material-chart-card>

      </v-col>
      <!-- mcvr line graph data end -->

      <!-- pie chart data start-->
      <v-col
        cols="12"
        lg="4"
      >
        <material-chart-card
          :piedata="setPieChartData()"
          color="#E91E63"
          :sheetHeight="300"
          chartheight="250px"
          graphType="pie"
        >
          <h4 class="card-title font-weight-light mt-2 ml-2">
            新規 ユーザー VS 再訪問 ユーザー
          </h4>

          <p class="d-inline-flex font-weight-light ml-2 mt-1">
            新規 : {{ setPieChartData()[0][1].toLocaleString() }} 
            (ユーザー比 {{ Math.floor((setPieChartData()[0][1]/totalgainfos[0].users)*100) }}%)
            <br>
            再訪問 : {{ setPieChartData()[1][1].toLocaleString() }} 
            (ユーザー比 {{ Math.floor((setPieChartData()[1][1]/totalgainfos[0].users)*100) }}%)

          </p>

        </material-chart-card>
      </v-col>
      <!-- pie chart data end-->
  
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
          new Date(new Date().setDate(new Date().getDate()-1)).toISOString().substr(0, 10),
          new Date(new Date().setDate(new Date().getDate()-1)).toISOString().substr(0, 10)
        ],
        menu: false,
        dateCheckBool: true,
        piechartData: [],
        selectedItem: { key: "PV(ページビュー)", item: "pageviews"},
        dropdownitems: [
          { key: "PV(ページビュー)", item: "pageviews"},
          { key: "ユーザー", item: "users"},
          { key: "直帰率", item: "bounces"},
          { key: "平均滞在時間", item: "avgTimeOnPage"},
          
        ],
        selectedHost: { key: "トータル", item: "total"},
        dropdownHost: [
          { key: "トータル", item: "total"},
          { key: "navivi.site", item: "navivi.site"},
          { key: "testtest", item: "reportv3.ptengine.jp"},
        ]
      }
    },
    created() {
      // bus.$emit('start:spinner');
      // bus.$emit('end:spinner');
    },
    computed: {
      // check if date select is correct
      dateError () {
        // it needs to be today so set current data as today
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
      compareRangeText(){
        var t1 = this.$moment(this.dates[0]);
        var t2 = this.$moment(this.dates[1]);
        var compareDates = [];

        var diff = 0;
        if(t1._i == t2._i) {
          diff = 1;
        } else {
          diff = t2.diff(t1, 'days')+1;
        }
        compareDates[0] = t1.subtract(diff,'days').format('YYYY-MM-DD')
        compareDates[1] = t2.subtract(diff,'days').format('YYYY-MM-DD')

        return compareDates.join(' ~ ');
      },
      totalgainfos(){
        return this.$store.state.totalgainfos
      },
      getGoalData(){
        return this.$store.state.goalData;
      },
    },
    mounted() {
      // bring whole total data from lib/get_analytics.rb by selected period
      this.$store.commit('getTotalGaInfo',{
        startdate: this.dates[0],
        enddate: this.dates[1],
        hostname: 'total'
      });
    },
    methods: {
      getTotalByDate(dates) {
        this.$store.commit('getTotalGaInfo',{
          startdate: this.dates[0],
          enddate: this.dates[1],
          hostname: 'total'
        });
      },
      getTotalByHost(value){
        this.$store.commit('getTotalGaInfo',{
          startdate: this.dates[0],
          enddate: this.dates[1],
          hostname: value
        });
      },
      // setup data by each metrics such as pageviews, user, and so on.
      setCurrentTotal(value){
        // get total data from lib/get_analytics.rb by selected time period 
        var currentTotal = this.$store.state.totalgainfos[0];

        // it is regex and check if value has 'mcv' in the text. for example, mcvr, mcvPerUv.
        var check = /mcv/;

        var pv;
        var uv;
        
        var data;

        // return data according to value. data is modified by methods if needed.
        for(var key in currentTotal){
          if(value == key){
            if(value == 'avgTimeOnPage'){
              return this.setMinute(currentTotal[key])
            }else if(value == 'bounces'){
              return this.getBounceRate(currentTotal[key], currentTotal['sessions'])
            }else {
              data = currentTotal[key];
              var formattedData = parseInt(data, 10).toLocaleString();
              return formattedData;
            }
          }else if(value == 'pvPerUv'){
            pv = parseInt(currentTotal['pageviews'], 10);
            uv = parseInt(currentTotal['users'], 10);
            
            return (pv/uv).toFixed(2);
          }
        }

        // the value which has text 'mcv' in it need to setup by setMcv method.
        // they are not in the currentTotal[key]
        if(check.test(value)){
          return this.setMcv(currentTotal, value);
        }
      },
      // comparing data between current period and compared period.
      setCompareTotal(value){
        var arr = [];
        
        var calculatedData;

        var compareDates = this.compareRangeText;

        arr["date"] = compareDates;

        var setValueArr = this.setValue(value);
        
        var currentValue = setValueArr[0];
        var compareValue = setValueArr[1];

        // comparing and setup arr data and send it to dashboard/components/base/MaterialStatsCard.vue as subdata
        if(currentValue > compareValue){
          calculatedData = (((currentValue - compareValue)/compareValue)*100).toFixed(2);
          arr["color"] = 'green';
          arr["icon"] = 'mdi-arrow-up-thick';
          arr["calculatedData"] = calculatedData;
          arr["text"] = '+';
          arr["subIcon"] = 'mdi-emoticon-cool-outline';
          
          return arr
        }else{
          calculatedData = (((compareValue - currentValue)/compareValue)*100).toFixed(2);
          arr["color"] = 'red';
          arr["icon"] = 'mdi-arrow-down-thick';
          arr["calculatedData"] = calculatedData;
          arr["text"] = '-'
          arr["subIcon"] = 'mdi-emoticon-dead-outline';
          
          return arr
        }
      },
      // basically similar with setCurrentTotal method but it has 2 values which are current and compare. 
      setValue(value){
        var currentTotal = this.$store.state.totalgainfos[0];
        var compareTotal = this.$store.state.totalgainfos[1];
        var arr = [];
        var current;
        var compare;
        var pv;
        var uv;
        var check = /mcv/;

        for(var key in currentTotal){
          if(value == 'pvPerUv'){
            pv = parseInt(currentTotal['pageviews'], 10);
            uv = parseInt(currentTotal['users'], 10);
            current = ((pv/uv)*100).toFixed(2)
          }else if(check.test(value)){
            current = this.setMcv(currentTotal, value);
          }else if(key == value){
            current = parseInt(currentTotal[key], 10);
          }
        }

        for(var key in compareTotal){
          if(value == 'pvPerUv'){
            pv = parseInt(compareTotal['pageviews'], 10);
            uv = parseInt(compareTotal['users'], 10);
            compare = ((pv/uv)*100).toFixed(2)
          }else if(check.test(value)){
            compare = this.setMcv(compareTotal, value);
          }else if(key == value){
            compare = parseInt(compareTotal[key], 10);
          }
        }

        arr[0] = current;
        arr[1] = compare;

        return arr;
      },
      setMcv(data, value){
        var totalValue = data;
        var pv;
        var uv;

        for(var key in totalValue){
          if(value == 'mcvr'){
            pv = parseInt(totalValue['pageviews'], 10);
            return ((totalValue['mcv']/pv)*100).toFixed(2) + '%';
          }else if(value == 'mcvPerUv'){
            uv = parseInt(totalValue['users'], 10);
            return ((totalValue['mcv']/uv)*100).toFixed(2) + '%';
          }
        }
      },
      // it is for progress bar showing goal acheivement
      setProgressData(){
        var totalValue = this.$store.state.totalgainfos[0];
        var cvr;
        var comp;

        for(var key in totalValue){
          if(key == 'goal1ConversionRate'){
            cvr = totalValue[key];
          }
          if(key == 'goal1Completions'){
            comp = totalValue[key];
          }
        }

        var arr = [parseFloat(cvr, 10).toFixed(2), comp];

        return arr;
      },
      // set the new, returning user data for pie chart. refer to pie chart in the https://chartkick.com/vue
      setPieChartData(){
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
        newUsers = newUsers;



        newUsersArr = ['新規ユーザー', newUsers];
        returningUsersArr = ['再訪問ユーザー', returningUsers];

        this.piechartData[0] = newUsersArr;
        this.piechartData[1] = returningUsersArr;

        return this.piechartData;
      },
      setLineChartData() {
        // set value by selected item which is from dropdown
        var selectedDrop = this.selectedItem.item

        var arr=[];
        var compareset={};
        

        // get total data by daily or hourly from lib/get_analytics/rb. which is the data for current period that user setup with datepicker.
        var dropdwnarr = this.$store.state.totalgainfos[2];
        var dropdwn = {}
        
        // data format is like below
        // { "00:00": { "pageviews": "534", "users": "478", "bounces": "432", "sessions": "480", "avgTimeOnPage": "123.35714285714286", "newUsers": "348", "goal1ConversionRate": "3.958333333333333", "goal1Completions": "19" }, "01:00": {...} ...}
        // key -> hour or date, j -> pageview, users, ... 
        // setup hash with selected item in dropdown menu. key -> hour or date
        for(var key in dropdwnarr){
          for(var j in dropdwnarr[key]){
            if(j == selectedDrop){
              dropdwn[key] = dropdwnarr[key][j]
            }
          }
        }

        // get total data by daily or hourly from lib/get_analytics/rb. which is the data for compare period.
        var comparedropdwnarr = this.$store.state.totalgainfos[3];
        var comparedata = {}
        // setup hash with selected item in dropdown menu. key -> hour or date
        for(var key in comparedropdwnarr){
          for(var j in comparedropdwnarr[key]){
            if(j == selectedDrop){
              comparedata[key] = comparedropdwnarr[key][j]
            }
          }
        }

        // this part is for making compare part's key same with current key so that showing up stacked data on the line chart
        var compareValueArr = Object.values(comparedata);
        
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


        // setup compare dates
        var compareDates = this.compareRangeText;



        // formatting data according to chart kick line chart. https://chartkick.com/vue

        var dropdwndata = {
          name: this.dates.join(' ~ '),
          color: '#2962ff',
          data: dropdwn
        };
        
        var setcompare = {
          name: compareDates,
          color: '#E91E63',
          data: compareset
        } 

        arr[0] = dropdwndata;
        arr[1] = setcompare;

        return arr
      },
      // it is colum chart for mcv
      setColumnChartData(){
        var columnchartArr=[];

        var currentTotal = this.$store.state.totalgainfos[0];
        var current;
        for(var key in currentTotal){
          if(key == 'mcv') {
            current = currentTotal[key];
          }
        }

        var compareTotal = this.$store.state.totalgainfos[1];
        var compare;
        for(var key in compareTotal){
          if(key == 'mcv') {
            compare = compareTotal[key];
          }
        }
        
        
        var first = ['現在', current];
        var second = ['比較', compare];
        // var dates = [currentDate, compareDate];

        columnchartArr[0] = first;
        columnchartArr[1] = second;
        

        return columnchartArr;
      },
      // set avgTimeonPage as HMS time format
      setMinute(avgTimeOnPage){
        var m = Math.floor(avgTimeOnPage/60);
        var h = Math.floor(avgTimeOnPage/3600);

        var s = Math.floor(avgTimeOnPage - (m*60));

        h = (h < 10) ? "0" + h : h;
        m = (m < 10) ? "0" + m : m;
        s = (s < 10) ? "0" + s : s;

        return h + ":" + m + ":" + s;
      },
      getBounceRate(bounces, sessions) {
        var bounceRate = ((bounces/sessions)*100).toFixed(2)
        return bounceRate + "%";
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

.v-application .text-start {
    text-align: center;
  }

</style>
