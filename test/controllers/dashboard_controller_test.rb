class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def orders
    @orders = current_user.orders
  end

  def order
    @order = current_user.orders.find(params[:id])
  end
end
