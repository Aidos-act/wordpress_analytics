Rails.application.routes.draw do

  root to: 'home#index'

  namespace :api do
    namespace :v1 do
      # db article data
      resources :articles, only: [:index, :show] do
      	resources :clicks
      	resources :scrolls
      	resources :scroll_durations
  	  end
  	  resources :clicks, only: [:index]
  	  resources :scrolls, only: [:index]

      # google analytics api data
      resources :ga_api_info
    end
  end

end