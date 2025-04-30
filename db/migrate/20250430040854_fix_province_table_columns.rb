class FixProvinceTableColumns < ActiveRecord::Migration[8.0]
  def change
    unless column_exists?(:provinces, :name)
      add_column :provinces, :name, :string
    end

    if column_exists?(:provinces, :string)
      remove_column :provinces, :string
    end
  end
end
