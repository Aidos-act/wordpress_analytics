<template>
  <div class="heat-body-set">
      <div class="iframe-set">
        <div v-slimscroll="options">
          <div class="iframe-parent">
            <div class="scroll-percent" ref="readLine">
              <div v-if="!loading" class="read-line" v-for="e in scrollpercent.length" :style="{top: getHeight(e) + 'px'}">
                <div class="lines" :style="'margin-top: ' + getMarginTop() + 'px'"> 
                    <p class="lines-p"> {{ scrollpercent[e-1] }}% </p>
                </div>
              </div>
            </div>
            <div class="heat-map" v-bind:style="{ height: maxheight + 'px' }">
              <div v-for="e in scrolld">
                <div class="heat-map-line" v-bind:style="{ top: e.scroll_position + '%' }"> 
                  <!-- <h1 class="heat-color" v-bind:style="{background: linear-gradient(transparent, hsl((100 - (e.sum_dur/max_dur)*100), 100%, 60%, 1), transparent)}"></h1> -->
                  <h1 class="heat-color" :style="'background: linear-gradient(transparent, hsl('+gethsl(e.sum_dur, max_dur)+',100%,60%,1), transparent)'"></h1>
                </div>
              </div>
            </div>
            <iframe :src="getDomain()" SameSite=None frameborder="0" allowfullscreen width="100%" :height="maxheight+600"></iframe> 
            <v-progress-circular
              v-if="loading"
              class="spinner"
              indeterminate
              color="green"
              :size="300"
              :width="25"
            ></v-progress-circular>
          </div>
        </div> 
      </div>

      <div class="values-set">
        <!-- datepicker start -->
        <!-- please refer to date picker in vuetify. https://vuetifyjs.com/en/components/date-pickers/#date-month-pickers  -->
        <!-- especially Date pickers - In dialog and menu and Date pickers - Range parts -->

        <v-col cols="12" sm="6">
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

        <h3> <strong> {{ article.article_title }} </strong> </h3>
        <a :href="getDomain()"><p style="overflow-wrap: normal; font-size: 10px;"> <small> {{ article.article_title }}></small> </p></a>
        
        <v-simple-table>
          <template v-slot:default>
            <tbody>
              
              <tr>
                <td>MCV(クリック数)</td>
                <td>{{ countclick }}</td>
              </tr>
              <tr v-for="(data, key) in getArticleData()">
                <td>{{ key }}</td>
                <td>{{data}}</td>
              </tr>
            </tbody>
          </template>
        </v-simple-table>

        <br>
        <hr>
        <br>

        <h3> <strong> クリック </strong> </h3>
        <table>
          <tbody class="btns">
            <ul v-for="e in countbtnurl">
              <li v-if="e.button_url != null" class="clicks-list">
                <img class="btn-img" :src="e.button_url" style="width: 100px;"> 
                <span class="btn-dis">{{ e.url_count }}</span>
              </li>
            </ul>

            <!-- <ul v-for="ec in countbtntext">
              <li v-if="ec.size != 0" class="clicks-list">
                hoon
                <span class="btn-info">{{ ec.button_text }}</span>
                <span class="btn-dis">{{ec.text_count}}</span>
              </li>
            </ul> -->
            <ul v-for="ec in countbtntext">
              <li v-if="ec.button_text != null" class="clicks-list">
                <span class="btn-info">{{ ec.button_text }}</span>
                <span class="btn-dis-txt">{{ec.text_count}}</span>
              </li>
            </ul>

            
            <!-- <div class="click-item" v-for="e in countbtnurl" >
                <td v-if="e.button_url != 'undefined'" class="clicks-list"> <img class="btn-img" :src="e.button_url" style="width: 100px;"> <p class="btn-dis">{{ e.url_count }}</p></td>
            </div> -->
            <!-- <div class="click-item" v-for="e in countbtntext">
                <td v-if="e.button_text != 'undefined'" class="clicks-list"> <p class="btn-info" >{{ e.button_text }}</p>  <p class="btn-dis"> {{e.text_count}}</p> </td> 
            </div> -->
          </tbody>
        </table>


        <br>
        <hr>
        <br>
        
        <h3> <strong> リスト </strong> </h3>
        
        <material-card
          color="warning"
          class="px-5 py-3"
        >
           <template v-slot:heading>
            <div class="display-2 font-weight-light">
              記事リスト
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
              :items="articleData"
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
                    <!-- <td class="page-title-wrapper" @click="updateArticle(data.id)"> -->
                    <td class="page-title-wrapper" @click="updateArticle(data.id)">  
                      <p class="page-title">{{ data.article_title | truncate(50, '...') }}</p>
                      <small class="page-path">{{ data.article_url | truncate(50, '...') }}</small>
                    </td>
                  </tr>
                </tbody>
              </template>
            </v-data-table>
          </material-card>

      </div>
      <!-- <div class="lists-set">
        <div>hoon</div>
      </div> -->
  </div>
<!--   <div class="lists-set">
        <div>hoon</div>
      </div> -->
<!-- <dashboard-core-footer /> -->
</template>

<script type="text/javascript">
  import axios from 'axios';
  import MaterialCard from '../dashboard/components/base/MaterialCard.vue'
  import MaterialChartCard from '../dashboard/components/base/MaterialChartCard.vue'
  import MaterialStatsCard from '../dashboard/components/base/MaterialStatsCard.vue'
  export default {
    components: {
      // LineChart,
      MaterialCard,
      MaterialChartCard,
      MaterialStatsCard,
      // DashboardCoreFooter: () => import('../dashboard/components/core/Footer'),
    },
    data: function () {
      return {
        dates: [
          new Date(new Date().setDate(new Date().getDate()-1)).toISOString().substr(0, 10),
          new Date(new Date().setDate(new Date().getDate()-1)).toISOString().substr(0, 10)
        ],
        menu: false,
        dateCheckBool: true,
        search: '',
        headers: [
          {
            text: 'Title',
            align: 'start',
            sortable: false,
            value: 'url_title',
            width: '100%',
          },
          { value: 'article_url' }
        ], 
        clicks: [],
        scrolls: [],
        article: [],
        countbtnurl: [],
        countbtntext: [],        
        countclick: '',
        scrollp: [],
        scrolld: [],
        max_dur: [],
        ipcount: [],
        isActive: true,
        maxheight: '',
        scrollpercent: [],
        loading: true,
        options:{
          width: '100%',
          height: '100%',
          size: '20px',
          color: '#000000',
          alwaysVisible: true,
          distance: '20px',
          // start: top,
          // railVisible: true,
          railColor: '#222',
          railOpacity: 0.3,
          wheelStep: 10,
          touchScrollStep: 100,
          allowPageScroll: false,
          disableFadeOut: false
        }
      }
    },
    computed: {
      articleData() {
        return this.$store.state.articleData
      },
      domainName() {
        return this.$store.state.domainName
      },
      dateError () {
        var date = new Date();
        date.setDate(date.getDate() - 1);

        var yesterday = date.toISOString().substr(0, 10)

        if(yesterday < this.dates[0] || yesterday < this.dates[1]) {
          alert('昨日のデータからご覧いただけます。')
          this.dates = [
              new Date(new Date().setDate(new Date().getDate()-1)).toISOString().substr(0, 10),
              new Date(new Date().setDate(new Date().getDate()-1)).toISOString().substr(0, 10)
            ]
          return this.dateCheckBool;
        }else if(this.dates[0] < '2020-09-05' || this.dates[1] < '2020-09-05'){
          alert('2020-09-05 以前のデータは収集されませんでした');
            this.dates = [
              new Date(new Date().setDate(new Date().getDate()-1)).toISOString().substr(0, 10),
              new Date(new Date().setDate(new Date().getDate()-1)).toISOString().substr(0, 10)
            ]
          return this.dateCheckBool;
        }else if(this.dates.length < 2){
          return this.dateCheckBool;
        }

      },
      dateRangeText () {
        if(this.dates[0]>this.dates[1]){
          this.dates.reverse();
        }
        return this.dates.join(' ~ ')
      }
    },
    created () {
      var self = this;
      window.addEventListener('message',function(e){
        if(typeof e.data == 'number'){
          self.maxheight = e.data;
          self.loading = !self.loading;
        }
      });
      window.addEventListener('error', function(e){
        console.log(e.message);
      })
    },
    mounted () {
      // this.updateClicks ();
      // this.updateScrolls ();
      this.updateAd ();
      this.updateCbtnurl ();
      this.updateCbtntext ();
      this.updateClickcount ();
      // this.getIframe();
      this.getScrollp();
      this.getScrolld();
      this.getMaxd();
      this.getScrollCalculate();
      this.$store.commit('getArticleData',{
          startdate: this.dates[0],
          enddate: this.dates[1],
          hostname: 'total'
      });
      this.$store.commit('getDomainName',{
          article_id: this.$route.params.id
      });
      
    },
    methods: {

      // updateClicks: function () {
      //   axios
      //     .get('api/v1/articles/' + this.$route.params.id + '/clicks.json')
      //     .then(response => (this.clicks = response.data)) 
      // },
      getTotalByDate: function() {
        this.updateCbtnurl();
        this.updateCbtntext();
        this.updateClickcount();
        // this.getScrollp();
        this.getScrolld();
        this.getMaximumd();
        this.getScrollCalculate();
        this.$store.commit('getArticleData',{
          startdate: this.dates[0],
          enddate: this.dates[1],
          hostname: 'total'
        });
      },
      updateAd: function () {
        axios
          .get('api/v1/articles/' + this.$route.params.id + '.json')
          .then(response => (this.article = response.data)) 
      },
      updateCbtnurl: function (){ // add date
        axios
          .get('api/v1/articles/' + this.$route.params.id + '/counter/groupbyurl.json', {
            params: {
              startdate: this.dates[0],
              enddate: this.dates[1]
            }
          })
          .then(response => (this.countbtnurl = response.data)) 
      },
      updateCbtntext: function (){ // add date
        axios
          .get('api/v1/articles/' + this.$route.params.id + '/counter/groupbytext.json', {
            params: {
              startdate: this.dates[0],
              enddate: this.dates[1]
            }
          })
          .then(response => (this.countbtntext = response.data)) 
      },      
      updateClickcount: function(){ // add date
        axios
          .get('api/v1/articles/' + this.$route.params.id + '/counter/countclick.json', {
            params: {
              startdate: this.dates[0],
              enddate: this.dates[1]
            }
          })
          .then(response => (this.countclick = response.data)) 
      },
      getScrollp: function(){ // add date
        axios
          .get('api/v1/articles/' + this.$route.params.id + '/counter/scrollcalculate.json', {
            params: {
              startdate: this.dates[0],
              enddate: this.dates[1]
            }
          })
          .then(response => (this.scrollp = response.data)) 
      },
      getScrolld: function(){ // add date
        axios
          .get('api/v1/articles/' + this.$route.params.id + '/counter/durationcalculate.json', {
            params: {
              startdate: this.dates[0],
              enddate: this.dates[1]
            }
          })
          .then(response => (this.scrolld = response.data)) 
      },
      getMaxd: function(){ // add date
        axios
          .get('api/v1/articles/' + this.$route.params.id + '/counter/maxduration.json', {
            params: {
              startdate: this.dates[0],
              enddate: this.dates[1]
            }
          })
          .then(response => (this.max_dur = response.data)) 
      },
      updateArticle(newid){
        this.$router.replace({ name: "HeatmapPage", params: { id: newid }})
        this.$router.go();
      },
      getArticleData(){
        var articleData = this.articleData;
        var article = {};
        for(var key in articleData){
          if(this.$route.params.id == articleData[key].id ){
            article['pageviews'] = articleData[key].page_view;
            article['users'] = articleData[key].user;
          }
        }
        return article;
      },
      getDomain(){
        var domain = this.domainName;
        var result = '';
        
        var article_url = this.article.article_url;
        var domain_name = domain['domain_name'][0]
        result = '//' + domain_name + article_url
        
        return result
      },
      getScrollCalculate(){
        axios
          .get('api/v1/articles/' + this.$route.params.id + '/counter/scrollpcalculate.json', {
            params: {
              startdate: this.dates[0],
              enddate: this.dates[1]
            }
          })
          .then(response => (this.scrollpercent = response.data)) 
      },
      getHeight(index){
        
        var maxheight = parseInt(this.maxheight, 10);

        index = index -1;
        var percent = (index * 5)/100;
        var divHeight = (maxheight*percent);
        // var ceiledHeight = Math.ceil(divHeight);
        
        return divHeight
      },
      getMarginTop(){
        var maxheight = parseInt(this.maxheight, 10);

        var marginTop = maxheight*0.05

        return marginTop
      },
      gethsl(sum, max){
        var hsl = 100 - (sum/max)*100
        return hsl;
      }
    },
    beforeDestroy() {
        window.removeEventListener('message');
    },
    filters: {
      truncate: function (text, length, suffix) {
          return text.substring(0, length) + suffix;
      },
    }  
  }
</script>

<style scoped >
  html {
    height: 100%;
    background-color: lightgray;
  }
  body {
    height: 100%;
  }
  table {
    width: 100%;
    border-collapse: separate; 
    display: block;
  }
  tbody {
    width: 100%;
  }
  iframe {
    border: none; 
    position: absolute;
    overflow-y: visible; 
    z-index: -1;
    pointer-events: none;
  }
  div:empty {
    display: none;
  }
  .heat-color {
    width: 100%;
    height: 2000px;
    bottom: 30%;
    position: absolute;
  }
  .lines-p {
    font-size: 70px;
  }
  .lines {
    color:white;
    text-shadow: 0px 0px 5px black;
    
    margin-bottom: 0px;
    border-right-width: 0px;
    border-left-width: 0px;
    border-top-width: 0px;
    border-style: dotted;
    border-color: white;
    border-bottom-width: 10px;
  }
  .iframe-set {
    display: inline-block;
    position: fixed;
    height: 280%; 
    overflow: scroll;
    min-width: 1200px;
    margin-left: 50px;
    transform: scale(0.3,0.3);
    transform-origin: top left;
  }
  .values-set {
    float: right;
    display: block;
    position: relative;
    height: 100%;
    width: 60%;
    margin: 10px;
    margin-bottom: 10%;
  }
  .lists-set {
    display: block;
    position: relative;
    height: 100%;
    width: 100%;
    margin: 10px;
    margin-bottom: 10%;
  }
  .heat-body-set {
    display: block;
    position: absolute;
    width: 100%;
    height: 80%;  
    overflow-y: scroll;
  }
  .scroll-percent {
    width: 100%;
    position: absolute;
    pointer-events: none;
    text-align: center;
    z-index: 1;
  }
  .heat-map{
    background-color: blue;
    width: 100%;
    opacity: 0.7;
    pointer-events: none;
    z-index: 0;
    position: absolute;
  }
  .heat-map-line {
    position: absolute;
    width: 100%;
  }
  .clicks-list {
    margin: 10px;
    display: block;
    margin-left: 70px;
  }
  .click-item {
    width: 30%;
    display: inline-block;
  }
  .btn-dis {
    display: block;
    box-shadow: 0px 1px 2px 0px rgba(0,0,0,0.5);
    border-radius: 5px;
    width: 100px;
    background-color: white;
    text-align: end;
    padding: 5px;
    font-size: 10px;
    margin-left: 40px;
    margin-top: -22px;
    z-index: -1;
    transition: 2s;
  }
  .btn-dis:hover {
    transition: 2s;
  }
  .btn-dis-txt {
    display: block;
    box-shadow: 0px 1px 2px 0px rgba(0,0,0,0.5);
    border-radius: 5px;
    width: 100%;
    background-color: white;
    text-align: end;
    padding: 5px;
    font-size: 10px;
    margin-left: 40px;
    margin-top: -22px;
    z-index: -1;
    transition: 2s;
  }
  .btn-info {
    display: block;
    box-shadow: 0px 2px 10px 0px rgba(0,0,0,0.5);
    border-radius: 5px;
    width: 100%;
    background-color: gray;
    text-align: center;
    padding:  5px;
    margin-bottom: -5px;
    transform: translateZ(0);
    overflow: hidden;
    text-overflow: ellipsis;
    height: 30px;
    transition: 2s;
  }

  .btn-img {
    display: block;
    box-shadow: 0px 2px 10px 0px rgba(0,0,0,0.5);
    border-radius: 5px;
    width: 100px;
    transform: translateZ(0);
  }
  .btns tr {
    width: 200px;
    display: inline-block;
  }
  .btns {
    display: block;
    width: 50%;
  }
  .info td {
    background-color: #ff4242;
    transition: 0.7s;
    border-radius: 5px;
    margin-left: 70px;
    display: inline-block;
    width: 70px;
    height: 70px;
    position: relative;
    color: ghostwhite;
    box-shadow: 0px 2px 10px 0px rgba(0,0,0,0.5);
    text-align: center;
    font-size: 10px;
    padding-top: 10px;
  }
  .info td p {
    font-size: 13px;
  }
  .info tr{
    height: 20%;
  }
  .page-title-wrapper:hover {
    color: #42b883;
    cursor: pointer;
  }
  .read-line {
    position: absolute;
    width: 100%;
  }
  .spinner {
    top: 800px;
    left: 35%;
  }

  .iframe-parent {
    position: relative; 
    z-index: 1;
  }

</style>