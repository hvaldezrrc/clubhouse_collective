class ProductsController < ApplicationController
  def index
    @categories = Category.all
    @products = Product.all.includes(:category)

    if params[:category_id].present?
      @products = @products.where(category_id: params[:category_id])
      @current_category = Category.find_by(id: params[:category_id])
    end

    @products = @products.order(created_at: :desc)
  end

  def show
    @product = Product.find(params[:id])
    @related_products = Product.where(category_id: @product.category_id)
                              .where.not(id: @product.id)
                              .limit(4)
  end
end
