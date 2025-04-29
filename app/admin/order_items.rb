ActiveAdmin.register OrderItem do
  belongs_to :order

  permit_params :order_id, :product_id, :quantity, :price

  index do
    selectable_column
    id_column
    column :product
    column :quantity
    column :price do |item|
      number_to_currency(item.price)
    end
    column "Subtotal" do |item|
      number_to_currency(item.price * item.quantity)
    end
    actions
  end
end
