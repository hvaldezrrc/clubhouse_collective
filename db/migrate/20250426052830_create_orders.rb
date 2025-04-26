class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.string :order_number
      t.string :status
      t.decimal :total_amount
      t.decimal :shipping_cost
      t.decimal :tax_amount
      t.string :payment_method
      t.references :shipping_address, foreign_key: { to_table: :addresses }
      t.references :billing_address, foreign_key: { to_table: :addresses }

      t.timestamps
    end
  end
end
