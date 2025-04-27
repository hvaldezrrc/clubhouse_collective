ActiveAdmin.register StaticPage do
  permit_params :title, :content

  filter :slug
  filter :title
  filter :updated_at

  index do
    selectable_column
    id_column
    column :title
    column :slug
    column :updated_at
    actions
  end

  form do |f|
    f.inputs "Page Details" do
      f.input :title
      if f.object.new_record?
        f.input :slug, hint: "This identifies the page and cannot be changed later"
      else
        f.input :slug, input_html: { disabled: true },
                hint: "Cannot be changed after creation"
      end
      f.input :content, as: :text, input_html: { rows: 20 }
    end
    f.actions
  end

  show do
    attributes_table do
      row :title
      row :slug
      row :content do |page|
        simple_format page.content
      end
      row :created_at
      row :updated_at
    end
  end

  controller do
    def self.ransackable_attributes(auth_object = nil)
      [ "content", "created_at", "id", "slug", "title", "updated_at" ]
    end

    def self.ransackable_associations(auth_object = nil)
      []
    end
  end
end
