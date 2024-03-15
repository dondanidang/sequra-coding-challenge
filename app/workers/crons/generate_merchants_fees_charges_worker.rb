# frozen_string_literal: true

module Crons
  class GenerateMerchantsFeesChargesWorker < ApplicationWorker
    sidekiq_options queue: :default

    def perform(_params)
      GenerateMerchantsFeesChargesCron.run
    end
  end
end
