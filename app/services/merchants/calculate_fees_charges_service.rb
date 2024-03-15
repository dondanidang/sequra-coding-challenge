# frozen_string_literal: true

module Merchants
  class CalculateFeesChargesService < ApplicationService
    private

    # Initializes a new Merchants::CalculateFeesChargesService.
    #
    # merchant - The Merchant with fees charges being calculated.
    # start_date - The Date representing the beginning the time window to consider.
    # end_date - The Date representing the end of the time window to consider.
    #   In the current implentation we are assume that both are given or we don't consider any if one is missing.
    #
    def initialize(merchant, start_date: nil, end_date: nil)
      @merchant = merchant

      @start_date = if start_date.nil? || end_date.nil?
                      nil
                    else
                      start_date
                    end

      @end_date = if start_date.nil? || end_date.nil?
                    nil
                  else
                    end_date
                  end
    end

    # calculate the Merchant's fees charges.
    #
    # Return True when succes.
    def call
      current_date = start_date
      insertable_fees_charges = []

      while current_date < end_date
        insertable_fees_charge = generate_fees_charge(current_date, current_date.end_of_month)

        insertable_fees_charges << insertable_fees_charge unless insertable_fees_charge[:outstanding_fees].zero?

        current_date = current_date + 1.month
      end

      FeesCharge.insert_all(insertable_fees_charges)

      true
    end

    def generate_fees_charge(win_start, win_end)
      collected_fees = @merchant.disbursements
        .where(created_at: win_start..win_end)
        .sum(:total_fees)

      outstanding_fees = [0, @merchant.minimum_monthly_fee - collected_fees].max

      {
        collected_fees: collected_fees,
        outstanding_fees: outstanding_fees,
        merchant_id: @merchant.id,
        date: win_end + 1
      }
    end

    def start_date
      @start_date ||= Disbursement
        .where(merchant: @merchant)
        .order(created_at: :asc)
        .first
        .created_at
        .beginning_of_month
    end

    def end_date
      @end_date ||= Disbursement
        .where(merchant: @merchant)
        .order(created_at: :asc)
        .last
        .created_at
        .end_of_month
    end
  end
end
