Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }
  resources :users, only: [:show, :edit, :update] do
    get 'profile', on: :member
  end
  resources :sale_posts, only: [:show, :new, :create] do
    resources :orders, only: [:create]
    resources :comments, only: [:create]
    post 'disable', on: :member
    post 'enable', on: :member
    get 'search', on: :collection
  end
  resources :categories, only: [:index, :show]
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

  root to: 'home#index'
end
