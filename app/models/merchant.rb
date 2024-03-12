# frozen_string_literal: true

# Merchant model
class Merchant < ApplicationRecord
  has_many :orders
  has_many :disbursements

  validates :reference, uniqueness: true
  validates :name, presence: true
  validates :email, uniqueness: true
end
