require 'rails_helper'

RSpec.describe SettingPolicy do
  subject { described_class.new(user) }

  context "being an site_ombudsman" do
    let(:user) { build(:user, :site_ombudsman) }

    it { is_expected.to forbid_action(:index) }
    it { is_expected.to forbid_action(:show) }
    it { is_expected.to forbid_action(:help) }
    it { is_expected.to forbid_action(:telegram_bot) }
  end

  context "being a site admin" do
    let(:user) { build(:user, :site_admin) }

    it { is_expected.to forbid_action(:index) }
    it { is_expected.to forbid_action(:show) }
    it { is_expected.to forbid_action(:help) }
    it { is_expected.to forbid_action(:telegram_bot) }
  end

  context "being a program admin" do
    let(:user) { build(:user, :program_admin) }

    it { is_expected.to forbid_action(:index) }
    it { is_expected.to forbid_action(:show) }
    it { is_expected.to forbid_action(:help) }
    it { is_expected.to forbid_action(:telegram_bot) }
  end

  context "being a system admin" do
    let(:user) { build(:user, :system_admin) }

    it { is_expected.to permit_action(:index) }
    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:help) }
    it { is_expected.to permit_action(:telegram_bot) }
  end
end
