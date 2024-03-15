# frozen_string_literal: true

FactoryBot.define do
  factory :fees_charge do
    merchant

    collected_fees { Faker::Number.decimal(l_digits: 1, r_digits: 2) }
    outstanding_fees { merchant.minimum_monthly_fee - collected_fees }
    date { 1.month.ago.beginning_of_month }
  end
end
