# frozen_string_literal: true

class CalculateOrderFeesService < ApplicationService
  private

  def initialize(merchant, start_date: nil, end_date: nil)
    @merchant = merchant

    @start_date = start_date
    @end_date = end_date
  end

  def call
    orders.find_in_batches do |batch|
      upsertable_batch = batch.map do |item|
        item.fees = calculate_fees(item.amount)

        item.attributes
      end

      Order.upsert_all(upsertable_batch, update_only: %i[fees])
    end
  end

  def calculate_fees(amount)
    return amount * 0.001 if amount < 50
    return amount * 0.00085 if amount >= 300

    amount * 0.00095
  end

  def orders
    @orders ||= begin
      query = Order.where(fees: nil)

      return query if @start_date.nil? || @end_date.nil

      query.where(created_at: start_date..end_date)
    end

  end
end
