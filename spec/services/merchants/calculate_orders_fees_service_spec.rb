# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Merchants::CalculateOrdersFeesService do
  describe '.call' do
    subject(:calculate) do
      described_class.call(merchant, start_date: start_date, end_date: end_date)
    end

    let(:merchant) { create(:merchant) }
    let!(:order) { create(:order, merchant: merchant, amount: amount, created_at: 1.day.ago) }
    let(:start_date) { nil }
    let(:end_date) { nil }
    let(:amount) { 10 }

    it 'update order fees for 1%' do
      expect { calculate }.to change { order.reload.fees }.to(0.1)
    end

    context 'when order amount is 100' do
      let(:amount) { 100 }

      it 'update order fees for 0.95%' do
        expect { calculate }.to change { order.reload.fees }.to(0.95)
      end
    end

    context 'when order amount is 1000' do
      let(:amount) { 1000 }

      it 'update order fees for 0.85%' do
        expect { calculate }.to change { order.reload.fees }.to(8.5)
      end
    end

    context 'when only start_date or end_date is provided' do
      let(:end_date) { 2.days.ago }

      it 'update order fees for 1%' do
        expect { calculate }.to change { order.reload.fees }.to(0.1)
      end
    end

    context 'when order is created outside the range provided' do
      let(:start_date) { 3.days.ago }
      let(:end_date) { 2.days.ago }

      it 'does not change fees%' do
        expect { calculate }.not_to change { order.reload.fees }
      end
    end
  end
end
