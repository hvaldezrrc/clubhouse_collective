Rails.application.routes.draw do
  get "products/index"
  get "products/show"
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users

  # Static pages route
  get "/:slug", to: "static_pages#show"

  # Home routes
  get "home/index"

  get "up" => "rails/health#show", as: :rails_health_check

  # Product routes
  resources :products, only: [ :index, :show ]

  # Root path to products
  root "products#index"
end
