ActiveAdmin.register Product do
    permit_params :name, :description, :category_id, :sku, :stock_quantity

    index do
      selectable_column
      id_column
      column :name
      column :sku
      column :category
      column :stock_quantity
      column :created_at
      actions
    end

    filter :name
    filter :sku
    filter :category
    filter :stock_quantity
    filter :created_at

    form do |f|
      f.inputs "Product Details" do
        f.input :name
        f.input :description, as: :text
        f.input :category
        f.input :sku
        f.input :stock_quantity
      end
      f.actions
    end

    show do
      attributes_table do
        row :id
        row :name
        row :description
        row :category
        row :sku
        row :stock_quantity
        row :created_at
        row :updated_at
      end
      active_admin_comments
  end
end
