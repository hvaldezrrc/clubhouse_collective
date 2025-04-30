class Order < ApplicationRecord
  scope :pending, -> { where(status: "pending") }
  scope :processing, -> { where(status: "processing") }
  scope :shipped, -> { where(status: "shipped") }
  scope :delivered, -> { where(status: "delivered") }
  scope :cancelled, -> { where(status: "cancelled") }

  belongs_to :user
  belongs_to :shipping_address, class_name: "Address", optional: true
  belongs_to :billing_address, class_name: "Address", optional: true
  has_many :order_items, dependent: :destroy

  validates :status, presence: true
  validates :total_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :status, presence: true, inclusion: { in: [ "pending", "paid", "failed" ] }

  def order_number
    "ORD-#{id.to_s.rjust(8, '0')}"
  end

  def subtotal
    if tax_amount.present?
      total_amount - tax_amount
    else
      order_items.sum { |item| item.price * item.quantity }
    end
  end

  def gst_amount
    tax_amount.to_f * 0.5
  end

  def pst_amount
    tax_amount.to_f * 0.5
  end

  def hst_amount
    0.0
  end
end
