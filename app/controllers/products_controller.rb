class ProductsController < ApplicationController
  def index
    @categories = Category.all

    @products = Product.all

    if params[:category_id].present?
      @current_category = Category.find_by(id: params[:category_id])
      @products = @current_category ? @current_category.products : Product.none
    end

    if params[:on_sale] == "true"
      @products = @products.where(on_sale: true)
    end

    if params[:new] == "true"
      @products = @products.where("created_at >= ?", 3.days.ago)
    end

    if params[:recently_updated] == "true"
      @products = @products.where("updated_at >= ?", 3.days.ago)
    end

    if params[:new] == "true" && params[:recently_updated] == "true"
      @products = @products.where("created_at >= ?", 3.days.ago).where("updated_at < ?", 3.days.ago)
    end

    if params[:search].present?
      search_term = "%#{params[:search]}%"
      @products = @products.where("name LIKE ? OR description LIKE ?", search_term, search_term)
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
