ActiveAdmin.register Product do
  permit_params :name, :description, :category_id, :sku, :stock_quantity, images: []

  member_action :delete_image, method: :delete do
    @image = ActiveStorage::Attachment.find(params[:image_id])
    @image.purge
    redirect_back(fallback_location: admin_product_path(resource), notice: "Image was successfully deleted")
  end

  index do
    selectable_column
    id_column
    column :name
    column :sku
    column :category do |product|
      link_to product.category.name, admin_category_path(product.category) if product.category
    end
    column :stock_quantity
    column "Image" do |product|
      if product.images.attached?
        image_tag url_for(product.images.first), style: "height: 50px; width: auto;"
      end
    end
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
      f.input :category, as: :select, collection: Category.all.map { |c| [ c.name, c.id ] },
              input_html: { class: "chosen-select" },
              prompt: "Select a Category"
      f.input :sku
      f.input :stock_quantity
      f.input :images, as: :file, input_html: { multiple: true }

      if f.object.images.attached?
        div class: "panel" do
          h3 "Current Images"
          div class: "panel_contents" do
            div class: "attributes_table" do
              table do
                f.object.images.each do |image|
                  tr do
                    td do
                      image_tag url_for(image), style: "height: 100px; width: auto;"
                    end
                    td do
                      if f.object.persisted?
                        link_to "Delete", delete_image_admin_product_path(f.object, image_id: image.id),
                          method: :delete,
                          data: { confirm: "Are you sure you want to delete this image?" }
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :description
      row :category do |product|
        link_to product.category.name, admin_category_path(product.category) if product.category
      end
      row :sku
      row :stock_quantity
      row :created_at
      row :updated_at
      row :images do |product|
        if product.images.attached?
          div style: "display: flex; flex-wrap: wrap; gap: 15px;" do
            product.images.each do |image|
              div style: "text-align: center;" do
                div style: "margin-bottom: 10px;" do
                  image_tag url_for(image), style: "height: 150px; width: auto; max-width: 200px;"
                end
                div do
                  link_to "View Full Size", url_for(image), target: "_blank", class: "button"
                end
                div style: "margin-top: 5px;" do
                  link_to "Delete", delete_image_admin_product_path(product, image_id: image.id),
                    method: :delete,
                    data: { confirm: "Are you sure you want to delete this image?" },
                    class: "button"
                end
              end
            end
          end
        else
          span "No images"
        end
      end
    end
  end
end
