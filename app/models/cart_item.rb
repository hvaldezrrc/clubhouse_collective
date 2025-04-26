class CartItem < ApplicationRecord
  belongs_to :shopping_cart
  belongs_to :product
  belongs_to :product_variant
end
