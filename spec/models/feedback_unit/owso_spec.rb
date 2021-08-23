require 'rails_helper'

RSpec.describe FeedbackUnit::Owso do
  it 'knows feedback_location' do
    unit = described_class.new(province_id: '01', district_id: '0106')
    expect(unit.feedback_province_id).to eq '01'
    expect(unit.feedback_district_id).to eq '0106'
  end

  it 'knows province_id' do
    unit = described_class.new(province_id: '01')
    expect(unit.feedback_province_id).to eq '01'
    expect(unit.feedback_district_id).to be_nil
  end

  it 'does not knows location' do
    unit = described_class.new
    expect(unit.feedback_province_id).to be_nil
    expect(unit.feedback_district_id).to be_nil
  end
end
