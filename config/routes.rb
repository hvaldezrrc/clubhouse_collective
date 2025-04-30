Rails.application.routes.draw do
  # Admin routes
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # User authentication
  devise_for :users

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Root path
  root "home#index"

  # Home routes
  get "home/index"

  # Product routes
  resources :products, only: [ :index, :show ]

  # Cart routes
  get "cart", to: "cart#show"
  post "cart/add/:id", to: "cart#add", as: "cart_add"
  patch "cart/update/:id", to: "cart#update", as: "cart_update"
  delete "cart/remove/:id", to: "cart#remove_item", as: "cart_remove"
  delete "cart/empty", to: "cart#empty", as: "cart_empty"

  # Checkout routes
  get "checkout/address", to: "checkout#address", as: "checkout_address"
  post "checkout/address", to: "checkout#create_address"
  get "checkout/payment", to: "checkout#payment", as: "checkout_payment"
  post "checkout/payment", to: "checkout#process_payment"
  get "checkout/confirm", to: "checkout#confirm", as: "checkout_confirm"
  post "checkout/complete", to: "checkout#complete", as: "checkout_complete"
  get "checkout/complete", to: "checkout#show_complete", as: "checkout_show_complete"

  # Dashboard Routes
  get "dashboard", to: "dashboard#index", as: "dashboard"
  get "dashboard/orders", to: "dashboard#orders", as: "dashboard_orders"
  get "dashboard/orders/:id", to: "dashboard#order", as: "dashboard_order"

  # Static pages - keep this as the last route
  get "/:slug", to: "static_pages#show", as: "static_page"
end
