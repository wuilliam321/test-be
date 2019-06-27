Rails.application.routes.draw do
  get 'dashboard/index'

  resources :searches
  resources :settings
  resources :sessions
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'

  root 'dashboard#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
