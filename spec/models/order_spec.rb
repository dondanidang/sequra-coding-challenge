# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Order, type: :model do
  it { is_expected.to belong_to(:merchant) }
  it { is_expected.to belong_to(:disbursement).optional }
end
