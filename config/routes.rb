Rails.application.routes.draw do

  root to: 'home#index'

  namespace :api do
    namespace :v1 do
      # db article data
      resources :articles do
      	resources :clicks
      	resources :scrolls
      	resources :scroll_durations
  	  end
  	  resources :clicks, only: [:index]
  	  resources :scrolls, only: [:index]

      get 'articles/:id', to: 'articles#show'


      # google analytics api data
      resources :ga_api_info do
        collection do
          get 'getDropDown'
          get 'getArticleData'
          get 'getTotalGaInfo'
          get 'getDemographic'
        end
      end

    end
  end

end