require 'rails_helper'

RSpec.describe DashboardQuery.new do
  it "#province_codes" do
    ENV['PILOT_PROVINCE_CODES']="01"

    expect(subject.province_codes).to eq ["01"]
  end

  it "#district_codes" do
    ENV['PILOT_PROVINCE_CODES']="01"
    ENV['PILOT_DISTRICT_CODES_FOR_01']="0102,0103"

    expect(subject.district_codes).to eq ["0102", "0103"]
  end

  describe "#most_requested_services" do
    context "WITHOUT most_request variable" do
      it "returns empty hash" do
        expect(subject.most_requested_services).to eq({})
      end
    end

    context "WITH most_request variable" do
      let(:variable) { build(:variable) }

      it "returns hash that include :colors, :dataset as keys" do
        allow(Variable).to receive(:most_request).and_return(variable)
        expect(subject.most_requested_services).to include(:colors, :dataset)
      end
    end
  end

  describe "#gender_info" do
    it "returns hash that include :colors, :dataset as keys" do
      expect(subject.gender_info).to include(:colors, :dataset)
    end
  end

  describe "#access_info" do
    let(:variable) { build(:variable) }
    let(:message) { build(:message, :text) }
    let(:step_value) { create(:step_value, message: message, variable: variable) }

    it "returns hash that include :colors, :dataset as keys" do
      allow(Variable).to receive(:service_accessed).and_return(variable)
      expect(subject.access_info).to include(:colors, :dataset)
    end
  end

  describe "#access_main_service" do
    context "WITHOUT service_accessed variable" do
      it "returns empty hash" do
        expect(subject.access_main_service).to eq({})
      end
    end

    context "WITH service_accessed variable" do
      let(:variable) { build(:variable) }

      it "returns hash that include :colors, :dataset as keys" do
        allow(Variable).to receive(:service_accessed).and_return(variable)
        expect(subject.access_main_service).to include(:colors, :dataset)
      end
    end
  end

  describe "#most_tracked_periodic" do
    it "returns hash that include :colors, :dataset as keys" do
      expect(subject.most_tracked_periodic).to include(:colors, :dataset)
    end
  end

  describe "#ticket_tracking_by_genders" do
    it "returns hash that include :colors, :dataset as keys" do
      expect(subject.ticket_tracking_by_genders).to include(:colors, :dataset)
    end
  end

  describe "#feedback_trend" do
    context "WITHOUT feedback variable" do
      it "returns empty hash" do
        expect(subject.feedback_trend).to eq({})
      end
    end

    context "WITH feedback variable" do
      let(:variable) { build(:variable) }

      it "returns hash that include :labels, :dataset as keys" do
        allow(Variable).to receive(:feedback).and_return(variable)
        expect(subject.feedback_trend).to include(:labels, :dataset)
      end
    end
  end

  describe "#overall_rating" do
    context "WITHOUT feedback variable" do
      it "returns empty hash" do
        expect(subject.overall_rating).to eq({})
      end
    end

    context "WITH feedback variable" do
      let(:variable) { build(:variable) }

      it "returns hash that include :labels, :dataset as keys" do
        allow(Variable).to receive(:feedback).and_return(variable)
        expect(subject.overall_rating).to include(:labels, :dataset)
      end
    end
  end

  describe "#feedback_sub_categories" do
    context "WITHOUT feedback variable" do
      it "returns empty hash" do
        expect(subject.feedback_sub_categories).to eq({})
      end
    end

    xcontext "WITH feedback variable" do
      let(:variable) { build(:variable) }

      it "returns hash that include :labels, :dataset as keys" do
        allow(Variable).to receive(:feedback).and_return(variable)
        expect(subject.feedback_sub_categories).to include(:labels, :dataset)
      end
    end
  end

  context "with most request" do
    let(:variable) { build(:variable) }

    before do
      allow(Variable).to receive(:most_request).and_return(variable)
      allow(variable).to receive(:agg_value_count).and_return({ 2 => 2, 1 => 1 })
    end

    it "#most_requested_service" do
      expect(variable).to receive(:transform_key_result).and_return({ key: "value_name", value: 2 })

      subject.most_requested_service
    end
  end
end