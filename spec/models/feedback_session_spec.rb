require "rails_helper"

RSpec.describe FeedbackSession do
  describe ".missing" do
    context "without feedback variable" do
      it "raises when no feedback variable" do
        expect {
          described_class.missing
        }.to raise_error "feedback variable must be present"
      end
    end


    context "with feedback variable" do
      let(:feedback_province_step) { create(:feedback_province_step) }
      let(:feedback_district_step) { create(:feedback_district_step) }

      let!(:missing_feedback_location) { create(:session, feedback_province_id: nil, step_values: [feedback_province_step, feedback_district_step]) }

      before { create(:variable, :feedback) }
      
      it "returns missing feedback location" do
        expect(described_class.missing).to include missing_feedback_location
      end

      it "exists in step values" do
        expect(StepValue.all).to contain_exactly(feedback_province_step, feedback_district_step)
      end
    end
  end
end
