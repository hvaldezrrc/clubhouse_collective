class Order < ApplicationRecord
  scope :pending, -> { where(status: "pending") }
  scope :processing, -> { where(status: "processing") }
  scope :shipped, -> { where(status: "shipped") }
  scope :delivered, -> { where(status: "delivered") }
  scope :cancelled, -> { where(status: "cancelled") }

  belongs_to :user
  belongs_to :shipping_address, class_name: "Address"
  belongs_to :billing_address, class_name: "Address"
end
