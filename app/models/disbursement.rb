# frozen_string_literal: true

# Disbursement model
class Disbursement < ApplicationRecord
  after_initialize :set_defaults

  belongs_to :merchant
  has_many :orders

  private def set_defaults
    self.reference ||= SecureRandom.hex(16)
  end
end
