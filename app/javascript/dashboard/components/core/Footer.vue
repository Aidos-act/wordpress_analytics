<template>
  <v-footer
    id="dashboard-core-footer"
  >
      <!-- artilce db data start, i will combine it to google api data soon -->
      <v-col
        cols="12"
        md="12"
      >
        <div class="ad-index" >
          <h1> 
            Advertisements 
            <button 
              class='button' 
              v-bind:class="[isActive ? 'white' : 'black']" 
              @click="toggleClass()" 
            ></button> 
          </h1> 
     
          <table v-bind:style = '{"display": (isActive? "none" : "block" )}'>
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
                <td @click="toggleClass()">
                  <router-link :to="{ path: '/api/v1/articles/:id', name: 'HeatmapPage', params: { id: a.id } }">{{ a.title }}</router-link>
                </td>
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
        </div>
      </v-col>
      <!-- artilce db data end -->
    
    
  </v-footer>
</template>

<script>
  export default {
    name: 'DashboardCoreFooter',
    data: function () {
      return {
        advertisements: [],
        isActive: true,
        errors: '',
        item: [
          {
            title: 'HeatMap',
            icon: 'mdi-chart-bubble',
            to: '/api/v1/articles/:id',
          },
        ],
      }
    },
    computed: {
      articles() {
        return this.$store.state.articles
      },
    },
    mounted() {
      this.$store.commit('fetchArticles');
    },
    methods: {
      getMaxValue(value) {
        var i;
        var arr = [];
        for (i = 0; i < value.length; i++) {
          arr.push(value[i].scroll_max_pos)
        }
        var data = Math.max.apply(null, arr);
        return data
      },
      toggleClass: function(event){
        this.isActive = !this.isActive;
      },
    }
  }
</script>

<style scoped>
  #dashboard-core-footer > a {
	font-size: 0.825rem;
	font-weight: 500;
	text-decoration: none;
	text-transform: uppercase;
  }


  .button {
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

  h1{
    padding-top: 1em;
    margin-top: 0px;
    text-align: center;
    color: white;
  }
  h3 {
    font-size: 1em;
  }
  p{
    font-size: 0.5em;
  }
  table {
    width: 100%;
    border-collapse: separate; 
  }
  tbody {
    width: 100%;
  }
  tr {
    transition: 0.7s;
    background-color: white;
    margin: 1em;
    right: 0px;
  }
  tr:first-child td:first-child { border-top-left-radius: 20px; }
  tr:first-child td:last-child { border-top-right-radius: 20px; }
  tr:last-child td:first-child { border-bottom-left-radius: 20px; }
  tr:last-child td:last-child { border-bottom-right-radius: 20px; }
  tr:hover {
    background-color: #ff8585;
    transition: 0.7s;
  }
  th{
    padding-left: 10px;
    padding-top: 5px;
  }
  td {
    padding-left: 10px;
    padding-right: 10px;
    border: 2px solid #ff4242;
    border-right-width: 0px;
    border-left-width: 0px;
    border-bottom-width: 0px; 
  }
  .title-url {
    padding-left: 10px;
    padding-right: 10px;
    border: 2px solid #ff4242;
    border-right-width: 0px;
    border-left-width: 0px;
    border-bottom-width: 0px; 
    width: 100%;
  }
  .ad-index{
    padding: 1em;
    background-color: #ff4242;
    transition: 1s;
    max-width: 80%;
    width: 80%;
    position: fixed;
    bottom: 0px;
  }
</style>