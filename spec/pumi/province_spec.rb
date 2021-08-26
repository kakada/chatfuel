require 'rails_helper'

RSpec.describe Pumi::Province do
  subject { Pumi::Province }
  
  pilot_provinces = ENV['PILOT_PROVINCE_CODES'].to_s.split(',')

  before do
    ENV['PILOT_PROVINCE_CODES'] = '01,02,04,08'
  end

  it ".pilots" do
    expect(subject.pilots.map(&:id)).to eq(pilot_provinces)
  end

  pilot_provinces.each do |province_code|
    context "with #{province_code}" do
      let(:province) { subject.find_by_id(province_code) }

      it '#pilot_districts' do
        district_codes = ENV["PILOT_DISTRICT_CODES_FOR_#{province_code}"].to_s.split(',')
        expect(province.pilot_districts.map(&:id)).to eq(district_codes.reverse)
      end
    end
  end
end
