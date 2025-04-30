class AddAddressToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :address, :text
  end
end
