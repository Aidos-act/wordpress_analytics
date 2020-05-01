<template>
  <div>
    <table>
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
    </table>
  {{ gainfos }}
  </div>  

</template>

<script>
import axios from 'axios';

export default {
  name: 'DashboardIndex',
  computed: {
     // [store.js]から[articles]を呼び出して，[DashboardIndex.vue]のdata[articles]に格納
    articles() {
     return this.$store.state.articles
    },
    gainfos() {
      return this.$store.state.gainfos
    }
  },
  mounted () {
    this.$store.commit('fetchArticles')
    this.$store.commit('getGaInfo',{
      startdate: 'today',
      enddate: 'today'
    })
  }
}


</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
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