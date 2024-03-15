# frozen_string_literal: true

class GenerateMerchantsFeesChargesCron < ApplicationCron
  private

  # Generate all fees charges for all merchants.
  #
  # Return True if success
  def run
    Merchant.find_each do |merchant|
      Merchants::CalculateFeesChargesService.call(
        merchant: merchant,
        start_date: 1.month.ago.beginning_of_month,
        end_date: 1.month.ago.end_of_month
      )
    end

    true
  end
end
