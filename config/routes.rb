Myflix::Application.routes.draw do
  root to: 'front#index'

  get 'ui(/:action)', controller: 'ui'
  get '/home', to: 'categories#index'
  get '/front', to: 'front#index'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'

  get '/getstarted', to: 'users#new'
  resources :users, only: [:create]

  resources :videos, only: [:show] do
    post :search, on: :collection
  end
  resources :categories, only: [:show]
end
