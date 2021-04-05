require "rails_helper"

RSpec.describe ChartLabels::QuarterLabel do
  describe "#format" do
    let(:raw_label) { "Jan/2020" }

    it "formats `Q{n}/yyyy`" do
      label = described_class.new(raw_label)

      expect(label.format).to eq "Q1/2020"
    end
  end
end
