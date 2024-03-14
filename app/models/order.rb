# frozen_string_literal: true

# Order model
class Order < ApplicationRecord
  include Moneyable
  with_money_on  :amount, :fees

  belongs_to :merchant, inverse_of: :orders
  belongs_to :disbursement, inverse_of: :orders, optional: true
end
