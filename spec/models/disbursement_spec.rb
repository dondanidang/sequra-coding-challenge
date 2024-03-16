# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Disbursement, type: :model do
  subject { build(:disbursement) }

  it { is_expected.to validate_presence_of(:reference) }
  it { is_expected.to validate_presence_of(:orders_amount) }
  it { is_expected.to validate_presence_of(:merchant_paid_amount) }
  it { is_expected.to validate_presence_of(:total_fees) }
  it { is_expected.to validate_presence_of(:date) }

  it { is_expected.to validate_uniqueness_of(:reference) }

  it { is_expected.to belong_to(:merchant) }
  it { is_expected.to have_many(:orders) }
end
