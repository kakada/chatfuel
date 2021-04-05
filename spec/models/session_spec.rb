# == Schema Information
#
# Table name: sessions
#
#  id                  :bigint(8)        not null, primary key
#  last_interaction_at :datetime
#  platform_name       :string           default("")
#  session_type        :string           default("")
#  status              :integer(4)       default("incomplete")
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  district_id         :string
#  province_id         :string
#  session_id          :string           not null
#
require 'rails_helper'

RSpec.describe Session, type: :model do
  # Attributes
  it { is_expected.to have_attribute(:engaged_at) }
  it { is_expected.to have_attribute(:gender) }
  it { is_expected.to have_attribute(:last_interaction_at) }
  it { is_expected.to have_attribute(:platform_name) }
  it { is_expected.to have_attribute(:repeated) }
  it { is_expected.to have_attribute(:session_type) }
  it { is_expected.to have_attribute(:district_id) }
  it { is_expected.to have_attribute(:province_id) }
  it { is_expected.to have_attribute(:session_id) }
  it { is_expected.to have_attribute(:source_id) }
  it { is_expected.to have_attribute(:feedback_province_id) }
  it { is_expected.to have_attribute(:feedback_district_id) }
  it { is_expected.to define_enum_for(:status).with_values(%i[incomplete completed]) }

  # Associations
  it { is_expected.to have_many(:trackings) }
  it { is_expected.to have_many(:step_values) }

  # Validations
  context 'Within validation' do
    let(:session) { build(:session) }

    it { is_expected.to validate_presence_of(:session_id) }
    it { is_expected.to validate_presence_of(:source_id) }

    context 'when :platform_name is nil' do
      it 'validates :platform_name' do
        session.platform_name = nil
        expect(session).to be_invalid  
      end
    end

    context 'when :platform_name is invalid' do
      it 'validates :platform_name' do
        session.platform_name = 'INVALID_PLATFORM'
        expect(session).to be_invalid  
      end
    end

    context 'when :platform_name is valid' do
      it 'validates :platform_name' do
        session.platform_name = 'Messenger'
        expect(session).to be_valid  
      end
    end
  end

  describe ".create_or_return" do
    
    let(:session_id) { '194105222020' }

    context "when session is empty" do
      it "create a new session" do
        expect {
          described_class.create_or_return("Messenger", session_id)
        }.to(change { Session.count })
      end
    end

    context "when sessions is present" do
      let!(:oldest_incomplete) { create(:session, :messenger, :incomplete, session_id: session_id, engaged_at: 3.day.ago) }
      let!(:completed) { create(:session, :messenger, :completed, session_id: session_id, engaged_at: 2.day.ago) }
      let!(:latest_incomplete) { create(:session, :messenger, :incomplete, session_id: session_id, engaged_at: 1.day.ago) }

      context "when the last session has completed status" do
        before { latest_incomplete.completed! }

        it "clones when starts new session" do
          new_session = described_class.create_or_return("Messenger", session_id)
          new_session.reload

          expect(new_session).to be_persisted
          expect(new_session.id).to be > latest_incomplete.id
        end

        context "when district_id is nil, re-select province_id" do
          it "clones new session" do
            latest_incomplete.update(district_id: nil)

            new_session = described_class.create_or_return("Messenger", session_id)

            expect(new_session).to be_persisted
            expect(new_session.district_id).to be_nil
            expect(new_session.province_id).to eq latest_incomplete.province_id
          end
        end
      end

      context "when the last session has incomplete status" do
        it "cannot clone" do
          expect {
            described_class.create_or_return('Messenger', session_id)
          }.not_to change { Session.count }
        end

        it "return old session" do
          new_session = described_class.create_or_return('Messenger', session_id)
          
          expect(new_session).to eq latest_incomplete
        end
      end
    end
  end

  describe "#completed?" do
    let(:session) { build(:session) }

    it "is not complete" do
      expect(session).to be_incomplete
    end
  end

  describe "#last_completed" do
    let!(:session1) { create(:session, :messenger, :completed, :kamrieng) }
    let!(:session2) { create(:session, :messenger, :incomplete, session_id: 2) }
    let!(:session3) { create(:session, :messenger, session_id: session1.session_id) }

    it "#last_completed" do
      expect(session3.last_completed).to eq(session1)
    end
  end

  describe "#clone" do
    let!(:gender) { create(:variable, :gender) }
    let!(:district) { create(:variable, :district) }

    it "clones relations" do
      old_session = create(:session, :kamrieng, gender: 'male')
      old_session.completed!

      new_session = create(:session)
      allow(new_session).to receive(:last_completed_before).and_return old_session

      expect {
        new_session.clone
      }.to change { StepValue.count }
    end
  end

  describe "set_province_id" do
    let(:session) { create(:session, district_id: "03122345") }

    it "extracts province_id from district_id before update" do
      session.update(district_id: "01234567")

      expect(session.reload.province_id).to eq("01")
    end
  end
end
