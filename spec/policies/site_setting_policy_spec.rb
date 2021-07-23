require 'rails_helper'

RSpec.describe SiteSettingPolicy do
  subject { described_class.new(user, build(:site_setting, :do_report)) }

  context "being an site_ombudsman" do
    let(:user) { build(:user, :site_ombudsman) }

    it { is_expected.to forbid_action(:create) }
    it { is_expected.to forbid_action(:update) }
  end

  context "being a site admin" do
    let(:user) { build(:user, :site_admin) }

    it { is_expected.to forbid_action(:create) }
    it { is_expected.to forbid_action(:update) }
  end

  context "being a system admin" do
    let(:user) { build(:user, :system_admin) }

    it { is_expected.to permit_action(:create) }
    it { is_expected.to permit_action(:update) }
  end
end
