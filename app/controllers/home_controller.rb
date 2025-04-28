class HomeController < ApplicationController
  def index
    @featured_products = Product.order("RANDOM()").limit(4) # Show 4 random products
  end
end
