class AddOnSaleToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :on_sale, :boolean
  end
end
