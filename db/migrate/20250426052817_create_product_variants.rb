class CreateProductVariants < ActiveRecord::Migration[8.0]
  def change
    create_table :product_variants do |t|
      t.references :product, null: false, foreign_key: true
      t.string :size
      t.string :color
      t.integer :stock_quantity

      t.timestamps
    end
  end
end
