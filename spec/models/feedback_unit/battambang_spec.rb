require 'rails_helper'

RSpec.describe FeedbackUnit::Battambang do
  describe '#feedback_province_id' do
    context 'when district_id present' do
      it 'knows feedback_province_id of tmor kol' do
        unit = described_class.new(district_id: 'tmor kol')
        expect(unit.feedback_province_id).to eq '02'
      end

      it 'knows feedback_province_id of other' do
        unit = described_class.new(district_id: 'other')
        expect(unit.feedback_province_id).to eq '02'
      end
    end
  end

  describe '#feedback_district_id' do
    context 'when district_id present' do
      it 'knows feedback_district_id of tmor kol' do
        unit = described_class.new(district_id: 'tmor kol')
        expect(unit.feedback_district_id).to eq '0202'
      end

      it 'knows feedback_district_id of other' do
        unit = described_class.new(district_id: 'other')
        expect(unit.feedback_district_id).to eq '0200'
      end
    end
  end
end
