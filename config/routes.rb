Rails.application.routes.draw do
  get "dashboard/index"
  get "dashboard/orders"
  get "dashboard/order"
  get "checkout/address"
  get "checkout/payment"
  get "checkout/confirm"
  get "checkout/complete"
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

  # Checkout routes
  get "checkout/address", to: "checkout#address"
  post "checkout/address", to: "checkout#create_address"
  get "checkout/payment", to: "checkout#payment"
  post "checkout/payment", to: "checkout#process_payment"
  get "checkout/confirm", to: "checkout#confirm"
  post "checkout/complete", to: "checkout#complete"

  # Dashboard Routes
  get "dashboard", to: "dashboard#index"
  get "dashboard/orders", to: "dashboard#orders"
  get "dashboard/orders/:id", to: "dashboard#order", as: "dashboard_order"

  # Static pages route
  get "/:slug", to: "static_pages#show"
end
