require 'rails_helper'

RSpec.describe FeedbackUnit::Owsu do
  it 'knows province_id' do
    unit = described_class.new(province_id: '01')
    expect(unit.feedback_province_id).to eq '01'
    expect(unit.feedback_district_id).to eq '0199'
  end

  it 'does not knows province_id' do
    unit = described_class.new
    expect(unit.feedback_province_id).to be_nil
    expect(unit.feedback_district_id).to be_nil
  end
end
