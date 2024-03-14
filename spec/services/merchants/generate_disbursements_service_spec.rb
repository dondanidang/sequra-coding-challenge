# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Merchants::GenerateDisbursementsService do
  describe '.call' do
    subject(:generate) do
      described_class.call(merchant, only_last_disbursement: only_last_disbursement)
    end

    let(:merchant) { create(:merchant, live_on: live_on, disbursement_frequency: disbursement_frequency) }
    let(:only_last_disbursement) { true }
    let(:disbursement_frequency) { 'DAILY' }

    let(:order_created_at) { 1.day.ago }
    let(:live_on) { 2.days.ago.to_date }

    let!(:order) do
      create(
        :order,
        merchant: merchant,
        amount: 100,
        created_at: order_created_at
      )
    end

    it 'generates disbursement and update order' do
      expect { generate }
        .to change { Disbursement.count }.by(1)
        .and change { order.reload.fees }.to(0.95)
        .and change { order.reload.disbursement_id }

      disbursement = Disbursement.last

      aggregate_failures do
        expect(disbursement).to have_attributes(
          merchant_id: merchant.id,
          orders_amount: 100,
          total_fees: 0.95,
          merchant_paid_amount: 99.05
        )

        expect(order.reload.disbursement_id).to eq(disbursement.id)
      end
    end

    context 'when disbursement frequency is weekly' do
      let(:disbursement_frequency) { 'WEEKLY' }

      it 'does not generates disbursement nor update order' do
        expect { generate }
          .to not_change { Disbursement.count }
          .and not_change { order.reload.fees }
          .and not_change { order.reload.disbursement_id }
      end

      context 'when merchant has been live for more than a week but with no orders' do
        let(:live_on) { 10.days.ago.to_date }

        it 'does not generates disbursement nor update order' do
          expect { generate }
            .to not_change { Disbursement.count }
            .and not_change { order.reload.fees }
            .and not_change { order.reload.disbursement_id }
        end
      end
    end

    context 'when only_last_disbursement is false and there is another merchant order' do
      let(:only_last_disbursement) { false }
      let(:live_on) { 3.days.ago.to_date }

      let!(:order_2) do
        create(
          :order,
          merchant: merchant,
          amount: 10,
          created_at: 2.days.ago.to_date,
          disbursement: disbursement,
          fees: fees
        )
      end

      let(:disbursement) { nil }
      let(:fees) { nil }

      it 'generates disbursement and update order' do
        expect { generate }
          .to change { Disbursement.count }.by(2)
          .and change { order.reload.fees }.to(0.95)
          .and change { order.reload.disbursement_id }
          .and change { order_2.reload.fees }.to(0.1)
          .and change { order_2.reload.disbursement_id }

        first_disbursement = Disbursement.order(created_at: :asc).first
        last_disbursement = Disbursement.order(created_at: :asc).last

        aggregate_failures do
          expect(last_disbursement).to have_attributes(
            merchant_id: merchant.id,
            orders_amount: 100,
            total_fees: 0.95,
            merchant_paid_amount: 99.05
          )

          expect(order.reload.disbursement_id).to eq(last_disbursement.id)

          expect(first_disbursement).to have_attributes(
            merchant_id: merchant.id,
            orders_amount: 10,
            total_fees: 0.1,
            merchant_paid_amount: 9.9
          )

          expect(order_2.reload.disbursement_id).to eq(first_disbursement.id)
        end
      end

      context 'when there is existing disbursement' do
        let(:fees) { 0.1 }
        let(:disbursement) do
          create(
            :disbursement,
            merchant: merchant,
            orders_amount: 10,
            total_fees: 0.1,
            merchant_paid_amount: 9.9,
            created_at: 1.day.ago.to_date
          )
        end

        it 'only creates 1 disbursement' do
          expect { generate }
          .to change { Disbursement.count }.by(1)
          .and change { order.reload.fees }.to(0.95)
          .and change { order.reload.disbursement_id }
          .and not_change { order_2.reload.fees }
          .and not_change { order_2.reload.disbursement_id }

          new_disbursement = Disbursement.order(created_at: :asc).last

          aggregate_failures do
            expect(new_disbursement).to have_attributes(
              merchant_id: merchant.id,
              orders_amount: 100,
              total_fees: 0.95,
              merchant_paid_amount: 99.05
            )

            expect(order.reload.disbursement_id).to eq(new_disbursement.id)
          end
        end
      end
    end
  end
end
