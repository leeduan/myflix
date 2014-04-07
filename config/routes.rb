require 'sidekiq/web'
require 'admin_constraint'

Myflix::Application.routes.draw do
  root to: 'pages#front'
  get 'ui(/:action)', controller: 'ui'
  get '/front', to: 'pages#front'
  get '/expired_token', to: 'pages#expired'
  get '/home', to: 'videos#index'
  get '/signin', to: 'sessions#new'
  post '/signin', to: 'sessions#create'
  get '/signout', to: 'sessions#destroy'
  get '/getstarted', to: 'users#new'
  get '/getstarted/:token', to: 'users#new_with_invitation', as: 'register_with_token'
  get '/my_queue', to: 'queue_items#index'
  post '/my_queue', to: 'queue_items#update_queue'
  get '/people', to: 'relationships#index'
  get '/forgot_password', to: 'forgot_passwords#new'
  get '/confirm_password_reset', to: 'forgot_passwords#confirm'
  get '/invite', to: 'invitations#new'
  get '/billing', to: 'billings#index'
  post '/billing', to: 'billings#cancel'

  resources :videos, only: [:show] do
    post :search, on: :collection
    resources :reviews, only: [:create]
  end
  resources :users, only: [:create, :show, :edit, :update]
  resources :categories, only: [:show]
  resources :queue_items, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
  resources :forgot_passwords, only: [:create]
  resources :reset_passwords, only: [:show, :update]
  resources :invitations, only: [:create]

  namespace :admin do
    resources :videos, only: [:new, :create]
    resources :payments, only: [:index]
  end

  mount Sidekiq::Web, at: '/sidekiq', constraints: AdminConstraint.new
  mount StripeEvent::Engine, at: '/stripe-events'
end
