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
    column "Products Count" do |category|
      category.products.count
    end
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
        column :name do |product|
          link_to product.name, admin_product_path(product)
        end
        column :sku
        column :stock_quantity
        column "Images" do |product|
          if product.images.attached?
            image_tag url_for(product.images.first), style: "height: 50px; width: auto;"
          else
            "No image"
          end
        end
        column :created_at
      end
    end
  end

  controller do
    def self.ransackable_attributes(auth_object = nil)
      [ "created_at", "description", "id", "name", "updated_at" ]
    end

    def self.ransackable_associations(auth_object = nil)
      [ "products" ]
    end
  end
end
