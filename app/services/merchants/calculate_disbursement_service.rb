# frozen_string_literal: true

class CalculateDisbursementService < ApplicationService
  private

  def initialize(merchant, disbursement_date: nil)
    @merchant = merchant
    @disbursement_date ||= DateTime.current
  end

  def call
    calculate_orders_fees

    ActiveRecord::Base.transaction do
      @disbursement = create_disbursement

      update_orders
    end
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

  def activity_day
    @activity_day ||= @disbursement_date - 1
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
