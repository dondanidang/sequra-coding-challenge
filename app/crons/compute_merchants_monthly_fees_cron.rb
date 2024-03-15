# frozen_string_literal: true

class ComputeMerchantsMonthlyFeesCron < ApplicationCron
  private

  def run
    return if Date.current != Date.current.beginning_of_month

    Merchant
      .includes(:disbursements)
      .find_in_batches do |merchants|
        insertable_batch = merchants.map do |merchant|
          collected_fees = compute_fees(merchant)
          outstanding_fees = [0, merchant.minimum_monthly_fee - collected_fees].min

          {
            collected_fees: collected_fees,
            outstanding_fees: outstanding_fees,
            merchant_id: merchant.id,
            date: Date.current
          }
        end

        MerchantFeesReport.insert_all(insertable_batch)
    end
  end

  def compute_fees(merchant)
    merchant
      .disbursements
      .where(created_at: 1.month.ago.beginning_of_month..1.month.ago.end_of_month)
      .sum(:total_fees)
  end
end
