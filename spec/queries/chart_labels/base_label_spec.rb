require "rails_helper"

RSpec.describe ChartLabels::BaseLabel do
  describe "#instance" do
    let(:raw_label) { "Jan/2020" }

    it "is kind of MonthLabel" do
      klazz = described_class.new(:month, raw_label)

      expect(klazz.instance).to be_instance_of ChartLabels::MonthLabel
    end

    it "is kind of QuarterLabel" do
      klazz = described_class.new(:quarter, raw_label)

      expect(klazz.instance).to be_instance_of ChartLabels::QuarterLabel
    end

    it "is kind of YearLabel" do
      klazz = described_class.new(:year, raw_label)

      expect(klazz.instance).to be_instance_of ChartLabels::YearLabel
    end
  end
end
