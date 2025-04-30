class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, presence: true, uniqueness: true

  has_one :address, dependent: :destroy
  accepts_nested_attributes_for :address

  has_many :orders
  has_many :reviews

  def self.ransackable_attributes(auth_object = nil)
    [ "admin", "created_at", "email", "first_name", "id", "id_value", "last_name", "phone", "updated_at", "username" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "addresses", "orders", "reviews" ]
  end
end
