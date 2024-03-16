# frozen_string_literal: true

module Merchants
  class GenerateDisbursementsService < ApplicationService
    private

    DAYS_NUMBER_BY_FREQUENCY = {
      'WEEKLY' => 7,
     'DAILY' => 1
    }.freeze

    # Initializes a new Merchants::GenerateDisbursementsService.
    #
    # merchant - The Merchant with Disbursement being generated.
    # only_last_disbursement: Boolean indicating if we should exclusively on generating the disbursement based on the
    #   current date.
    #
    def initialize(merchant, only_last_disbursement: true)
      @merchant = merchant
      @only_last_disbursement = only_last_disbursement
    end

    # Generates Merchant's disbursement.
    #
    # Return True when success.
    def call
      current_date = start_date + frequency_in_days

      calculate_orders_fees if current_date <= end_date

      while current_date.between?(start_date, end_date)
        generate_dibursement(current_date)

        current_date += frequency_in_days
      end

      true
    end

    def generate_dibursement(date)
      win_start = (date - frequency_in_days).beginning_of_day
      win_end = (date - 1).end_of_day
      orders = @merchant.orders.where(created_at: win_start..win_end)

      return if orders.empty?

      ActiveRecord::Base.transaction do
        disbursement = create_disbursement(orders, date)

        update_orders(orders, disbursement)
      end
    end

    def update_orders(orders, disbursement)
      orders.update_all(disbursement_id: disbursement.id)
    end

    def create_disbursement(orders)
      orders_amount = orders.sum(:amount)
      total_fees = orders.sum(:fees)

      Disbursement.create!(
        merchant: @merchant,
        orders_amount: orders_amount,
        merchant_paid_amount: orders_amount - total_fees,
        total_fees: total_fees,
        date: date
      )
    end

    def calculate_orders_fees
      CalculateOrdersFeesService.call(
        @merchant,
        start_date: start_date.beginning_of_day,
        end_date: (end_date - 1).end_of_day
      )
    end

    def start_date
      @start_date ||= if @only_last_disbursement
        delta = Date.current - @merchant.live_on

        return @merchant.live_on if delta < frequency_in_days

        Date.current - (delta % frequency_in_days) - frequency_in_days
      elsif last_disbursement.nil?
        @merchant.live_on
      else
        last_disbursement.date
      end
    end

    def end_date
      end_date ||= begin
        delta = Date.current - @merchant.live_on

        Date.current - (delta % frequency_in_days)
      end
    end

    def frequency_in_days
      DAYS_NUMBER_BY_FREQUENCY[@merchant.disbursement_frequency]
    end

    def last_disbursement
      return @last_disbursement if defined?(@last_disbursement)

      last_disbursement = @merchant.disbursements.order(created_at: :desc).first
    end
  end
end
