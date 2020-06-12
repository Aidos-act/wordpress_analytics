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
            <v-text-field v-model="dateRangeText" label="期間" readonly v-on="on"></v-text-field>
          </template>
          <v-date-picker v-model="dates" range no-title scrollable>
            <v-btn text color="primary" @click="menu = false">キャンセル</v-btn>
            <v-btn text color="primary" @click="getDate(dates)" :disabled="dateError">
              <span @click="$refs.menu.save(dates)">選擇</span>
            </v-btn>
          </v-date-picker>
        </v-menu>
      </v-col>
      <!-- datepicker end -->

      <!-- article title part start -->
      <v-col cols="12" sm="6">
        <v-text-field readonly v-model="checkIfDefault? getDefault('pageTitle') : title" label="記事タイトル"></v-text-field>
      </v-col>
      <!-- article title part end -->

      <v-col cols="3" sm="3">
        <div class="my-2">
          <router-link 
            v-if="checkIfDefault"
            :to="{ path: '/api/v1/articles/:id', name: 'HeatmapPage', params: { id: getDefault('id')[1][1] } }"
          >
            <v-btn color="primary">
              ヒートマップ GO
            </v-btn>
          </router-link>
          <router-link 
            v-else
            :to="{ path: '/api/v1/articles/:id', name: 'HeatmapPage', params: { id: getSelected('id')[1][1] } }"
          >
            <v-btn color="primary">
              ヒートマップ GO
            </v-btn>
          </router-link>
          
        </div>
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
          :columndata="checkIfDefault? getDefault('pageviews') : getSelected('pageviews')"
          :sheetHeight="200"
          chartheight="150px"
          graphType="column"
        >
          <h4 class="card-title font-weight-light mt-2 ml-2">
            PV(ページビュー)
            <v-icon
              class="mr-1"
              small
            >
              mdi-arrow-right-bold
            </v-icon>
            <span>
              {{ checkIfDefault? getDefault('pageviews')[1][1].toLocaleString() : getSelected('pageviews')[1][1].toLocaleString() }}
            </span>
          </h4>

          <p v-if="checkIfDefault" class="d-inline-flex font-weight-light ml-2 mt-1">
            トップ20平均PV 比
            {{ Math.floor((getDefault('pageviews')[1][1]/getDefault('pageviews')[0][1])*100) }}%
            , 
            {{ getDefault('pageviews')[1][1]>getDefault('pageviews')[0][1]? "すごい!" : "頑張れ!" }}
          </p>

          <p v-else class="d-inline-flex font-weight-light ml-2 mt-1">
            トップ20平均PV 比
            {{ Math.floor((getSelected('pageviews')[1][1]/getSelected('pageviews')[0][1])*100) }}%
            ,
            {{ getSelected('pageviews')[1][1]>getSelected('pageviews')[0][1]? "すごい!" : "頑張れ!" }}
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
          :columndata="checkIfDefault? getDefault('clickCount') : getSelected('clickCount')"
          color="success"
          :sheetHeight="200"
          chartheight="150px"
          graphType="column"
        >
          <h4 class="card-title font-weight-light mt-2 ml-2">
            MCV
            <v-icon
              class="mr-1"
              small
            >
              mdi-arrow-right-bold
            </v-icon>
            <span>
              {{ checkIfDefault? getDefault('clickCount')[1][1].toLocaleString() : getSelected('clickCount')[1][1].toLocaleString() }}
            </span>
          </h4>

          <p v-if="checkIfDefault" class="d-inline-flex font-weight-light ml-2 mt-1">
            トップ20平均MCV 比
            {{ Math.floor((getDefault('clickCount')[1][1]/getDefault('clickCount')[0][1])*100) }}%
            ,
            {{ getDefault('clickCount')[1][1]>getDefault('clickCount')[0][1]? "すごい!" : "頑張れ!" }}
          </p>

          <p v-else class="d-inline-flex font-weight-light ml-2 mt-1">
            トップ20平均MCV 比
            {{ Math.floor((getSelected('clickCount')[1][1]/getSelected('clickCount')[0][1])*100) }}%
            ,
            {{ getSelected('clickCount')[1][1]>getSelected('clickCount')[0][1]? "すごい!" : "頑張れ!" }}
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
          :columndata="checkIfDefault? getDefault('avgTimeOnPage') : getSelected('avgTimeOnPage')"
          :sheetHeight="200"
          chartheight="150px"
          graphType="column"
        >
          <h4 class="card-title font-weight-light mt-2 ml-2">
            平均滞在時間
            <v-icon
              class="mr-1"
              small
            >
              mdi-arrow-right-bold
            </v-icon>
            {{ checkIfDefault? getDefault('avgTimeOnPage')[1][1] : getSelected('avgTimeOnPage')[1][1] }}
          </h4>

          <p v-if="checkIfDefault" class="d-inline-flex font-weight-light ml-2 mt-1">
            平均 {{ getDefault('avgTimeOnPage')[0][1] }} &nbsp; 記事 {{ getDefault('avgTimeOnPage')[1][1] }} ,
            {{ getDefault('avgTimeOnPage')[1][1]>getDefault('avgTimeOnPage')[0][1]? "すごい!" : "頑張れ!" }}
          </p>

          <p v-else class="d-inline-flex font-weight-light ml-2 mt-1">
            平均 {{ getSelected('avgTimeOnPage')[0][1] }} &nbsp; 記事 {{ getSelected('avgTimeOnPage')[1][1] }} ,
            {{ getSelected('avgTimeOnPage')[1][1]>getSelected('avgTimeOnPage')[0][1]? "すごい!" : "頑張れ!" }}
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
          :progressdata="checkIfDefault? getDefault('goal') : getSelected('goal')"
          :sheetHeight="200"
          chartheight="150px"
          :chartsize="150"
          graphType="goal"
        >
          <h4 class="card-title font-weight-light mt-2 ml-2">
            ゴール1 : 1分以上ページに滞在
          </h4>

          <p class="d-inline-flex font-weight-light ml-2 mt-1">
            CV率 : {{ checkIfDefault? getDefault('goal')[0] : getSelected('goal')[0] }}% &nbsp; 
            完了数 : {{ checkIfDefault? getDefault('goal')[1] : getSelected('goal')[1] }}
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
          :columndata="checkIfDefault? getDefault('bounces') : getSelected('bounces')"
          :sheetHeight="200"
          chartheight="150px"
          graphType="column"
        >
          <h4 class="card-title font-weight-light mt-2 ml-2">
            直帰率
            <v-icon
              class="mr-1"
              small
            >
              mdi-arrow-right-bold
            </v-icon>
            {{ checkIfDefault? getDefault('bounces')[1][1] : getSelected('bounces')[1][1] }}%
          </h4>

          <p v-if="checkIfDefault" class="d-inline-flex font-weight-light ml-2 mt-1">
            トップ20平均直帰率 比
            {{ Math.floor((getDefault('bounces')[1][1]/getDefault('bounces')[0][1])*100) }}%
            ,
            {{ getDefault('bounces')[1][1]>getDefault('bounces')[0][1]? "頑張れ!" : "すごい!" }}
          </p>

          <p v-else class="d-inline-flex font-weight-light ml-2 mt-1">
            トップ20平均直帰率 比
            {{ Math.floor((getDefault('bounces')[1][1]/getDefault('bounces')[0][1])*100) }}%
            ,
            {{ getDefault('bounces')[1][1]>getDefault('bounces')[0][1]? "頑張れ!" : "すごい!" }}
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
          :sheetHeight="200"
          chartheight="170px"
          :columndata="demographicData"
          graphType="stacked"
        >
          <h4 class="card-title font-weight-light mt-2 ml-2">
            年齢と性別 <span class="red--text">(トータル)</span>
          </h4>

          <p class="d-inline-flex font-weight-light ml-2 mt-1 red--text">
            25% 正確度, 参照用にのみ使用
          </p>
        </material-chart-card>
      </v-col>
      <!-- graph data 6 end -->    
      
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
            <div class="display-2 font-weight-light" style="text-align: start;">
              記事リスト
            </div>

            <v-text-field
              v-model="search"
              append-icon="mdi-magnify"
              label="タイトルやURLご入力ください"
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
                    <p class="page-title" @click="setPathTitle(data.pagePath, data.pageTitle)">{{ data.pageTitle | truncate(30, '...') }}</p>
                    <small class="page-path">{{ data.pagePath | truncate(20, '...') }}</small>
                  </td>
                  <td>{{ parseInt(data.clickCount, 10).toLocaleString() }}</td>
                  <td>{{ parseInt(data.pageviews, 10).toLocaleString() }}</td>
                  <td>{{ parseInt(data.users, 10).toLocaleString() }}</td>
                  <td>{{ setMinute(data.avgTimeOnPage) }}</td>
                  <td>{{ getBounceRate(data.bounces, data.sessions) }}</td>
                  <td>
                    <router-link 
                      v-if = "data.id != 0"
                      :to="{ path: '/api/v1/articles/:id', name: 'HeatmapPage', params: { id: data.id } }"
                    >
                      <v-btn small color="primary">ヒートマップ</v-btn>
                    </router-link>
                  </td>
                  
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
          text: 'タイトル',
          align: 'start',
          sortable: false,
          value: 'pageTitle',
          width: '45%',
        },
        { text: 'MCV', value: 'clickCount' },
        { text: 'PV', value: 'pageviews' },
        { text: 'ユーザー', value: 'users' },
        { text: '滞在時間', value: 'avgTimeOnPage' },
        { text: '直帰率', value: 'bounces' },
        { 
          text: 'heatMap', 
          value: 'heatMap',
          sortable: false
        },
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
        var defaultGAinfo = this.$store.state.gainfos[0];
        var defaultData;

        for(var key in defaultGAinfo){
          if(key == value){
            if(value == 'bounces'){
              var b = parseInt(defaultGAinfo[key], 10);
              var pv = parseInt(defaultGAinfo['pageviews'], 10);
              defaultData = Math.floor((b/pv)*100);
            }else if(value == 'pageTitle'){
              defaultData = defaultGAinfo[key]
              return defaultData
            }else{
              defaultData = parseInt(defaultGAinfo[key], 10);
            }
          }else if(value == 'goal'){
            var cvr = defaultGAinfo['goal1ConversionRate'];
            var comp = defaultGAinfo['goal1Completions'];

            var goalArr = [parseFloat(cvr, 10).toFixed(2), comp];

            return goalArr;
          }
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
          }else if(value == 'goal'){
            var cvr = selectedGainfos['goal1ConversionRate'];
            var comp = selectedGainfos['goal1Completions'];

            var goalArr = [parseFloat(cvr, 10).toFixed(2), comp];

            return goalArr;
          }
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
      getBounceRate(bounces, sessions) {
        var bounceRate = ((bounces/sessions)*100).toFixed(2)
        return bounceRate + "%";
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
