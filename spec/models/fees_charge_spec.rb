# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FeesCharge, type: :model do
  subject { build(:fees_charge) }

  it { is_expected.to validate_presence_of(:collected_fees) }
  it { is_expected.to validate_presence_of(:outstanding_fees) }
  it { is_expected.to validate_presence_of(:date) }

  it { is_expected.to validate_uniqueness_of(:date).scoped_to(:merchant_id).case_insensitive }

  it { is_expected.to belong_to(:merchant) }
end
