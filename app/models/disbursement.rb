# frozen_string_literal: true

# Disbursement model
class Disbursement < ApplicationRecord
  after_initialize :set_defaults

  belongs_to :merchant, inverse_of: :disbursements
  has_many :orders, inverse_of: :disbursement

  validates :reference, :orders_amount, :merchant_paid_amount, :total_fees, presence: true
  validates :reference, uniqueness: true

  private def set_defaults
    self.reference ||= SecureRandom.hex(16)
  end
end
