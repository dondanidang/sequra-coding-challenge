# frozen_string_literal: true

# Disbursement model
class FeesCharge < ApplicationRecord
  include Moneyable
  with_money_on  :collected_fees, :outstanding_fees

  belongs_to :merchant, inverse_of: :fees_charges

  validates :date, :collected_fees, :outstanding_fees, presence: true
  validates :date, uniqueness: {scope: :merchant_id, case_sensitive: false}
end
