Rails.application.routes.draw do
  resources :categories
  devise_for :users

  unauthenticated do
    root to: "main#index", as: :unauthenticated_root
  end

  authenticated do
    root to: "discussions#index"
  end

  resources :discussions do
    resources :posts, only: [:create, :edit, :update, :show, :destroy], module: :discussions

    collection do
      get "category/:id", to: "categories/discussions#index", as: :category
    end

    resources :notifications, only: :create, module: :discussions


  end

  resources :notifications, only: :index do
    collection do
      post "/mark_as_read", to: "notifications#read_all", as: :read
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  mount Attractor::Rails::Engine, at: "/attractor" if Rails.env.development?
end
