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
    currentTotal: {},
    compareTotal: {},
    currentLineChart: {},
    compareLineChart: {},
    articleData: {},
    articleAvg: {},
    domainName: '',
    goalData: {},
    goalDataByArticle: [],
    domainInfo: [],
    gainfos: [],
    demographicData: [],
    articleData: [],
    drawer: true,
    articleId: ''
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
              enddate: payload.enddate,
              hostname: payload.hostname
            }
        })
        .then(response => (state.totalgainfos = response.data), (error) => {console.log(error);})
    },
    getCurrentTotal(state, payload){
      axios
        .get('/api/v1/ga_apis/currentTotal.json', {
            params: {
              startdate: payload.startdate,
              enddate: payload.enddate,
              hostname: payload.hostname
            }
        })
        .then(response => (state.currentTotal = response.data), (error) => {console.log(error);})
    },
    getCompareTotal(state, payload){
      axios
        .get('/api/v1/ga_apis/compareTotal.json', {
            params: {
              startdate: payload.startdate,
              enddate: payload.enddate,
              hostname: payload.hostname
            }
        })
        .then(response => (state.compareTotal = response.data), (error) => {console.log(error);})
    },
    getCurrentLineChart(state, payload){
      axios
        .get('/api/v1/ga_apis/currentLineChart.json', {
            params: {
              startdate: payload.startdate,
              enddate: payload.enddate,
              hostname: payload.hostname
            }
        })
        .then(response => (state.currentLineChart = response.data), (error) => {console.log(error);})
    },
    getcompareLineChart(state, payload){
      axios
        .get('/api/v1/ga_apis/compareLineChart.json', {
            params: {
              startdate: payload.startdate,
              enddate: payload.enddate,
              hostname: payload.hostname
            }
        })
        .then(response => (state.compareLineChart = response.data), (error) => {console.log(error);})
    },
    getArticleData(state, payload){
      axios
        .get('/api/v1/ga_apis/articleData.json', {
            params: {
              startdate: payload.startdate,
              enddate: payload.enddate,
              hostname: payload.hostname
            }
        })
        .then(response => (state.articleData = response.data), (error) => {console.log(error);})
    },
    getArticleAvg(state, payload){
      axios
        .get('/api/v1/ga_apis/articleAvg.json', {
            params: {
              startdate: payload.startdate,
              enddate: payload.enddate,
              hostname: payload.hostname
            }
        })
        .then(response => (state.articleAvg = response.data), (error) => {console.log(error);})
    },
    getDomainName(state, payload){
      axios
        .get('/api/v1/domains/'+payload.article_id+'.json', {
          params: {
            article_id: payload.article_id,
            maxheight: payload.maxheight
          }
        })
        .then(response => (state.domainName = response.data), (error) => {console.log(error);})
    },
    getGoalData(state, payload){
      axios
        .get('/api/v1/ga_apis/goalData.json', {
            params: {
              startdate: payload.startdate,
              enddate: payload.enddate,
              hostname: payload.hostname
            }
        })
        .then(response => (state.goalData = response.data), (error) => {console.log(error);})
    },
    getGoalDataByArticle(state, payload){
      axios
        .get('/api/v1/ga_apis/goalDataByArticle.json', {
            params: {
              startdate: payload.startdate,
              enddate: payload.enddate,
              hostname: payload.hostname
            }
        })
        .then(response => (state.goalDataByArticle = response.data), (error) => {console.log(error);})
    },
    getDomainInfo(state, payload){
      axios
        .get('/api/v1/domains/domainInfo.json', {
            params: {
              hostname: payload.hostname
            }
        })
        .then(response => (state.domainInfo = response.data), (error) => {console.log(error);})
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


