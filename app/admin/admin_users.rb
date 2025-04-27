ActiveAdmin.register AdminUser do
  controller do
    def self.ransackable_attributes(auth_object = nil)
      AdminUser.ransackable_attributes(auth_object)
    end

    def self.ransackable_associations(auth_object = nil)
      AdminUser.ransackable_associations(auth_object)
    end
  end

  permit_params :email, :password, :password_confirmation

  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end
end
