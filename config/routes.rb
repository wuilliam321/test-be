Rails.application.routes.draw do
  get 'sessions/login'

  resources :searches
  resources :settings
  resources :sessions

  root 'dashboard#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
