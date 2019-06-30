Rails.application.routes.draw do
  get 'dashboard/index'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  resources :settings
  resources :sessions
  resources :searches do
    member do
      post 'restaurants'
    end
  end

  root 'dashboard#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
