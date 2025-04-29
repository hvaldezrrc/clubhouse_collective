class AddProvinceIdToAddresses < ActiveRecord::Migration[8.0]
  def change
    add_column :addresses, :province_id, :integer
  end
end
