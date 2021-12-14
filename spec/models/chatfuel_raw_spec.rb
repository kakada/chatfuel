require 'rails_helper'

RSpec.describe ChatfuelRaw do
  subject { described_class.new }

  let(:chatfuel_raw) { build(:chatfuel_raw, feedback_unit: 'owso', feedback_province: '01', feedback_district: '0102') }

  it { is_expected.not_to have_feedback_location }

  it "has feedback location" do
    expect(chatfuel_raw).to have_feedback_location
  end
end
