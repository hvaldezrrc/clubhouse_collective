class CartController < ApplicationController
  before_action :initialize_cart

  def show
    load_cart_items
  end

  def add
    product_id = params[:id].to_i
    quantity = params[:quantity].present? ? params[:quantity].to_i : 1
    quantity = 1 if quantity < 1

    session[:cart] ||= []

    existing_item = session[:cart].find do |item|
      (item[:product_id] == product_id) || (item["product_id"] == product_id)
    end

    if existing_item
      if existing_item.key?(:product_id)
        existing_item[:quantity] += quantity
      else
        existing_item["quantity"] += quantity
      end
    else
      session[:cart] << { product_id: product_id, quantity: quantity }
    end

    flash[:notice] = "#{Product.find(product_id).name} added to your cart."
    redirect_back(fallback_location: cart_path)
  end

  def update
    product_id = params[:id].to_i
    quantity = params[:quantity].to_i

    item = session[:cart].find do |i|
      (i[:product_id] == product_id) || (i["product_id"] == product_id)
    end

    if item && quantity > 0
      if item.key?(:product_id)
        item[:quantity] = quantity
      else
        item["quantity"] = quantity
      end
      flash[:notice] = "Quantity updated."
    elsif item && quantity <= 0
      session[:cart].reject! do |i|
        (i[:product_id] == product_id) || (i["product_id"] == product_id)
      end
      flash[:notice] = "Item removed from cart."
    end

    redirect_to cart_path
  end

  def remove_item
    product_id = params[:id].to_i
    product = Product.find_by(id: product_id)

    session[:cart].reject! do |item|
      (item[:product_id] == product_id) || (item["product_id"] == product_id)
    end

    flash[:notice] = "#{product&.name || 'Item'} removed from cart."
    redirect_to cart_path
  end

  def empty
    session[:cart] = []
    flash[:notice] = "Your cart has been emptied."
    redirect_to cart_path
  end

  private

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

    normalized_cart = @cart_items.map do |item|
      { product_id: item[:product].id, quantity: item[:quantity] }
    end

    if normalized_cart.any?
      session[:cart] = normalized_cart
    end
  end
end
