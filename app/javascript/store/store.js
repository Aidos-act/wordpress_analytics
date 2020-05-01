import Vue from 'vue'
import Vuex from 'vuex'
import router from '../router/router.js'
import axios from 'axios'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
  	articles: [],
  	article: {},
    gainfos: []
  },
  mutations: {
  	fetchArticles(state){
  		state.articles = [];
  		axios
	      .get('/api/v1/articles.json')
	      .then(response => (state.articles = response.data), (error) => {console.log(error);})
  	},
  	setArticleInfo(state, id){
  		axios
	      .get('/api/v1/articles/'+id+'.json')
	      .then(response => (state.article = response.data), (error) => {console.log(error);})
  	},
    getGaInfo(state, payload){
      console.log(payload);
      axios
        .get('/api/v1/ga_api_info.json', {
            params: {
              startdate: payload.startdate,
              enddate: payload.enddate
            }
        })
        .then(response => (state.gainfos = response.data), (error) => {console.log(error);})
    }
  }
})


