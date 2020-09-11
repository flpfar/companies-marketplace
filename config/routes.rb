Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }
  resources :users, only: [] do
    get 'profile', on: :member
  end
  resources :sale_posts, only: [:show, :new, :create] do
    resources :orders, only: [:create]
    resources :comments, only: [:create]
    post 'disable', on: :member
    post 'enable', on: :member
    get 'search', on: :collection
  end
  resources :categories, only: [:show]
  resources :orders, only: [:show] do
    resources :messages, only: [:create]
    member do
      post 'complete'
      post 'cancel'
    end
  end
  resources :notifications, only: [] do
    post 'seen'
  end
  resource :my_account, controller: :my_account, only: [:show] do
    get :history, on: :member
    get :sale_posts, on: :member
  end

  root to: 'home#index'
end
