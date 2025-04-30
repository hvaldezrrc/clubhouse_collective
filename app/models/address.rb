class Address < ApplicationRecord
  belongs_to :user
  belongs_to :province

  validates :street, presence: true
  validates :city, presence: true
  validates :postal_code, presence: true
  validates :province_id, presence: true

  def self.ransackable_attributes(auth_object = nil)
    [ "city", "created_at", "id", "id_value", "province_id", "street", "updated_at", "user_id", "zip" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "province", "user" ]
  end
end
