Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users

  # Home routes
  get "home/index"

  get "up" => "rails/health#show", as: :rails_health_check

  # Product routes
  resources :products, only: [ :index, :show ]

  # Root path to products
  root "home#index"

  # Static pages route
  get "/:slug", to: "static_pages#show"
end
