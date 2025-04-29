class CheckoutController < ApplicationController
  before_action :initialize_cart
  before_action :load_cart_items
  before_action :ensure_cart_not_empty

  def address
    @address = session[:checkout_address] ? Address.new(session[:checkout_address]) : Address.new
    @provinces = Province.all.order(:name)
  end

  def create_address
    @address = Address.new(address_params)

    if @address.valid?
      session[:checkout_address] = address_params
      redirect_to checkout_payment_path
    else
      @provinces = Province.all.order(:name)
      render :address
    end
  end

  def payment
    unless session[:checkout_address]
      redirect_to checkout_address_path
      return
    end

    calculate_order_totals
  end

  def process_payment
    redirect_to checkout_confirm_path
  end

  def confirm
    unless session[:checkout_address]
      redirect_to checkout_address_path
      return
    end

    calculate_order_totals

    @address = Address.new(session[:checkout_address])
    @province = Province.find(session[:checkout_address][:province_id])
  end

  def complete
    address = Address.create!(session[:checkout_address])

    calculate_order_totals

    order = Order.new(
      user: current_user,
      shipping_address: address,
      subtotal: @subtotal,
      gst_amount: @gst_amount,
      pst_amount: @pst_amount,
      hst_amount: @hst_amount,
      total_amount: @total_amount,
      status: "pending"
    )

    @cart_items.each do |item|
      order.order_items.build(
        product: item[:product],
        quantity: item[:quantity],
        price: item[:product].price
      )
    end

    if order.save
      session[:cart] = []
      session[:checkout_address] = nil

      redirect_to root_path, notice: "Order placed successfully! Your order number is ##{order.id}."
    else
      redirect_to checkout_confirm_path, alert: "There was a problem placing your order."
    end
  end

  private

  def address_params
    params.require(:address).permit(:street, :city, :province_id, :postal_code)
  end

  def initialize_cart
    session[:cart] ||= []
  end

  def load_cart_items
    @cart_items = session[:cart].map do |item|
      product_id = item[:product_id] || item["product_id"]
      quantity = item[:quantity] || item["quantity"]

      if product_id.present?
        product = Product.find_by(id: product_id)
        { product: product, quantity: quantity } if product
      end
    end.compact
  end

  def ensure_cart_not_empty
    if @cart_items.empty?
      redirect_to cart_path, alert: "Your cart is empty. Please add some items before checking out."
    end
  end

  def calculate_order_totals
    province_id = session[:checkout_address][:province_id]
    @province = Province.find(province_id)
    @tax_rate = @province.tax_rate

    @subtotal = @cart_items.sum { |item| item[:product].price * item[:quantity] }

    @gst_amount = @subtotal * @tax_rate.gst
    @pst_amount = @subtotal * @tax_rate.pst
    @hst_amount = @subtotal * @tax_rate.hst

    @total_amount = @subtotal + @gst_amount + @pst_amount + @hst_amount
  end
end
