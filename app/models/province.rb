class Province < ApplicationRecord
  has_one :tax_rate, dependent: :destroy
  has_many :addresses

  validates :name, :code, presence: true
  validates :code, uniqueness: true

  def self.ransackable_attributes(auth_object = nil)
    [ "code", "created_at", "id", "name", "updated_at" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "addresses", "tax_rate" ]
  end
end
