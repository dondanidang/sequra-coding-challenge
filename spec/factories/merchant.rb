# frozen_string_literal: true

FactoryBot.define do
  factory :merchant do
    reference { SecureRandom.hex(4) }
    email { Faker::Internet.email }
    minimum_monthly_fee { 0.0 }
    disbursement_frequency { %w[WEEKLY DAILY].sample }

    trait :with_weekly_disbursement do
      disbursement_frequency { 'WEEKLY' }
    end

    trait :with_daily_disbursement do
      disbursement_frequency { 'DAILY' }
    end
  end
end
