# frozen_string_literal: true

# Order model
class Order < ApplicationRecord
  belongs_to :merchant, inverse_of: :orders
  belongs_to :disbursement, inverse_of: :orders, optional: true
end
