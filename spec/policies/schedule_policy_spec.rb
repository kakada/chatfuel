require 'rails_helper'

RSpec.describe SchedulePolicy do
  subject { described_class.new(user, build(:schedule)) }

  context "being an site_ombudsman" do
    let(:user) { build(:user, :site_ombudsman) }

    it { is_expected.to forbid_action(:new) }
    it { is_expected.to forbid_action(:create) }
    it { is_expected.to forbid_action(:edit) }
    it { is_expected.to forbid_action(:update) }
    it { is_expected.to forbid_action(:destroy) }
  end

  context "being a site admin" do
    let(:user) { build(:user, :site_admin) }

    it { is_expected.to forbid_action(:new) }
    it { is_expected.to forbid_action(:create) }
    it { is_expected.to forbid_action(:edit) }
    it { is_expected.to forbid_action(:update) }
    it { is_expected.to forbid_action(:destroy) }
  end

  context "being a system admin" do
    let(:user) { build(:user, :system_admin) }

    context 'when schedule does not exist' do
      it { is_expected.to permit_action(:new) }
      it { is_expected.to permit_action(:create) }
    end

    context 'when schedule already exists' do
      let!(:schedule) { create(:schedule) }

      it { is_expected.to forbid_action(:new) }
      it { is_expected.to forbid_action(:create) }
    end

    it { is_expected.to permit_action(:edit) }
    it { is_expected.to permit_action(:update) }
    it { is_expected.to permit_action(:destroy) }
  end
end
