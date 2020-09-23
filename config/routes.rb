Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }
  resources :users, only: [] do
    get 'profile', on: :member
  end
  resources :sale_posts, only: [:show, :new, :create, :edit, :destroy, :update] do
    resources :orders, only: [:create]
    resources :questions, only: [:create] do
      resources :answers, only: [:create]
    end
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
  resource :dashboard, controller: :dashboard, only: [:show] do
    resources :companies, only: [:show, :new, :create] do
      resources :categories, only: [:create]
    end
  end

  namespace :api do
    namespace :v1 do
      resources :company, only: [] do
        resources :sale_posts, only: [:index]
      end
    end
  end

  root to: 'home#index'
end
