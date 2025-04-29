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

  # Cart routes
  get "cart", to: "cart#show"
  post "cart/add/:id", to: "cart#add", as: "cart_add"
  patch "cart/update/:id", to: "cart#update", as: "cart_update"
  delete "cart/remove/:id", to: "cart#remove_item", as: "cart_remove"
  delete "cart/empty", to: "cart#empty", as: "cart_empty"

  # Static pages route
  get "/:slug", to: "static_pages#show"
end
