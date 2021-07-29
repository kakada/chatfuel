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

  #   
  describe ".create_or_return" do
    let(:session) { build(:session, :messenger, :incomplete, session_id: 1, source_id: 1) }

    context "existence" do
      it "create a new session if not exist" do
        expect {
          described_class.create_or_return("Messenger", session.session_id)
        }.to(change { Session.count })
      end

      it "returns if already created" do
        session.save!

        expect do
          described_class.create_or_return("Messenger", session.session_id)
        end.not_to(change { Session.count })
      end
    end

    xcontext "completion" do
      it "clones when starts new session" do
        old_session = create(:session, province_id: '12', district_id: '1234', session_id: 1, source_id: 1)
        old_session.completed!

        new_session = described_class.create_or_return("Messenger", old_session.session_id)
        new_session.reload

        expect(old_session.province_id).to eq(new_session.province_id)
        expect(old_session.district_id).to eq(new_session.district_id)
      end
    end
  end

  describe "#completed?" do
    let(:session) { build(:session) }

    it "is not complete" do
      expect(session).to be_incomplete
    end
  end

  xdescribe "#last_completed" do
    let(:session) { create(:session) }
    let!(:session1) { create(:session, :completed) }
    let!(:session2) { create(:session) }
    let!(:session3) { create(:session) }

    it "#last_completed" do
      byebug
      expect(session3.last_completed).to eq(session1)
    end
  end

  xdescribe "#clone" do
    let!(:gender) { create(:variable, :gender) }
    let!(:district) { create(:variable, :district) }

    it "clones relations" do
      old_session = create(:session, district_id: '0204', gender: 'male')
      old_session.completed!

      new_session = create(:session)
      allow(new_session).to receive(:last_completed_before).and_return old_session

      expect {
        new_session.clone
      }.to change { StepValue.count }
    end
  end
end
