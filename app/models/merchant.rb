# frozen_string_literal: true

# Merchant model
class Merchant < ApplicationRecord
  has_many :orders, inverse_of: :merchant
  has_many :disbursements, inverse_of: :merchant

  validates :reference, uniqueness: true
  validates :email, uniqueness: true
  validates :reference, :email, :disbursement_frequency, :minimum_monthly_fee, presence: true
end
