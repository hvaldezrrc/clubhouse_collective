class BillingAddress < ApplicationRecord
  belongs_to :province
  belongs_to :order
end
