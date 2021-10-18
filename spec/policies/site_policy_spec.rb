require "rails_helper"

RSpec.describe SitePolicy do
  subject { described_class.new(user, site) }

  let(:site) { build(:site) }
  let(:site_admin_actions) { %i[index show] }
  let(:program_admin_actions) { %i[index new edit update destroy] }

  context "being a site_ombudsman" do
    let(:user) { build(:user, :site_ombudsman) }

    it { is_expected.to forbid_actions(site_admin_actions) }
  end

  context "being a site_admin" do
    let(:user) { build(:user, :site_admin) }

    it { is_expected.to forbid_actions(site_admin_actions) }
  end

  context "being a program_admin" do
    let(:user) { build(:user, :program_admin) }

    it { is_expected.to forbid_actions(site_admin_actions) }
  end

  context "being a system_admin" do
    let(:user) { build(:user, :system_admin) }

    it { is_expected.to permit_actions(program_admin_actions) }
  end
end
