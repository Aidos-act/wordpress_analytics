Rails.application.routes.draw do
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'home#index'

  namespace :api do
    namespace :v1 do
      resources :articles, only: [:index, :show] do
      	resources :clicks
      	resources :scrolls
      	resources :scroll_durations
  	  end
  	  resources :clicks, only: [:index]
  	  resources :scrolls, only: [:index]
      
    end
  end

end