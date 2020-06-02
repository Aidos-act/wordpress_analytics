Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      get 'healths/health'
    end
  end
  root to: 'home#index'

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
        get 'counter/totalduration'
        get 'counter/ipcount'
  	  end
  	  resources :clicks, only: [:index, :show]
  	  resources :scrolls, only: [:index]

      post 'articles/new' => 'articles#new'
      get '/health' => 'healths#health'
      # google analytics api data
      resources :ga_api_info do
        collection do
          get 'getArticleData'
          get 'getTotalGaInfo'
          get 'getDemographic'
        end
      end

    end
  end

end