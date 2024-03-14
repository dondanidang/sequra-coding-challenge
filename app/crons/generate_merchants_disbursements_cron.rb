# frozen_string_literal: true

module Crons
  class GenerateMerchantsDisbursementsCron < ApplicationCron
    private

    def run
      Merchant.find_each do |merchant|
        Merchants::GenerateDisbursementsWorker.perform_async({
          merchant_id: merchant.id,
          only_last_disbursement: false
        }.to_json)
      end
    end
  end
end
