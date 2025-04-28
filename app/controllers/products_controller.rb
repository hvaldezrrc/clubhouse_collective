class ProductsController < ApplicationController
  def index
    @categories = Category.all

    if params[:category_id].present?
      @current_category = Category.find_by(id: params[:category_id])
      @products = @current_category ? @current_category.products : Product.none
    else
      @products = Product.all
    end

    @products = @products.includes(:category).order(created_at: :desc).page(params[:page]).per(20)
  end

  def show
    @product = Product.find(params[:id])
    @related_products = Product.where(category_id: @product.category_id)
                              .where.not(id: @product.id)
                              .limit(4)
  end
end
