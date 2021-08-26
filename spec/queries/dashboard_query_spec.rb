require 'rails_helper'

RSpec.describe DashboardQuery.new do
  it "#province_codes" do
    ENV['PILOT_PROVINCE_CODES']="01"

    expect(subject.province_codes).to eq ["01"]
  end

  it "#district_codes" do
    ENV['PILOT_PROVINCE_CODES']="01"
    ENV['PILOT_DISTRICT_CODES_FOR_01']="0102,0103"

    expect(subject.district_codes).to eq ["0103", "0102"]
  end

  context "with most request" do
    let(:variable) { build(:variable) }

    before do
      allow(Variable).to receive(:most_request).and_return(variable)
      allow(variable).to receive(:agg_value_count).and_return({ 2 => 2, 1 => 1 })
    end

    it "#most_requested_service" do
      expect(variable).to receive(:transform_key_result).and_return({ key: "value_name", value: 2 })

      subject.most_requested_service
    end
  end
end
