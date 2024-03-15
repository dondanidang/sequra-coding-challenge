# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GenerateMerchantsFeesChargesCron do
  describe '.run' do
    subject(:run) do
      described_class.run
    end

    let!(:merchant) { create(:merchant) }

    it 'places merchant jobs to generate disbursements' do
      Timecop.freeze("2024-04-15".to_datetime) do
        expect(Merchants::CalculateFeesChargesService)
          .to receive(:call)
          .with(
            merchant: merchant,
            start_date: "2024-03-01".to_date.beginning_of_day,
            end_date: "2024-03-31".to_date.end_of_day
          )

        run
      end
    end
  end
end
