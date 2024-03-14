# frozen_string_literal: true

module Merchants
  class CalculateOrdersFeesService < ApplicationService
    private

    # Initializes a new Merchants::CalculateOrdersFeesService.
    #
    # merchant - The Merchant with Orders'fees being calculated.
    # start_date - The Date representing the beginning the time window to consider.
    # end_date - The Date representing the end of the time window to consider.
    #   In the current implentation we are assume that both are given or we don't consider any if one is missing.
    #
    def initialize(merchant, start_date: nil, end_date: nil)
      @merchant = merchant

      @start_date = start_date
      @end_date = end_date
    end

    # Computes fees for the Merchant'orders.
    #
    # Return True when succes.
    def call
      orders.find_in_batches do |batch|
        upsertable_batch = batch.map do |item|
          item.fees = calculate_fees(item.amount)

          item.attributes
        end

        Order.upsert_all(upsertable_batch, update_only: %i[fees])

        true
      end
    end

    def calculate_fees(amount)
      return amount * 0.01 if amount < 50
      return amount * 0.0085 if amount >= 300

      amount * 0.0095
    end

    def orders
      @orders ||= begin
        query = Order.where(fees: nil)

        return query if @start_date.nil? || @end_date.nil?

        query.where(created_at: @start_date..@end_date)
      end
    end
  end
end
