Myflix::Application.routes.draw do
  root to: 'categories#index'

  get 'ui(/:action)', controller: 'ui'
  get :home, to: 'categories#index'

  resources :videos, only: [:show] do
    post :search, on: :collection
  end
  resources :categories, only: [:show]
end
