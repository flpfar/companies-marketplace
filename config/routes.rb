Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }
  resources :users, only: [:edit, :update]
  resources :sale_posts, only: [:show, :new, :create]
  root to: 'home#index'
end
