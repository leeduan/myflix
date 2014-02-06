Myflix::Application.routes.draw do
  root to: 'pages#front'
  get 'ui(/:action)', controller: 'ui'
  get '/front', to: 'pages#front'
  get '/home', to: 'videos#index'
  get '/signin', to: 'sessions#new'
  post '/signin', to: 'sessions#create'
  get '/signout', to: 'sessions#destroy'
  get '/getstarted', to: 'users#new'

  resources :users, only: [:create]
  resources :videos, only: [:show] do
    post :search, on: :collection
  end
  resources :categories, only: [:show]
end
