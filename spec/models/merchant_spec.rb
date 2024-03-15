# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Merchant, type: :model do
  subject { build(:merchant) }

  it { is_expected.to have_many(:orders) }
  it { is_expected.to have_many(:disbursements) }
  it { is_expected.to have_many(:fees_charges) }

  it { is_expected.to validate_presence_of(:reference) }
  it { is_expected.to validate_presence_of(:disbursement_frequency) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:minimum_monthly_fee) }

  it { is_expected.to validate_uniqueness_of(:reference) }
  it { is_expected.to validate_uniqueness_of(:email) }
end
