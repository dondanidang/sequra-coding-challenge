# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    merchant

    amount { Faker::Number.decimal(l_digits: 3, r_digits: 2) }

    trait :disbursed do
      transient do
        fees { nil }
      end

      after(:create) do |order, _evaluator|
        fees ||= order.amount * 0.001

        disbursement = create(
          disbursement:,
          merchant: order.merchant,
          orders_amount: order.amount,
          merchant_paid_amount: order.amount - fees,
          total_fees: fees
        )

        order.update!(disbursement: disbursement, fees: fees)
      end
    end
  end
end
