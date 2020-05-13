<template>
      <div>
        <iframe :src="article.url" frameborder="0" sandbox></iframe>
        <table>
          <tbody>

            <h1> Advertisement </h1>
            <tr>
              <td> ID: {{ article.id }} </td>
              <td> Title: {{ article.title }} </td>
              <td> URL: {{ article.url }} </td> 
              <td> Created at: {{ article.created_at }} </td>
            </tr>

            <h1> Clicks </h1>
            <tr v-for = "c in article.click">
              <td> ID: {{ c.article_id }} </td>
              <td> X: {{ c.click_x }} </td>
              <td> Y: {{ c.click_y }}</td> 
              <td> BTN: {{ c.btn_id }} </td>
              <td> IP: {{ c.view_ip }} </td>
            </tr>

            <h1> Scrolls </h1>
            <tr v-for = "sd in article.scroll_duration">
              <td> ID: {{ sd.article_id }} </td>
              <td> Scroll %: {{ sd.scroll_pos }} </td>
              <td> Scroll Duration: {{ sd.scroll_du }}</td> 
            </tr>

            <h1> Max Scrolls </h1>
            <tr v-for = "s in article.scroll">
              <td> ID: {{ s.article_id }} </td>
              <td> Max Scroll: {{ s.scroll_max_pos }} </td> 
            </tr>
            
            <tr>
              <button class="btn"><router-link :to="{path: '/'}"> Back </router-link></button>
            </tr>

          </tbody>
        </table>
      </div>  
    
</template>

<script>
export default {
  name: 'HeatmapPage',
  data () {
      return {

      }
  },
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
  .btn {
    float: right;
    margin-right: 20px;
    width: 40px;
    height: 40px;
  }
table {
  width: 49%;
  float: right!important;
  margin: 10px;
  margin-bottom: 10%;
  position: relative;
  display: block;
}
iframe {
  position: absolute;
  border: none;
  width: 49%;
  height: 70%;
}

</style>