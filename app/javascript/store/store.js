import Vue from 'vue'
import Vuex from 'vuex'
import router from '../router/router.js'
import axios from 'axios'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    goalData: 0,
  	articles: [],
  	article: {},
    clickcount: 0,
    totalgainfos: [],
    gainfos: [],
    demographicData: [],
    articleData: [],
    drawer: null,
  },
  mutations: {
    SET_DRAWER (state, payload) {
      state.drawer = payload
    },
  	fetchArticles(state, payload){
  		axios
	      .get('/api/v1/articles.json')
	      .then(response => (state.articles = response.data), (error) => {console.log(error);})
  	},
    fetchClicks(state, payload){
      axios
        .get('/api/v1/clicks.json', {
          params: {
            startdate: payload.startdate,
            enddate: payload.enddate,
            articleId: payload.articleId
          }
        })
        .then(response => (state.clickcount = response.data), (error) => {console.log(error);})
    },
  	setArticleInfo(state, id){
  		axios
	      .get('/api/v1/articles/'+id+'.json')
	      .then(response => (state.article = response.data), (error) => {console.log(error);})
  	},  
    getTotalGaInfo(state, payload){
      axios
        .get('/api/v1/ga_api_info/getTotalGaInfo.json', {
            params: {
              startdate: payload.startdate,
              enddate: payload.enddate
            }
        })
        .then(response => (state.totalgainfos = response.data), (error) => {console.log(error);})
    },
    getGaInfo(state, payload){
      axios
        .get('/api/v1/ga_api_info.json', {
            params: {
              startdate: payload.startdate,
              enddate: payload.enddate
            }
        })
        .then(response => (state.gainfos = response.data), (error) => {console.log(error);})
    },
    getDemographic(state, payload){
      axios
        .get('/api/v1/ga_api_info/getDemographic.json', {
            params: {
              startdate: payload.startdate,
              enddate: payload.enddate
            }
        })
        .then(response => (state.demographicData = response.data), (error) => {console.log(error);})
    },
  }
})


