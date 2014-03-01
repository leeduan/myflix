Myflix::Application.routes.draw do
  root to: 'pages#front'
  get 'ui(/:action)', controller: 'ui'
  get '/front', to: 'pages#front'
  get '/home', to: 'videos#index'
  get '/signin', to: 'sessions#new'
  post '/signin', to: 'sessions#create'
  get '/signout', to: 'sessions#destroy'
  get '/getstarted', to: 'users#new'
  get '/my_queue', to: 'queue_items#index'
  post '/my_queue', to: 'queue_items#update_queue'
  get '/people', to: 'relationships#index'
  get '/forgot_password', to: 'forgot_passwords#new'
  get '/confirm_password_reset', to: 'forgot_passwords#confirm'
  get '/expired_token', to: 'reset_passwords#expired'

  resources :videos, only: [:show] do
    post :search, on: :collection
    resources :reviews, only: [:create]
  end
  resources :users, only: [:create, :show]
  resources :categories, only: [:show]
  resources :queue_items, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
  resources :forgot_passwords, only: [:create]
  resources :reset_passwords, only: [:show, :update]
end
