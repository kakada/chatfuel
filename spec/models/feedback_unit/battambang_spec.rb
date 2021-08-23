require 'rails_helper'

RSpec.describe FeedbackUnit::Battambang do
  describe '#feedback_province_id' do
    context 'when district_id present' do
      it 'knows feedback_province_id of tmor kol' do
        unit = described_class.new(district_id: 'Thma Koul')
        expect(unit.feedback_province_id).to eq '02'
      end

      it 'knows feedback_province_id of other' do
        unit = described_class.new(district_id: 'Other districts (Beside piloting districts)')
        expect(unit.feedback_province_id).to eq '00'
      end
    end
  end

  describe '#feedback_district_id' do
    context 'when district_id present' do
      it 'knows feedback_district_id of tmor kol' do
        unit = described_class.new(district_id: 'Thma Koul')
        expect(unit.feedback_district_id).to eq '0202'
      end

      it 'knows feedback_district_id of other' do
        unit = described_class.new(district_id: 'Other districts (Beside piloting districts)')
        expect(unit.feedback_district_id).to eq '0000'
      end
    end
  end
end
