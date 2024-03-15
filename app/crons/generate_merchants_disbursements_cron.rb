# frozen_string_literal: true

class GenerateMerchantsDisbursementsCron < ApplicationCron
  private

  # Generates all disbursements for all merchants
  #
  # Return True.
  def run
    Merchant.find_each do |merchant|
      Merchants::GenerateDisbursementsWorker.perform_async({
        merchant_id: merchant.id,
        only_last_disbursement: false
      }.to_json)
    end

    true
  end
end
