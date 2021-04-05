require "rails_helper"

RSpec.describe ChartLabels::MonthLabel do
  describe "#format" do
    let(:raw_label) { "Jan/2020" }

    it "formats `mmm/yyyy`" do
      label = described_class.new(raw_label)

      expect(label.format).to eq "Jan/2020"
    end
  end
end
