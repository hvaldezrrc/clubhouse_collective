class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def self.ransackable_attributes(auth_object = nil)
  [ "admin", "created_at", "email", "first_name", "id", "id_value", "last_name", "phone", "updated_at" ]
  end

  def self.ransackable_associations(auth_object = nil)
  [ "addresses", "orders", "reviews" ]
  end
end
