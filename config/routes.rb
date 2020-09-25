Rails.application.routes.draw do

  root to: 'home#index'
  get '/health' => 'api/v1/healths#health'

  namespace :api do
    namespace :v1 do
      # db article data
      resources :articles do
      	resources :clicks
      	resources :scrolls

        post 'clicks/new' => 'clicks#new'
        post 'scrolls/new' => 'scrolls#new'
        get 'counter/groupbyurl'
        get 'counter/groupbytext'
        get 'counter/countclick'
        get 'counter/countview'
        get 'counter/maxheight'
        get 'counter/scrollcalculate'
        get 'counter/durationcalculate'
        get 'counter/maxduration'
        get 'counter/avgdurarticle'
        get 'counter/ipcount'
        get 'counter/scrollpcalculate'
        get 'counter/durationpercentages'
  	  end
  	  resources :clicks, only: [:index, :show]
  	  resources :scrolls, only: [:index]
      resources :domains do
        collection do 
          get 'domainInfo'
        end
      end
      resources :goals
      resources :goal_achievements

      post 'articles/new' => 'articles#new'

      get 'counter/avgdurall'
      
      resources :ga_apis do
        collection do
          get 'currentTotal'
          get 'compareTotal'
          get 'currentLineChart'
          get 'compareLineChart'
          get 'articleData'
          get 'articleAvg'
          get 'goalData'
          get 'goalDataByArticle'
        end
      end

      
      # google analytics api data
      resources :ga_api_info do
        collection do
          get 'getTotalGaInfo'
          get 'getDemographic'
        end
      end

    end
  end

end