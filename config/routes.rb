Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }
  resources :users, only: [:show, :edit, :update]
  resources :sale_posts, only: [:show, :new, :create] do
    resources :orders, only: [:create]
    resources :comments, only: [:create]
  end
  resources :orders, only: [:show] do
    member do
      post 'complete'
    end
  end

  root to: 'home#index'
end
