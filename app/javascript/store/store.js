import Vue from 'vue'
import Vuex from 'vuex'
import router from '../router/router.js'
import axios from 'axios'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
  	articles: [],
  	article: {},
    totalgainfos: [],
    gainfos: [],
    dropdwninfos: [],
    rankingInfos: [],
    compareGaInfos: [],
    artilceData: [],
    drawer: null,
  },
  mutations: {
    SET_DRAWER (state, payload) {
      state.drawer = payload
    },
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
    getCompareGaInfo(state, payload){
      axios
        .get('/api/v1/ga_api_info/getTotalGaInfo.json', {
            params: {
              startdate: payload.startdate,
              enddate: payload.enddate
            }
        })
        .then(response => (state.compareGaInfos = response.data), (error) => {console.log(error);})
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
    getDropDown(state, payload){
      axios
        .get('/api/v1/ga_api_info/getDropDown.json', {
            params: {
              startdate: payload.startdate,
              enddate: payload.enddate,
              selectedDrop: payload.selectedDrop
            }
        })
        .then(response => (state.dropdwninfos = response.data), (error) => {console.log(error);})
    },
    getRanking(state, payload){
      axios
        .get('/api/v1/ga_api_info/getRankingList.json', {
            params: {
              startdate: payload.startdate,
              enddate: payload.enddate
            }
        })
        .then(response => (state.rankingInfos = response.data), (error) => {console.log(error);})
    },
    getAticleData(state, payload){
      axios
        .get('/api/v1/ga_api_info/getArticleData.json', {
            params: {
              startdate: payload.startdate,
              enddate: payload.enddate,
              selectedPath: payload.selectedPath
            }
        })
        .then(response => (state.artilceData = response.data), (error) => {console.log(error);})
    }
  }
})


