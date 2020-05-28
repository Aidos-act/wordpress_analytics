<template>
  <v-container
    id="articleDashboard"
    fluid
    tag="section"
  >
    <v-row no-gutters>
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
      <v-col>
        <v-text-field v-model="checkIfDefault? setDefaultTitle() : title" label="Article Title"></v-text-field>
      </v-col>
      
    </v-row>
    
    <v-row>
      <!-- graph data 1 start -->
      <v-col
        cols="12"
        lg="4"
      >
        <material-chart-card
          color="success"
          type="Line"
          :columndata="checkIfDefault? getDefault('pageviews') : getSelected('pageviews')"
          :sheetHeight="200"
          chartheight="150px"
          graphType="column"
        >
          <h4 class="card-title font-weight-light mt-2 ml-2">
            Page View
            <v-icon
              class="mr-1"
              small
            >
              mdi-arrow-right-bold
            </v-icon>
            <span>
              {{ checkIfDefault? getDefault('pageviews')[1][1] : getSelected('pageviews')[1][1] }}
            </span>
          </h4>

          <p v-if="checkIfDefault" class="d-inline-flex font-weight-light ml-2 mt-1">
            {{ Math.floor((getDefault('pageviews')[1][1]/getDefault('pageviews')[0][1])*100) }}
            % of top20 article PV Avg,
            {{ getDefault('pageviews')[1][1]>getDefault('pageviews')[0][1]? "Good!" : "Cheer Up!" }}
          </p>

          <p v-else class="d-inline-flex font-weight-light ml-2 mt-1">
            {{ Math.floor((getSelected('pageviews')[1][1]/getSelected('pageviews')[0][1])*100) }}
            % of top20 article PV Avg,
            {{ getSelected('pageviews')[1][1]>getSelected('pageviews')[0][1]? "Good!" : "Cheer Up!" }}
          </p>

        </material-chart-card>
      </v-col>
      <!-- graph data 1 end -->

      <!-- graph data 2 start -->
      <v-col
        cols="12"
        lg="4"
      >
        <material-chart-card
          :mcvdata="checkIfDefault? getDefaultMcv() : getSelectedMcv()"
          color="success"
          type="Line"
          :sheetHeight="200"
          chartheight="150px"
          graphType="linel"
        >
          <h4 class="card-title font-weight-light mt-2 ml-2">
            MCVR
          </h4>

          <p class="d-inline-flex font-weight-light ml-2 mt-1">
            90% of article average, cheer up!
          </p>

        </material-chart-card>
      </v-col>
      <!-- graph data 2 end -->

      <!-- graph data 3 start -->
      <v-col
        cols="12"
        lg="4"
      >
        <material-chart-card
          color="success"
          type="Line"
          :columndata="checkIfDefault? getDefault('avgTimeOnPage') : getSelected('avgTimeOnPage')"
          :sheetHeight="200"
          chartheight="150px"
          graphType="column"
        >
          <h4 class="card-title font-weight-light mt-2 ml-2">
            Time On Page
            <v-icon
              class="mr-1"
              small
            >
              mdi-arrow-right-bold
            </v-icon>
            {{ checkIfDefault? getDefault('avgTimeOnPage')[1][1] : getSelected('avgTimeOnPage')[1][1] }}
          </h4>

          <p v-if="checkIfDefault" class="d-inline-flex font-weight-light ml-2 mt-1">
            AVG {{ getDefault('avgTimeOnPage')[0][1] }} &nbsp; Article {{ getDefault('avgTimeOnPage')[1][1] }} ,
            {{ getDefault('avgTimeOnPage')[1][1]>getDefault('avgTimeOnPage')[0][1]? "Good!" : "Cheer Up!" }}
          </p>

          <p v-else class="d-inline-flex font-weight-light ml-2 mt-1">
            AVG {{ getSelected('avgTimeOnPage')[0][1] }} &nbsp; Article {{ getSelected('avgTimeOnPage')[1][1] }} ,
            {{ getSelected('avgTimeOnPage')[1][1]>getSelected('avgTimeOnPage')[0][1]? "Good!" : "Cheer Up!" }}
          </p>
        </material-chart-card>
      </v-col>
      <!-- graph data 3 end -->       

      <!-- graph data 4 start -->
      <v-col
        cols="12"
        lg="4"
      >
        <material-chart-card
          color="success"
          type="Line"
          :sheetHeight="200"
          chartheight="150px"
          :chartsize="150"
          graphType="goal"
        >
          <h4 class="card-title font-weight-light mt-2 ml-2">
            Goal Achievement
          </h4>

          <p class="d-inline-flex font-weight-light ml-2 mt-1">
            Still has 40%, Cheer Up!
          </p>

        </material-chart-card>
      </v-col>
      <!-- graph data 4 end -->

      <!-- graph data 5 start -->
      <v-col
        cols="12"
        lg="4"
      >
        <material-chart-card
          color="success"
          type="Line"
          :columndata="checkIfDefault? getDefault('bounces') : getSelected('bounces')"
          :sheetHeight="200"
          chartheight="150px"
          graphType="column"
        >
          <h4 class="card-title font-weight-light mt-2 ml-2">
            Bounce Rate
            <v-icon
              class="mr-1"
              small
            >
              mdi-arrow-right-bold
            </v-icon>
            {{ checkIfDefault? getDefault('bounces')[1][1] : getSelected('bounces')[1][1] }}%
          </h4>

          <p v-if="checkIfDefault" class="d-inline-flex font-weight-light ml-2 mt-1">
            {{ Math.floor((getDefault('bounces')[1][1]/getDefault('bounces')[0][1])*100) }}
            % of top20 article Bounce Avg,
            {{ getDefault('bounces')[1][1]>getDefault('bounces')[0][1]? "Cheer Up!" : "Good!" }}
          </p>

          <p v-else class="d-inline-flex font-weight-light ml-2 mt-1">
            {{ Math.floor((getDefault('bounces')[1][1]/getDefault('bounces')[0][1])*100) }}
            % of top20 article Bounce Avg,
            {{ getDefault('bounces')[1][1]>getDefault('bounces')[0][1]? "Cheer Up!" : "Good!" }}
          </p>

        </material-chart-card>
      </v-col>
      <!-- graph data 5 end -->

      <!-- graph data 6 start -->
      <v-col
        cols="12"
        lg="4"
      >
        <material-chart-card
          color="success"
          type="Line"
          :sheetHeight="200"
          chartheight="170px"
          :columndata="demographicData"
          graphType="stacked"
        >
          <h4 class="card-title font-weight-light mt-2 ml-2">
            Age and Gender <span class="red--text">(Total)</span>
          </h4>

          <p class="d-inline-flex font-weight-light ml-2 mt-1 red--text">
            25% of accuracy, Use for reference only
          </p>
        </material-chart-card>
      </v-col>
      <!-- graph data 6 end -->    

      <!-- {{ gainfos }} -->

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
              label="Search by Title or URL"
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
                    <p class="page-title" @click="setPathTitle(data.pagePath, data.pageTitle)">{{ data.pageTitle | truncate(35, '...') }}</p>
                    <small class="page-path">{{ data.pagePath }}</small>
                  </td>
                  <td>{{ data.pageviews }}</td>
                  <td>{{ data.users }}</td>
                  <td>{{ data.avgTimeOnPage }}</td>
                  <td>{{ data.bounces }}</td>
                  <td>{{ data.timeOnPage }}</td>
                  <td v-show="false">{{ data.pagePath }}</td>
                </tr>
              </tbody>
            </template>
          </v-data-table>
        </material-card>
      </v-col>
      <!-- article list part end -->
      
    </v-row>
  </v-container>
</template>

<script>
  import MaterialCard from './components/base/MaterialCard.vue'
  import MaterialChartCard from './components/base/MaterialChartCard.vue'
  import MaterialStatsCard from './components/base/MaterialStatsCard.vue'

  export default {
    name: 'ArticleDashboard',
    components: {
      // LineChart,
      MaterialCard,
      MaterialChartCard,
      MaterialStatsCard
    },
    data: () => ({
      dates: [
        new Date(new Date().setDate(new Date().getDate()-1)).toISOString().substr(0, 10),
        new Date(new Date().setDate(new Date().getDate()-1)).toISOString().substr(0, 10)
      ],
      search: '',
      menu: false,
      title: '',
      dateCheckBool: true,
      checkIfDefault: true,
      defaultPath: '',
      selectedPath: '',
      articleId: '',
      columnchartData: [],
      headers: [
        {
          text: 'Title',
          align: 'start',
          sortable: false,
          value: 'pageTitle',
          width: '50%',
        },
        { text: 'PV', value: 'pageviews' },
        { text: 'UV', value: 'users' },
        { text: 'duration', value: 'avgTimeOnPage' },
        { text: 'bounce', value: 'bounces' },
        { text: 'entrance', value: 'users' },
        { value: 'pagePath' }
      ],  
    }),
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
      articles() {
        return this.$store.state.articles
      },
      gainfos() {
        return this.$store.state.gainfos
      },
      demographicData() {
        return this.$store.state.demographicData
      },
      articleData() {
        return this.$store.state.articleData
      },
      temp(){
        console.log('just temp')
        if(this.articleId != ''){
          this.$store.commit('fetchClicks',{
            startdate: this.dates[0],
            enddate: this.dates[1],
            articleId: this.articleId
          });
        }
      }
    },
    mounted() {
      this.$store.commit('getGaInfo',{
          startdate: this.dates[0],
          enddate: this.dates[1]
      });
      this.$store.commit('getDemographic',{
          startdate: this.dates[0],
          enddate: this.dates[1]
      });
      this.$store.commit('fetchArticles');
    },
    methods: {
      getDate(dates) {
        console.log("please")
        this.$store.commit('getGaInfo',{
          startdate: this.dates[0],
          enddate: this.dates[1]
        });
      },
      getDefault(value){
        var columnchartArr=[];
        var defaultGAinfo = this.$store.state.gainfos[10];
        var defaultData;
        for(var key in defaultGAinfo){
          if(key == value){
            if(value == 'bounces'){
              var b = parseInt(defaultGAinfo[key], 10);
              var pv = parseInt(defaultGAinfo['pageviews'], 10);
              defaultData = Math.floor((b/pv)*100);
            }else{
              defaultData = parseInt(defaultGAinfo[key], 10);
            }
          }
          var tt = defaultGAinfo['pageTitle'];
          // this.title = defaultGAinfo['pageTitle'];
        }
        var avg = this.getAvg(value);

        if(value == 'avgTimeOnPage'){
          var a = this.setMinute(avg);
          var b = this.setMinute(defaultData);

          avg = this.$moment(a, "HH:mm:ss").format("mm:ss");
          defaultData = this.$moment(b, "HH:mm:ss").format("mm:ss");
        }

        var first = ['Avg', avg];
        var second = ['Article', defaultData];

        columnchartArr[0] = first;
        columnchartArr[1] = second;

        return columnchartArr;
      },
      getDefaultMcv(){
        var defaultPath = this.$store.state.gainfos[10].pagePath;
        var path = 'https://navivi.site' + defaultPath;
        var articles = this.$store.state.articles;

        for(var i=0; i<articles.length; i++){
          if(path == articles[i].url){
            var clickArr = articles[i].click
          }
        }

        var formattedStartDate = Date.parse(this.dates[0]);
        var formattedEndDate = Date.parse(this.dates[1]);
        var count=0;

        for(var i=0; i<clickArr.length; i++){
          var clicktime =  new Date(clickArr[i].created_at).toISOString().substr(0, 10);
          var formattedClicktime = Date.parse(clicktime);
          
          if(formattedClicktime >= formattedStartDate && formattedClicktime <= formattedEndDate){
            count++;
          }
        }
        
        return count;

      },
      setDefaultTitle(){
        var defaultGAinfo = this.$store.state.gainfos[10];
        var title;
        for(var key in defaultGAinfo){
          title = defaultGAinfo['pageTitle']
        }

        return title;
      },
      getSelected(value) {
        var columnchartArr=[];
        var gainfos = this.$store.state.gainfos;
        var selectedGainfos;
        var selectedData;
        
        for(var key in gainfos){
          if(this.selectedPath == gainfos[key].pagePath){
            selectedGainfos = gainfos[key];
          }
        }

        for(var key in selectedGainfos){
          if(key == value){
            if(value == 'bounces'){
              var b = parseInt(selectedGainfos[key], 10);
              var pv = parseInt(selectedGainfos['pageviews'], 10);
              selectedData = Math.floor((b/pv)*100);
            }else{
              selectedData = parseInt(selectedGainfos[key], 10);
            }
          }
          // this.title = selectedGainfos['pageTitle'];
        }
        var avg = this.getAvg(value);

        if(value == 'avgTimeOnPage'){
          var a = this.setMinute(avg);
          var b = this.setMinute(selectedData);

          avg = this.$moment(a, "HH:mm:ss").format("mm:ss");
          selectedData = this.$moment(b, "HH:mm:ss").format("mm:ss");
        }

        var first = ['Avg', avg];
        var second = ['Article', selectedData];

        columnchartArr[0] = first;
        columnchartArr[1] = second;

        return columnchartArr;
      },
      getSelectedMcv(){
        var gainfos = this.$store.state.gainfos;
        var articles = this.$store.state.articles;
        var selectedPath;
        var selectedMcv;
        
        for(var key in gainfos){
          if(this.selectedPath == gainfos[key].pagePath){
            selectedPath = gainfos[key].pagePath;
          }
        }

        var path = 'https://navivi.site' + selectedPath;

        for(var i=0; i<articles.length; i++){
          if(path == articles[i].url){
            selectedMcv = articles[i].click.length;
          }
        }

        return selectedMcv;
      },
      getAvg(value){
        var a = this.$store.state.gainfos;
        var arr=[];
        var length = 20;
        var i;
        var average;

        for(i=0; i<length; i++){
          if(value == 'pageviews'){
            arr[i] = parseInt(a[i].pageviews, 10);
          }else if(value == 'avgTimeOnPage'){
            arr[i] = parseInt(a[i].avgTimeOnPage, 10);
          }else if(value == 'bounces'){
            var b = parseInt(a[i].bounces, 10);
            var pv = parseInt(a[i].pageviews, 10);
            arr[i] = (b/pv)*100;
          }
        }
        
        var sum = arr.reduce((a, b) => a + b, 0);

        average = Math.floor(sum/length);

        return average;        
      },
      setMinute(avgTimeOnPage){
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
      setPathTitle(path, title){
        this.selectedPath = path;
        this.title = title;
        this.checkIfDefault = false;
        window.scrollTo(0,0);
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
