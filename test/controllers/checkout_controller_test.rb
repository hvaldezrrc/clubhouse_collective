require "test_helper"

class CheckoutController < ApplicationController
  before_action :authenticate_user!
  before_action :check_cart, except: [ :show_complete ]

  def address
  end

  def create_address
    redirect_to checkout_payment_path
  end

  def payment
  end

  def process_payment
    redirect_to checkout_confirm_path
  end

  def confirm
  end

  def complete
    redirect_to checkout_show_complete_path
  end

  def show_complete
  end

  private

  def check_cart
    redirect_to cart_path if current_cart.empty?
  end
end
