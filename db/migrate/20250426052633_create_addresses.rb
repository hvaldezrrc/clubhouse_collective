class CreateAddresses < ActiveRecord::Migration[8.0]
  def change
    create_table :addresses do |t|
      t.references :user, null: false, foreign_key: true
      t.string :address_type
      t.string :street
      t.string :city
      t.string :province
      t.string :postal_code
      t.string :country

      t.timestamps
    end
  end
end
