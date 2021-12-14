# == Schema Information
#
# Table name: step_values
#
#  id                :bigint(8)        not null, primary key
#  created_at        :datetime
#  updated_at        :datetime
#  message_id        :bigint(8)
#  session_id        :bigint(8)
#  site_id           :bigint(8)
#  variable_id       :bigint(8)        not null
#  variable_value_id :bigint(8)        not null
#
# Indexes
#
#  index_step_values_on_message_id         (message_id)
#  index_step_values_on_session_id         (session_id)
#  index_step_values_on_site_id            (site_id)
#  index_step_values_on_variable_id        (variable_id)
#  index_step_values_on_variable_value_id  (variable_value_id)
#
# Foreign Keys
#
#  fk_rails_...  (message_id => messages.id)
#  fk_rails_...  (session_id => sessions.id)
#  fk_rails_...  (site_id => sites.id)
#  fk_rails_...  (variable_id => variables.id)
#  fk_rails_...  (variable_value_id => variable_values.id)
#
require 'rails_helper'

RSpec.describe StepValue, type: :model do
  describe '.after_create' do
    let(:variable) { build(:variable) }
    let(:variable_value) { build(:variable_value, variable: variable) }
    let(:session) { build(:session, province_id: "01", district_id: "0101", feedback_province_id: "01", feedback_district_id: "0101") }
    let(:step_value) { build(:step_value, variable_value: variable_value, variable: variable, session: session) }

    context "when set_session_district_id" do
      before { variable_value.raw_value = '0102' }

      context "with owso's district_id" do
        before do 
          variable.mark_as = "district" 
          step_value.save
        end

        it "updates session's district_id" do
          expect(session.district_id).to eq("0102")
          expect(session.province_id).to eq("01")
        end

        it "resets sessions's district_id" do
          variable_value.raw_value = '0202'

          step_value.save

          expect(session.district_id).to eq "0202"
          expect(session.province_id).to eq "02"
        end
      end

      context "with feedback's district_id" do
        before do 
          variable.mark_as = "feedback_district" 
          step_value.save
        end

        it "updates session's feedback_district_id" do
          expect(session.feedback_district_id).to eq("0102")
          expect(session.feedback_province_id).to eq("01")
        end

        it "resets sessions's feedback_district_id" do
          variable_value.raw_value = '0202'

          step_value.save

          expect(session.feedback_district_id).to eq "0202"
          expect(session.feedback_province_id).to eq "02"
        end
      end
    end

    context "when set_session_province_id" do
      before { variable_value.raw_value = "01" }

      context "when re-select different province" do
        let(:district_step) { build(:district_step) }
        let(:province_step) { build(:province_step) }
        let(:new_province) { build(:variable_value, variable: province_step.variable) }

        before do
          session.step_values = [district_step, province_step]
        end

        it "contains district and province step" do
          expect(session.step_values).to eq [district_step, province_step]
        end

        describe "update location steps" do
          before do
            province_step.update(variable_value: new_province)
            session.save
          end

          it "removes district step" do
            expect(session.reload.step_values).to eq [province_step]
          end

          it "updates province step" do
            expect(session.reload.step_values[0].variable_value).to eq new_province
          end
        end
      end

      context "when re-select different feedback province" do
        let(:feedback_district_step) { build(:feedback_district_step) }
        let(:feedback_province_step) { build(:feedback_province_step) }
        let(:new_feedback_province) { build(:variable_value, variable: feedback_province_step.variable) }

        before do
          session.step_values = [feedback_district_step, feedback_province_step]
        end

        it "contains feedback district and feedback province step" do
          expect(session.step_values).to eq [feedback_district_step, feedback_province_step]
        end

        describe "update feedback location steps" do
          before do
            feedback_province_step.update(variable_value: new_feedback_province)
            session.save
          end

          it "removes feedback district step" do
            expect(session.reload.step_values).to eq [feedback_province_step]
          end

          it "updates feedback province step" do
            expect(session.reload.step_values[0].variable_value).to eq new_feedback_province
          end
        end
      end

      context "with owso's province_id" do
        before do
          variable.mark_as = "province"
          step_value.save
        end

        it "updates session's province_id" do
          expect(session.district_id).to eq "0101"
          expect(session.province_id).to eq "01"
        end

        it "resets sessions's province_id" do
          variable_value.raw_value = "02"

          step_value.save

          expect(session.district_id).to be_nil
          expect(session.province_id).to eq "02"
        end
      end

      context "with feedback's province_id" do
        before do
          variable.mark_as = "feedback_province"
          step_value.save
        end
        
        it "updates session's feedback_province_id" do
          expect(session.feedback_district_id).to eq "0101"
          expect(session.feedback_province_id).to eq "01"
        end

        it "resets sessions's feedback_province_id" do
          variable_value.raw_value = "02"

          step_value.save

          expect(session.feedback_district_id).to be_nil
          expect(session.feedback_province_id).to eq "02"
        end
      end
    end

    context "when set_session_gender" do
      it "returns male" do
        variable_value.raw_value = 'm'
        variable.mark_as = "gender"

        step_value.save

        expect(session.gender).to eq('male')
      end
    end
  end

  describe ".most_recent" do
    let(:variable) { build(:variable) }
    let(:first_value) { build(:variable_value, id: 1) }
    let(:last_value) { build(:variable_value, id: 2) }

    before do
      create(:step_value, variable: variable, variable_value: first_value)
      create(:step_value, variable: variable, variable_value: last_value)
    end

    it "return lastest step_value" do
      most_recent = described_class.most_recent

      expect(most_recent.length).to eq 1
      expect(most_recent.first.variable_value).to eq last_value
    end
  end

  describe ".create_tracking" do
    let(:variable) { build(:variable, mark_as: 'ticket_tracking') }
    let(:variable_value) { build(:variable_value, variable: variable) }

    it ".create_tracking" do
      expect {
        StepValue.create! variable: variable, variable_value: variable_value, message: build(:message), session: build(:session)
      }.to change { Tracking.count }.by 1
    end
  end

  describe "callback bulk update" do
    let(:feedback_province) { build(:variable, name: 'feedback_province', mark_as: 'feedback_province') }
    let(:bmc) { build(:variable_value, variable: feedback_province, raw_value: '01') }
    let(:btb) { build(:variable_value, variable: feedback_province, raw_value: '02') }
    let(:session) { create(:session) }

    before do
      session.save
    end

    it "update session's feedback province id" do
      create(:step_value, session_id: session.id, variable: feedback_province, variable_value: bmc)

      expect(session.reload.feedback_province_id).to eq(bmc.raw_value)
    end

    100.times.each do
      it "does batch updates" do
        step_value = build(:step_value, session_id: session.id, variable: feedback_province, variable_value: btb)

        step_value.save

        expect(session.reload.feedback_province_id).to eq btb.raw_value
      end
    end
  end
end
