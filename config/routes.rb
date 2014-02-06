Myflix::Application.routes.draw do
  root to: 'pages#front'
  get 'ui(/:action)', controller: 'ui'
  get '/home', to: 'categories#index'
  get '/front', to: 'pages#front'
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
