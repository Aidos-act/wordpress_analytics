<template>
  <div>
    <!-- <table>
      <tbody>
        <tr>
          <th>ID</th>
          <th>title</th>
          <th>url</th>
          <th>created_at</th>
          <th>clicks</th>
          <th>scrolls</th>
          <th>scroll_durations</th>
        </tr> 
        <tr v-for = "a in articles">
          <td>{{ a.id }}</td>
          <td><router-link :to="{ name: 'HeatmapPage', params: { id: a.id } }">{{ a.title }}</router-link></td>
          <td>{{ a.url }}</td>
          <td>{{ a.created_at }}</td>
          <td v-for = "c in a.click">
            {{c.article_id}},
            {{c.btn_id}},
            {{c.click_x}},
            {{c.click_y}},
            {{c.view_ip}}
          </td>
          <td v-for = "s in a.scroll">
            {{s.article_id}},
            {{s.scroll_max_pos}}
          </td>
          <td v-for = "sd in a.scroll_duration">
            {{sd.article_id}},
            {{sd.scroll_pos}},
            {{sd.scroll_du}}
          </td>
        </tr>
      </tbody>
    </table> -->
    <table>
      <tbody>
        <tr>
          <th>ID</th>
          <th>title</th>
          <th>url</th>
          <th>created_at</th>
          <th>clicks</th>
          <th>scrolls_views</th>
          <th>scroll_max</th>
        </tr> 
        <tr v-for = "a in articles">
          <td>{{ a.id }}</td>
          <td><router-link :to="{ name: 'HeatmapPage', params: { id: a.id } }">{{ a.title }}</router-link></td>
          <td>{{ a.url }}</td>
          <td>{{ a.created_at }}</td>
          <td>
            {{ a.click.length }}
          </td>
          <td>
            {{ a.scroll_duration.length }}
          </td>
          <td>
            {{ getMaxValue(a.scroll) }}
          </td>
        </tr>
      </tbody>
    </table>
      <hr>
      <hr>
      {{ articles }}
      <hr>
      <hr>
      <hr>
      <hr>
      <hr>
      <hr>
      <hr>
      <hr>
      <hr>
      <hr>
<!--     <table>
      <tbody>
        <tr>
          <th>title</th>
          <th>pv</th>
          <th>uv</th>
          <th>time on page</th>
          <th>bounce</th>
          <th>entrance</th>
          <th>exit</th>
        </tr>
        <tr v-for="(value, key) in gainfos">
          <td>
            {{ value[1] }}
            <small>{{ value[0] }}</small>
          </td>
          <td v-for="(item, index) in value[2]">
            {{ item }}
          </td>
        </tr>
      </tbody>
    </table> -->
      {{ gainfos }}
      {{ setSearchData }}
      <hr>
      {{ searchData }}
      <v-card>
        <v-card-title>
          Article List
          <v-spacer></v-spacer>
          <v-text-field
            v-model="search"
            append-icon="mdi-magnify"
            label="Search"
            single-line
            hide-details
          ></v-text-field>
        </v-card-title>
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
                  <p class="page-title" @click="getArticleData(data.pagePath)">{{ data.pageTitle }}</p>
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
    
      <hr>
      <hr>
      <hr>
      <!-- selected aricle data -->
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
    <hr>
    <hr>
    <hr>
    <!-- <v-card>{{ gainfos.keys() }}</v-card> -->
   
   <hr>

    <!-- <v-row>
      <v-col cols="12" sm="6">
        <v-date-picker v-model="dates" range></v-date-picker>
      </v-col>
      <v-col cols="12" sm="6">
        <v-text-field v-model="dateRangeText" label="Date range" readonly></v-text-field>
        model: {{ dates }}
      </v-col>
    </v-row>
    <v-btn color="success" @click="getDate">Success</v-btn>  -->

    <!-- datepicker -->
    <v-row>
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
  </v-row>



  <v-container fluid>
    <v-row align="center">
      <v-col class="d-flex" cols="12" sm="6">
        <!-- <v-select
          v-model="items.value"
          :value="items.value"
          :items="items"
          label="Select"
          dense
          @input="testSelect"
        ></v-select> -->
        <v-select
          v-model="selectedItem.item"
          item-text="key"
          item-value="item"
          :items="items"
          label="Select"
          dense
          @input="getDropDwn"
        ></v-select>
      </v-col>
    </v-row>
  </v-container>

  
  {{ selectedItem.item }}

  <br>
  <br>
  <hr>
  
  dropdown list
  {{ dropdwninfos }}
  
  <br>
  <br>
  <hr>

  ranking list
  {{ rankingInfos }}

  <br>
  <br>
  <hr>
  <div>compare</div>
  <br>
  {{ getCompaerDates }}
  <v-card>{{ compareGaInfos }}</v-card>
  </div>  
</template>

<script>
import axios from 'axios';
export default {
  name: 'DashboardIndex',
  data: () => ({
      dates: [
        new Date().toISOString().substr(0, 10),
        new Date().toISOString().substr(0, 10)
      ],
      menu: false,
      dateCheckBool: true,
      selectedItem: { key: "pageView", item: "ga:pageviews"},
      items: [
        { key: "pageView", item: "ga:pageviews"},
        { key: "UV", item: "ga:uniquePageviews"},  // 여기까지 했고 키 밸류 형태로 셀렉트해서 메소드로 넘길 수 있으니 키에 구글어널리틱스 키워드 넣고 해서 값 넘기기
      ],
      testitem: '1',
      compareDates: [],
      search: '',
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
     searchData: [
      {
          title: 'Frozen Yogurt',
          pv: 159,
          uv: 6.0,
          top: '박훈',
          bounce: 4.0,
          entrance: '1%',
          exit: 4
        },
        {
          title: 'tiger',
          pv: 159,
          uv: 6.0,
          top: 24,
          bounce: 4.0,
          entrance: '1%',
          exit: 4
        },
        {
          pp: 'tea',
          pv: 159,
          uv: 6.0,
          top: 24,
          bounce: 4.0,
          entrance: '1%',
          exit: 4
        }
     ],
     showSelectedBool: false,
     scrollMaxPos: 0
    }),
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
      
      return this.compareDates
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
    dropdwninfos() {
      return this.$store.state.dropdwninfos
    },
    rankingInfos() {
      return this.$store.state.rankingInfos
    },
    artilceData() {
      return this.$store.state.artilceData
    }
  },
  mounted () {
    console.log(typeof this.searchData)
    this.$store.commit('fetchArticles');
    this.$store.commit('getGaInfo',{
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
  methods: {
      getDate(dates) {
        this.$store.commit('getGaInfo',{
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
        console.log(value);
        this.$store.commit('getAticleData',{
          startdate: this.dates[0],
          enddate: this.dates[1],
          selectedPath: value
        })
        this.showSelectedBool = true
      },
      getMaxValue(value) {
        var i;
        var arr = [];
        for (i = 0; i < value.length; i++) {
          arr.push(value[i].scroll_max_pos)
        }
        var data = Math.max.apply(null, arr);
        return data
      },
  }
}


</script>


<style scoped>
  
  .page-title {
    margin: 0;
  }
  
  .page-title:hover {
    color: #42b883;
    cursor: pointer;
  }

  .page-path {
    color: #828282;
  }

    table {
    width: 100%;
    border: 1px solid #444444;
    border-collapse: collapse;
  }
  th, td {
    border: 1px solid #444444;
  }


</style>