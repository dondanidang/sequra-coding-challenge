# frozen_string_literal: true

module Crons
  class GenerateMerchantsDisbursementsWorker < ApplicationWorker
    sidekiq_options queue: :default

    def perform(_params)
      GenerateMerchantsDisbursementsCron.run
    end
  end
end
