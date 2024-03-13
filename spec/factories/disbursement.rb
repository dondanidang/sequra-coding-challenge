# frozen_string_literal: true

FactoryBot.define do
  factory :disbursement do
    merchant

    reference { SecureRandom.hex(4) }
    fees { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    merchant_paid_amount { Faker::Number.decimal(l_digits: 4, r_digits: 2) }
    orders_amount { fees + merchant_paid_amount }
  end
end
