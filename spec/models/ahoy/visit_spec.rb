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

    context "when huge visits cause inappropriate request" do
      let(:ips) { ['0.0.0.0', '1.1.1.1'] }

      let!(:ip_1_visit_1) { create(:visit, ip: ips.first, started_at: DateTime.current) }
      let!(:ip_1_visit_2) { create(:visit, ip: ips.first, started_at: ip_1_visit_1.started_at + 1.minute) }
      let!(:ip_1_visit_3) { create(:visit, ip: ips.first, started_at: ip_1_visit_1.started_at + 22.minute) }
      let!(:ip_1_visit_4) { create(:visit, ip: ips.first, started_at: ip_1_visit_1.started_at + 35.minute) }

      let!(:ip_2_visit_1) { create(:visit, ip: ips.second, started_at: DateTime.current) }
      let!(:ip_2_visit_2) { create(:visit, ip: ips.second, started_at: ip_2_visit_1.started_at + 32.minute) }
      let!(:ip_2_visit_3) { create(:visit, ip: ips.second, started_at: ip_2_visit_1.started_at + 41.minute) }

      context "with 20 minutes duration" do
        let(:duplicate_ids_within_20_minutes) do
          described_class.\
            from(DateTime.current.beginning_of_month).\
            duplicate_ids_within_period(duration: 20)
        end

        it ".clear" do
          expect {
            described_class.clear(duplicate_ids_within_20_minutes)
          }.to change { described_class.count }.by ( 
            -duplicate_ids_within_20_minutes.count
          )
        end

        it "keeps remaining visits over 20 minutes" do
          described_class.clear(duplicate_ids_within_20_minutes)

          expect(described_class.ids).to eq [ip_1_visit_1.id, ip_1_visit_3.id, ip_2_visit_1.id, ip_2_visit_2.id]
        end
      end


      context "with 30 minutes duration" do
        let(:duplicate_ids_within_30_minutes) do
          described_class.\
            from(DateTime.current.beginning_of_month).\
            duplicate_ids_within_period(duration: 30)
        end

        it ".clear" do
          expect {
            described_class.clear(duplicate_ids_within_30_minutes)
          }.to change { described_class.count }.by -duplicate_ids_within_30_minutes.count
        end

        it "keeps remaining visits over 30 minutes" do
          described_class.clear(duplicate_ids_within_30_minutes)

          expect(described_class.ids).to eq [ip_1_visit_1.id, ip_1_visit_4.id, ip_2_visit_1.id, ip_2_visit_2.id]
        end
      end
    end
  end
end
