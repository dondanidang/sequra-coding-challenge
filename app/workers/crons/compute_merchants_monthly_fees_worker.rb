# frozen_string_literal: true

module Crons
  class ComputeMerchantsMonthlyFeesWorker < ApplicationWorker
    sidekiq_options queue: :default

    def perform(_params)
      ComputeMerchantsMonthlyFeesCron.run
    end
  end
end
