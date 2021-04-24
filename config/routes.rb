Rails.application.routes.draw do
  devise_for :users
  root to: "main#index"
  resources :discussions do
    resources :posts, only: [:create, :edit, :update, :show, :destroy], module: :discussions
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  mount Attractor::Rails::Engine, at: "/attractor" if Rails.env.development?
end
