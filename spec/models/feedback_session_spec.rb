require "rails_helper"

RSpec.describe FeedbackSession do
  let(:from_date) { Date.current.beginning_of_month }
  let(:to_date) { Date.current.at_end_of_month }

  describe ".missing" do
    context "without feedback variable" do
      it "raises when no feedback variable" do
        expect {
          described_class.missing(from_date, to_date)
        }.to raise_error "feedback variable must be present"
      end
    end

    context "with feedback variable" do
      let(:feedback_step) { create(:feedback_step) }
      let(:feedback_province_step) { create(:feedback_province_step) }
      let(:feedback_district_step) { create(:feedback_district_step) }

      let!(:missing_feedback_location) { create(:session, feedback_province_id: nil, step_values: [feedback_step, feedback_province_step, feedback_district_step]) }

      context "with wrong date format" do
        it "raises error" do
          expect {
            described_class.missing '2021', '2022'
          }.to raise_error FeedbackSession::WrongDateFormatError
        end
      end

      context "with from_date greater than to_date" do
        it "raises error" do
          expect {
            described_class.missing to_date, from_date
          }.to raise_error FeedbackSession::InvalidDateError
        end
      end
      
      it "returns missing feedback location" do
        expect(described_class.missing(from_date, to_date)).to include missing_feedback_location
      end

      it "exists in step values" do
        expect(StepValue.all).to contain_exactly(feedback_step, feedback_province_step, feedback_district_step)
      end
    end
  end
end
