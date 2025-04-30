class CreateShippingAddresses < ActiveRecord::Migration[8.0]
  def change
    create_table :shipping_addresses do |t|
      t.string :street
      t.string :city
      t.string :postal_code
      t.references :province, null: false, foreign_key: true
      t.references :order, null: false, foreign_key: true

      t.timestamps
    end
  end
end
