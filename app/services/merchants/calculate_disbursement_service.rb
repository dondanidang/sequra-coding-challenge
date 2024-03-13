# frozen_string_literal: true

module Merchants
  class CalculateDisbursementService < ApplicationService
    private

    DAYS_NUMBER_BY_FREQUENCY = {
      'WEEKLY' => 7,
     'DAILY' => 1
    }

    private_constant DAYS_NUMBER_BY_FREQUENCY

    def initialize(merchant, disbursement_date: nil)
      @merchant = merchant
      @disbursement_date ||= DateTime.current
    end

    def call
      return unless can_disbursement_be_done?

      calculate_orders_fees

      ActiveRecord::Base.transaction do
        @disbursement = create_disbursement

        update_orders
      end
    end

    def can_disbursement_be_done?
      return if @disbursement_date <= live_on

      true
    end

    def last_disbursement
      return @last_disbursement if defined?(@last_disbursement)

      last_disbursement = @mercant.disbursements.order(created_at: :desc).first
    end

    def create_disbursement
      Disbursement.create!(
        merchant: @merchant,
        orders_amount:,
        merchant_paid_amount:,
        total_fees:
      )
    end

    def update_orders
      orders.update_all(disbursement_id: @disbursement)
    end

    def calculate_orders_fees
      CalculateOrderFeesService.call(
        @merchant,
        start_date: activity_day.beginning_of_day,
        end_date: activity_day.end_date
      )
    end

    def orders
      @orders ||= merchant.orders.where(created_at: activity_day.all_day)
    end

    def activity_days_start
      @activity_days_start ||= (
        @disbursement_date - DAYS_NUMBER_BY_FREQUENCY[@mercant.disbursement_frequency]
      ).beginning_of_day
    end

    def activity_days_end
      @activity_days_end ||= (@disbursement_date - 1).end_of_day
    end

    def orders_amount
      @orders_amount ||= orders.sum(:amount)
    end

    def total_fees
      @fees ||= orders.sum(:fees)
    end

    def merchant_paid_amount
      orders_amount - fees
    end
  end
end
