ActiveAdmin.register Category do
  permit_params :name, :description

  index do
    selectable_column
    id_column
    column :name
    column :description do |category|
      truncate(category.description, length: 100)
    end
    column :created_at
    actions
  end

  filter :name
  filter :created_at

  form do |f|
    f.inputs "Category Details" do
      f.input :name
      f.input :description, as: :text
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :description
      row :created_at
      row :updated_at
    end

    panel "Products in this Category" do
      table_for category.products do
        column :id
        column :name
        column :sku
        column :stock_quantity
        column do |product|
          links = []
          links << link_to("View", admin_product_path(product))
          links << link_to("Edit", edit_admin_product_path(product))
          links.join(" | ").html_safe
        end
      end
    end
    active_admin_comments
  end
end
