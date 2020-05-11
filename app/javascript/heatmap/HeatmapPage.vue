<template>
  <div>
    <h1>HeatMap Page</h1>
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
        <tr>
          <td>{{ article.id }}</td>
          <td>{{ article.title }}</td>
          <td>{{ article.url }}</td>
          <td>{{ article.created_at }}</td>
          <td v-for = "c in article.click">
            {{c.article_id}},
            {{c.btn_id}},
            {{c.click_x}},
            {{c.click_y}},
            {{c.view_ip}}
          </td>
          <td v-for = "s in article.scroll">
            {{s.article_id}},
            {{s.scroll_max_pos}}
          </td>
          <td v-for = "sd in article.scroll_duration">
            {{sd.article_id}},
            {{sd.scroll_pos}},
            {{sd.scroll_du}}
          </td>
        </tr>
      </tbody>
    </table>
  </div>  

</template>

<script>
import axios from 'axios';

export default {
  name: 'DashboardHeatmapPage',
  computed: {
    article() {
     return this.$store.state.article
    }
  },
  mounted () {
    this.$store.commit('setArticleInfo', this.$route.params.id)  
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