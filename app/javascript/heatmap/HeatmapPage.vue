<template>
  <div class="heat-body-set">
      <div class="iframe-set">
         <div class="scroll-percent" >
            <div v-for="e in scrollp.length">
              <div class="lines"> 
                  <p class="lines-p"> {{ scrollp[e-1] }}% </p>
              </div>
            </div>
         </div>
         <div class="heat-map" v-bind:style="{ height: article.maxpos + 'px' }">
           <div v-for="e in scrolld">
              <div v-if="e.sum_dur >= totald/100">  
                <div class="heat-map-line" v-bind:style="{ top: e.scroll_pos + '%' }"> 
                  <h1 class="heat-red"></h1>
                </div>  
              </div>
              <div v-if="e.sum_dur <= totald/100"> 
                <div v-if="e.sum_dur >= totald/200">  
                  <div class="heat-map-line" v-bind:style="{ top: e.scroll_pos + '%' }"> 
                    <h2 class="heat-yellow"></h2>
                  </div>  
                </div>
                <div v-if="e.sum_dur < totald/200">
                  <div v-if="e.sum_dur > totald/400">  
                    <div class="heat-map-line" v-bind:style="{ top: e.scroll_pos + '%' }"> 
                      <h3 class="heat-green"></h3>
                    </div>  
                  </div>
                </div>
              </div>
           </div>
         </div>
         <iframe :src="article.url" frameborder="0" allowfullscreen sandbox marginheight="0" marginwidth="0" width="100%" :height="article.maxpos "></iframe>
      </div>


      <div class="values-set">
        <h3> <strong> {{ article.title }} </strong> </h3> 
        <a :href="article.url"><p style="overflow-wrap: normal; font-size: 10px;"> <small> {{ article.title }}></small> </p></a>
        
        <v-simple-table>
          <template v-slot:default>
            <tbody>
              <tr v-for="(value, key) in getArticleData()">
                <td>{{ key }}</td>
                <td>{{ value }}</td>
                
              </tr>
              <tr>
                <td>Created at</td>
                <td>{{ article.created_at.split('T')[0] }}</td>
              </tr>
              <tr>
                <td>MCV(Clicks)</td>
                <td>{{ countclick.count_click }}</td>
              </tr>
              <tr>
                <td>Views(IP)</td>
                <td>{{ ipcount.length }}</td>
              </tr>
            </tbody>
          </template>
        </v-simple-table>

        <br>
        <hr>
        <br>

        <h3> <strong> Clicks </strong> </h3>
        <table>
          <tbody class="btns">
            <div class="click-item" v-for="e in countbtnurl" >
                <td v-if="e.btn_url != 'undefined'" class="clicks-list"> <img class="btn-img" :src="e.btn_url" style="width: 100px;"> <p class="btn-dis">{{ e.url_count }}</p></td>
            </div>
            <div class="click-item" v-for="e in countbtntext">
                <td v-if="e.btn_text != 'undefined'" class="clicks-list" v> <p class="btn-info" >{{ e.btn_text }}</p>  <p class="btn-dis"> {{e.text_count}}</p> </td> 
            </div>
          </tbody>
        </table>


        <br>
        <hr>
        <br>
        
        <h3> <strong> List </strong> </h3>
        
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
                    <!-- <td class="page-title-wrapper" @click="updateArticle(data.id)"> -->
                    <td class="page-title-wrapper" @click="updateArticle(data.id)">  
                      <p class="page-title">{{ data.pageTitle | truncate(20, '...') }}</p>
                      <small class="page-path">{{ data.pagePath | truncate(20, '...') }}</small>
                    </td>
                    <td>{{ data.clickCount }}</td>
                    <td>{{ data.pageviews }}</td>
                    <td>{{ data.users }}</td>
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
        search: '',
        headers: [
          {
            text: 'Title',
            align: 'start',
            sortable: false,
            value: 'pageTitle',
            width: '45%',
          },
          { text: 'MCV', value: 'clickCount' },
          { text: 'PV', value: 'pageviews' },
          { text: 'UV', value: 'users' },
          { value: 'pagePath' }
        ], 
        clicks: [],
        scrolls: [],
        article: [],
        countbtnurl: [],
        countbtntext: [],        
        countclick: [],
        scrollp: [],
        scrolld: [],
        totald: [],
        ipcount: [],
        isActive: true,
        errors: ''
      }
    },
    computed: {
      gainfos() {
        return this.$store.state.gainfos
      },
    },
    mounted () {
      // this.updateClicks ();
      this.updateScrolls ();
      this.updateAd ();
      this.updateCbtnurl ();
      this.updateCbtntext ();      
      this.updateClickcount ();
      // this.getIframe();
      this.getScrollp();
      this.getScrolld();
      this.getTotald();
      this.getIp();
      this.$store.commit('getGaInfo',{
          startdate: this.dates[0],
          enddate: this.dates[1]
      });
      },
    methods: {
      // updateClicks: function () {
      //   axios
      //     .get('api/v1/articles/' + this.$route.params.id + '/clicks.json')
      //     .then(response => (this.clicks = response.data)) 
      // },
      updateScrolls: function() {
        axios
          .get('api/v1/articles/' + this.$route.params.id + '/scrolls.json')
          .then(response => (this.scrolls = response.data))   
      },
      updateAd: function () {
        axios
          .get('api/v1/articles/' + this.$route.params.id + '.json')
          .then(response => (this.article = response.data)) 
      },
      updateCbtnurl: function (){
        axios
          .get('api/v1/articles/' + this.$route.params.id + '/counter/groupbyurl.json')
          .then(response => (this.countbtnurl = response.data)) 
      },
      updateCbtntext: function (){
        axios
          .get('api/v1/articles/' + this.$route.params.id + '/counter/groupbytext.json')
          .then(response => (this.countbtntext = response.data)) 
      },      
      updateClickcount: function(){
        axios
          .get('api/v1/articles/' + this.$route.params.id + '/counter/countclick.json')
          .then(response => (this.countclick = response.data)) 
      },
      getScrollp: function(){
        axios
          .get('api/v1/articles/' + this.$route.params.id + '/counter/scrollcalculate.json')
          .then(response => (this.scrollp = response.data)) 
      },
      getScrolld: function(){
        axios
          .get('api/v1/articles/' + this.$route.params.id + '/counter/durationcalculate.json')
          .then(response => (this.scrolld = response.data)) 
      },
      getTotald: function(){
        axios
          .get('api/v1/articles/' + this.$route.params.id + '/counter/totalduration.json')
          .then(response => (this.totald = response.data)) 
      },
      getIp: function(){
        axios
          .get('api/v1/articles/' + this.$route.params.id + '/counter/ipcount.json')
          .then(response => (this.ipcount = response.data)) 
      },
      updateArticle(newid){
        this.$router.replace({ name: "HeatmapPage", params: { id: newid }})
        this.$router.go();
      },
      getArticleData(){
        var gainfos = this.$store.state.gainfos;
        var articleData = {};
        for(var key in gainfos){
          if(this.$route.params.id == gainfos[key].id ){
            articleData['pageviews'] = gainfos[key].pageviews;
            articleData['users'] = gainfos[key].users;
          }
        }
        return articleData;
      }
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
  .heat-red {
    background: linear-gradient(transparent, yellow, red, yellow, transparent);
    width: 100%;
    height: 1500px;
    bottom: 30%;
    position: absolute;
  }
  .heat-yellow {
    background: linear-gradient(transparent, yellow, transparent);
    width: 100%;
    height: 1500px;
    bottom: 30%;
    position: absolute;
  }
  .heat-green {
    background: linear-gradient(transparent, green, transparent);
    width: 100%;
    height: 1500px;
    bottom: 30%;
    position: absolute;
  }
  .lines-p {
    font-size: 70px;
  }
  .lines {
    color:white;
    text-shadow: 0px 0px 5px black;
    margin-top: 600px;
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
    height: 370%; 
    overflow: scroll;
    min-width: 1200px;
    margin-left: 100px;
    transform: scale(0.2,0.2);
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
    width: 100%
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
  .btn-info {
    display: block;
    box-shadow: 0px 2px 10px 0px rgba(0,0,0,0.5);
    border-radius: 5px;
    width: 100px;
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
  .btn-info:hover {
    box-shadow: 0px 5px 20px 0px rgba(0,0,0,0.5);
    background-color: black;
    text-align: center;
    margin-bottom: 0;
    overflow: visible;
    transition: 2s;
    height: max-content;
    position: absolute;
    z-index: 1;
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
</style>