class Product < ApplicationRecord
  belongs_to :category
  has_many_attached :images

  validates :name, presence: true
  validates :sku, presence: true, uniqueness: true

  def self.ransackable_attributes(auth_object = nil)
    [ "category_id", "created_at", "description", "id", "id_value", "name", "sku", "stock_quantity", "updated_at" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "category", "images_attachments", "images_blobs" ]
  end
end
