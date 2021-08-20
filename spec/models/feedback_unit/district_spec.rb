require 'rails_helper'

RSpec.describe FeedbackUnit::District do
  describe '#feedback_province_id' do
    context 'when district_id present' do
      it 'knows feedback_province_id of komrieng' do
        unit = described_class.new(district_id: 'komrieng')
        expect(unit.feedback_province_id).to eq '02'
      end

      it 'knows feedback_province_id of other' do
        unit = described_class.new(district_id: 'other')
        expect(unit.feedback_province_id).to eq '02'
      end

      context 'when district_id blank' do
        it 'knows feedback_province_id of other' do
          unit = described_class.new(district_id: '')
          expect(unit.feedback_province_id).to eq ''
        end
      end
    end
  end

  describe '#feedback_district_id' do
    context 'when district_id present' do
      it 'knows feedback_district_id of mong russei' do
        unit = described_class.new(district_id: 'mong russei')
        expect(unit.feedback_district_id).to eq '0206'
      end

      it 'knows feedback_district_id of other' do
        unit = described_class.new(district_id: 'other')
        expect(unit.feedback_district_id).to eq '0200'
      end
    end

    context 'when district_id blank' do
      it 'knows feedback_district_id of other' do
        unit = described_class.new(district_id: '')
        expect(unit.feedback_district_id).to be_nil
      end
    end
  end
end
