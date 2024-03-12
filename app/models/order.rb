# frozen_string_literal: true

# Order model
class Order < ApplicationRecord
  belongs_to :merchant
end
