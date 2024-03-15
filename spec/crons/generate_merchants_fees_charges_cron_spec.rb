# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GenerateMerchantsDisbursementsCron do
  describe '.run' do
    subject(:run) do
      described_class.run
    end

    let!(:merchant) { create(:merchant) }

    it 'places merchant jobs to generate disbursements' do
      expect(Merchants::GenerateDisbursementsWorker)
        .to receive(:perform_async)
        .with({ merchant_id: merchant.id, only_last_disbursement: false }.to_json)

      run
    end
  end
end
