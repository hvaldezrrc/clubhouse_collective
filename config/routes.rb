Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users

  # Static pages route
  get "/:slug", to: "static_pages#show"

  # Home routes
  get "home/index"

  get "up" => "rails/health#show", as: :rails_health_check

  # Root path
  root to: "home#index"
end
