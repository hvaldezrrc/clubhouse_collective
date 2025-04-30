class CheckoutController < ApplicationController
  before_action :authenticate_user!
  before_action :load_cart_items

  def address
    @address = current_user.address || current_user.build_address
    @provinces = Province.order(:name)
  end

  def create_address
    @address = current_user.address || current_user.build_address

    if @address.update(address_params)
      session[:checkout_address_id] = @address.id
      redirect_to checkout_payment_path
    else
      @provinces = Province.order(:name)
      render :address
    end
  end

  def payment
    unless current_user.address
      redirect_to checkout_address_path, alert: "Please provide your address first"
      return
    end

    @address = current_user.address
    @province = @address.province

    @subtotal = calculate_subtotal

    if @province.respond_to?(:gst) && @province.respond_to?(:pst) && @province.respond_to?(:hst)
      @gst_rate = @province.gst || 0
      @pst_rate = @province.pst || 0
      @hst_rate = @province.hst || 0
    else
      @gst_rate = 5
      @pst_rate = 0
      @hst_rate = 0

      Rails.logger.warn("Province #{@province.name} doesn't have tax rates defined")
    end

    @gst_amount = @subtotal * (@gst_rate / 100.0)
    @pst_amount = @subtotal * (@pst_rate / 100.0)
    @hst_amount = @subtotal * (@hst_rate / 100.0)

    @total = @subtotal + @gst_amount + @pst_amount + @hst_amount
  end

  def confirm
    if !current_user.address || !session[:payment_method]
      redirect_to checkout_address_path, alert: "Please complete all previous checkout steps"
      return
    end

    @address = current_user.address
    @province = @address.province
    @payment_method = session[:payment_method]

    @order = Order.find_or_create_by(user: current_user, address: @address)
    @subtotal = calculate_subtotal

    # Tax calculations
    @gst_rate = @province.gst || 5
    @pst_rate = @province.pst || 0
    @hst_rate = @province.hst || 0
    @gst_amount = @subtotal * (@gst_rate / 100.0)
    @pst_amount = @subtotal * (@pst_rate / 100.0)
    @hst_amount = @subtotal * (@hst_rate / 100.0)

    @total = @subtotal + @gst_amount + @pst_amount + @hst_amount
  end

  def process_payment
    if params[:payment_method].blank?
      flash.now[:alert] = "Please select a payment method"
      payment
      render :payment
      return
    end

    session[:payment_method] = params[:payment_method]

    redirect_to checkout_confirm_path
  end

  def complete
    unless current_user.address && session[:payment_method]
      redirect_to checkout_address_path, alert: "Please complete all previous checkout steps"
      return
    end

    full_address = "#{current_user.address.street}, #{current_user.address.city}, #{current_user.address.province.code} #{current_user.address.postal_code}"

    tax_amount = calculate_tax_amount

    @order = Order.new(
      user_id: current_user.id,
      status: "pending",
      payment_method: session[:payment_method],
      total_amount: calculate_total,
      address: full_address,
      tax_amount: tax_amount
    )

    @cart_items.each do |item|
      @order.order_items.build(
        product_id: item[:id],
        price: item[:price],
        quantity: item[:quantity]
      )
    end

    if @order.save(validate: false)
      session[:completed_order_id] = @order.id

      session[:cart] = []

      redirect_to checkout_show_complete_path
    else
      flash[:alert] = "There was a problem creating your order: #{@order.errors.full_messages.join(', ')}"
      redirect_to checkout_confirm_path
    end
  end

  def show_complete
    @order = Order.find_by(id: session[:completed_order_id])

    unless @order
      redirect_to root_path, alert: "Order not found"
      nil
    end
  end

  private

  def address_params
    params.require(:address).permit(:street, :city, :province_id, :postal_code)
  end

  def load_cart_items
    @cart_items = []
    return if session[:cart].blank?

    session[:cart].each do |item|
      product = Product.find_by(id: item["id"] || item[:id])
      next unless product

      @cart_items << {
        id: product.id,
        name: product.name,
        price: product.price.to_f,
        quantity: item["quantity"].to_i || item[:quantity].to_i,
        product: product
      }
    end
  end

  def calculate_subtotal
    @cart_items.sum { |item| item[:price] * item[:quantity] }
  end

  def calculate_tax_amount
    subtotal = calculate_subtotal

    province = current_user.address.province
    gst_rate = province.respond_to?(:gst) ? (province.gst || 0) : 5
    pst_rate = province.respond_to?(:pst) ? (province.pst || 0) : 0
    hst_rate = province.respond_to?(:hst) ? (province.hst || 0) : 0

    gst_amount = subtotal * (gst_rate / 100.0)
    pst_amount = subtotal * (pst_rate / 100.0)
    hst_amount = subtotal * (hst_rate / 100.0)

    gst_amount + pst_amount + hst_amount
  end

  def calculate_total
    subtotal = calculate_subtotal
    tax_amount = calculate_tax_amount

    subtotal + tax_amount
  end
end
