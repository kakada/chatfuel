require "rails_helper"

RSpec.describe Filters::LocationFilter do
  describe "#display_name" do
    context "with no province, no district" do
      it "all" do
        location = Filters::LocationFilter.new([], [])
        
        expect(location.display_name).to be_nil
      end
    end

    context "with more than one province" do
      let(:province1) { Pumi::Province.find_by_id("02") }
      let(:province2) { Pumi::Province.find_by_id("04") }
      let(:provinces) { [province1, province2]}

      it "count selected provinces" do
        @location_filter = Filters::LocationFilter.new(provinces, [])

        expect(@location_filter.display_name).to eq "2 provinces selected"
      end
    end

    context "with one province" do
      let(:province) { Pumi::Province.find_by_id("02") }

      context "no district" do
        before(:each) do
          @location_filter = Filters::LocationFilter.new([province], [])
        end

        it { expect(@location_filter.display_name).to eq("Battambang") }
      end

      context "one district" do
        let(:district) { Pumi::District.find_by_id("0212") }

        before(:each) do
          @location_filter = Filters::LocationFilter.new([province], [district])
        end

        it { expect(@location_filter.display_name).to eq("Kamrieng") }
      end

      context "more than one districts" do
        let(:district_1) { Pumi::District.find_by_id("0212") }
        let(:district_2) { Pumi::District.find_by_id("0212") }
        let(:districts) { [district_1, district_2] }

        before(:each) do
          @location_filter = Filters::LocationFilter.new([province], districts)
        end

        it { expect(@location_filter.display_name).to eq("2 districts selected") }
      end

    end
  end


  describe "#described_name" do
    context "with no province, no district" do
      it "all" do
        location = Filters::LocationFilter.new([], [])
        
        expect(location.described_name).to be_nil
      end
    end

    context "with more than one province" do
      let(:province1) { Pumi::Province.find_by_id("02") }
      let(:province2) { Pumi::Province.find_by_id("04") }
      let(:provinces) { [province1, province2]}

      it "count selected provinces" do
        @location_filter = Filters::LocationFilter.new(provinces, [])

        expect(@location_filter.described_name).to eq "Battambang and Kampong Chhnang"
      end
    end

    context "with one province" do
      let(:province) { Pumi::Province.find_by_id("02") }

      context "no district" do
        before(:each) do
          @location_filter = Filters::LocationFilter.new([province], [])
        end

        it { expect(@location_filter.described_name).to be_nil }
      end

      context "one district" do
        let(:district) { Pumi::District.find_by_id("0212") }

        before(:each) do
          @location_filter = Filters::LocationFilter.new([province], [district])
        end

        it { expect(@location_filter.described_name).to be_nil }
      end

      context "more than one districts" do
        let(:district_1) { Pumi::District.find_by_id("0212") }
        let(:district_2) { Pumi::District.find_by_id("0214") }
        let(:districts) { [district_1, district_2] }

        before(:each) do
          @location_filter = Filters::LocationFilter.new([province], districts)
        end

        it { expect(@location_filter.described_name).to eq("Kamrieng and Rukh Kiri") }
      end

    end
  end
end