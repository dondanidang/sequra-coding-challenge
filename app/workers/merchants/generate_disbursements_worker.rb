# frozen_string_literal: true

module Merchants
  class GenerateDisbursementsWorker < ApplicationWorker
    sidekiq_options queue: :default

    def perform(params)
      params = Oj.load(params).deep_symbolize_keys

      merchant = Merchant.find(params[:merchant_id])

      GenerateDisbursementsService.call(merchant, only_last_disbursement: params[:only_last_disbursement])
    end
  end
end
