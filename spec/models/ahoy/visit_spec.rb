require 'rails_helper'

RSpec.describe Ahoy::Visit, type: :model do
  describe '.count_with_fragment' do

    context "when no visit" do
      it 'returns array of 2 numbers' do
        expect(described_class.count_with_fragment(1.month.ago, DateTime.current)).to eq [0, 0]
      end
    end

    context "when visits exist" do
      let!(:visit1) { create(:visit, started_at: 1.week.ago) }
      let!(:visit2) { create(:visit, started_at: 2.weeks.ago) }
      let!(:visit3) { create(:visit, started_at: 3.weeks.ago) }

      it 'returns array of numbers of visits and total visits' do
        expect(described_class.count_with_fragment(2.weeks.ago, DateTime.current)).to eq [2, 3]
      end
    end
  end
end
