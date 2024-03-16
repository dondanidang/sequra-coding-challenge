# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Merchants::CalculateFeesChargesService do
  describe '.call' do
    subject(:calculate) do
      described_class.call(merchant, start_date: start_date, end_date: end_date)
    end

    let(:merchant) { create(:merchant, minimum_monthly_fee: minimum_monthly_fee) }
    let(:minimum_monthly_fee) { 10 }

    let(:start_date) { "2024-04-01".to_date.beginning_of_month }
    let(:end_date) { "2024-04-01".to_date.end_of_month }

    before do
      create(
        :disbursement,
        merchant: merchant,
        total_fees: 4,
        date: "2024-04-05".to_date
      )
    end

    it 'calculates fees_charge' do
      expect { calculate }.to change { FeesCharge.count }.by(1)

      fees_charge = FeesCharge.last

      aggregate_failures do
        expect(fees_charge).to have_attributes(
          merchant_id: merchant.id,
          collected_fees: 4,
          outstanding_fees: 6,
          date: "2024-05-01".to_date
        )
      end
    end

    context 'when there is minimum_monthly_fee is 0' do
      let(:minimum_monthly_fee) { 0 }

      it 'does not create a FeeCharge' do
        expect { calculate }.to not_change { FeesCharge.count }
      end
    end

    context 'when start_date and end_date are both nil' do
      let(:start_date) { nil }

      before do
        create(
          :disbursement,
          merchant: merchant,
          total_fees: 9,
          date: "2024-02-05".to_date
        )
      end

      it 'calculates all fees_charges' do
        expect { calculate }.to change { FeesCharge.count }.by(3)

        first_fees_charge = FeesCharge.order(date: :asc).first
        second_fees_charge = FeesCharge.order(date: :asc).second
        last_fees_charge = FeesCharge.order(date: :asc).third

        aggregate_failures do
          expect(last_fees_charge).to have_attributes(
            merchant_id: merchant.id,
            collected_fees: 4,
            outstanding_fees: 6,
            date: "2024-05-01".to_date
          )

          expect(second_fees_charge).to have_attributes(
            merchant_id: merchant.id,
            collected_fees: 0,
            outstanding_fees: 10,
            date: "2024-04-01".to_date
          )

          expect(first_fees_charge).to have_attributes(
            merchant_id: merchant.id,
            collected_fees: 9,
            outstanding_fees: 1,
            date: "2024-03-01".to_date
          )
        end
      end
    end
  end
end
