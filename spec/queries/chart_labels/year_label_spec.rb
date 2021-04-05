require "rails_helper"

RSpec.describe ChartLabels::YearLabel do
  describe "#format" do
    let(:raw_label) { "Jan/2020" }

    it "formats `yyyy`" do
      label = described_class.new(raw_label)

      expect(label.format).to eq "2020"
    end
  end
end
