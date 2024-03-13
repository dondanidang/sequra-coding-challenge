# frozen_string_literal: true

class CalculateFeesService < ApplicationService
  private

  def initialize(merchant, disbursement_date: nil)
    @merchant = merchant
    @disbursement_date ||= DateTime.current
  end

  def call
    orders.find_in_batches do |batch|
      upsertable_batch = batch.map do |item|
        item.fees = calculate_fees(item.amount)

        item.attributes
      end
    end
  end
end
