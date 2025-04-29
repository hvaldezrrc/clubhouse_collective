ActiveAdmin.register Order do
  permit_params :user_id, :subtotal, :gst_amount, :pst_amount, :hst_amount, :total_amount, :status, :shipping_address_id

  filter :id
  filter :user
  filter :status
  filter :total_amount
  filter :created_at

  scope :all
  scope :pending
  scope :processing
  scope :shipped
  scope :delivered
  scope :cancelled

  index do
    selectable_column
    id_column
    column :user
    column :status
    column :total_amount do |order|
      number_to_currency(order.total_amount)
    end
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :user
      row :status
      row :shipping_address do |order|
        if order.shipping_address
          address = order.shipping_address
          "#{address.street}, #{address.city}, #{address.province.code} #{address.postal_code}"
        end
      end
      row :subtotal do |order|
        number_to_currency(order.subtotal)
      end
      row :gst_amount do |order|
        number_to_currency(order.gst_amount)
      end
      row :pst_amount do |order|
        number_to_currency(order.pst_amount)
      end
      row :hst_amount do |order|
        number_to_currency(order.hst_amount)
      end
      row :total_amount do |order|
        number_to_currency(order.total_amount)
      end
      row :created_at
      row :updated_at
    end

    panel "Order Items" do
      table_for order.order_items do
        column :product
        column :quantity
        column :price do |item|
          number_to_currency(item.price)
        end
        column :subtotal do |item|
          number_to_currency(item.price * item.quantity)
        end
      end
    end
  end

  form do |f|
    f.inputs "Order Details" do
      f.input :user
      f.input :status, as: :select, collection: %w[pending processing shipped delivered cancelled]
      f.input :shipping_address
      f.input :subtotal
      f.input :gst_amount
      f.input :pst_amount
      f.input :hst_amount
      f.input :total_amount
    end
    f.actions
  end

  member_action :change_status, method: :put do
    order = Order.find(params[:id])
    order.update(status: params[:status])
    redirect_to admin_order_path(order), notice: "Status updated to #{order.status}!"
  end

  action_item :process_order, only: :show, if: proc { resource.status == "pending" } do
    link_to "Process Order", change_status_admin_order_path(status: "processing"), method: :put
  end

  action_item :ship_order, only: :show, if: proc { resource.status == "processing" } do
    link_to "Ship Order", change_status_admin_order_path(status: "shipped"), method: :put
  end

  action_item :deliver_order, only: :show, if: proc { resource.status == "shipped" } do
    link_to "Mark as Delivered", change_status_admin_order_path(status: "delivered"), method: :put
  end

  action_item :cancel_order, only: :show, if: proc { ![ "cancelled", "delivered" ].include?(resource.status) } do
    link_to "Cancel Order", change_status_admin_order_path(status: "cancelled"), method: :put, data: { confirm: "Are you sure you want to cancel this order?" }
  end
end
