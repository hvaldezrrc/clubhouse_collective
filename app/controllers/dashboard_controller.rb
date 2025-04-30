class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = current_user
    @address = current_user.address || current_user.build_address
  end
  def index
    @recent_orders = current_user.orders.order(created_at: :desc).limit(5)
  end

  def orders
    @orders = current_user.orders.order(created_at: :desc).page(params[:page]).per(10)
  end

  def order
    @order = current_user.orders.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to dashboard_orders_path, alert: "Order not found."
  end
end
