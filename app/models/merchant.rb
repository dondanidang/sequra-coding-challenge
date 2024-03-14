# frozen_string_literal: true

# Merchant model
class Merchant < ApplicationRecord
  DISBURSEMENT_FREQUENCIES = {
    daily: 'DAILY',
    weekly: 'WEEKLY'
}.freeze

  has_many :orders, inverse_of: :merchant
  has_many :disbursements, inverse_of: :merchant

  validates :reference, uniqueness: true
  validates :email, uniqueness: true
  validates :reference, :email, :disbursement_frequency, :minimum_monthly_fee, presence: true

  validates :disbursement_frequency, inclusion: { in: DISBURSEMENT_FREQUENCIES.values }, allow_nil: false
end
