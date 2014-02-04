Myflix::Application.routes.draw do
  root to: 'pages#index'

  get 'ui(/:action)', controller: 'ui'
  get :home, to: 'pages#index'

  resources :videos, only: [:show] do
    post :search, on: :collection
  end
  resources :categories, only: [:show]
end
