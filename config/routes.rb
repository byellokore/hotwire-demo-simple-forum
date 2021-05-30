Rails.application.routes.draw do
  resources :categories
  devise_for :users
  root to: "main#index"
  resources :discussions do
    resources :posts, only: [:create, :edit, :update, :show, :destroy], module: :discussions

    collection do
      get "category/:id", to: "categories/discussions#index", as: :category
    end

    resources :notifications, only: :create, module: :discussions


  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  mount Attractor::Rails::Engine, at: "/attractor" if Rails.env.development?
end
