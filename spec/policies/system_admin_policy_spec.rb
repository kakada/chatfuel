require 'rails_helper'

RSpec.describe SystemAdminPolicy do
  subject { described_class.new(user) }

  context "being an site_ombudsman" do
    let(:user) { build(:user, :site_ombudsman) }

    it { is_expected.to forbid_action(:show) }
  end

  context "being a site admin" do
    let(:user) { build(:user, :site_admin) }

    it { is_expected.to forbid_action(:show) }
  end

  context "being a program admin" do
    let(:user) { build(:user, :program_admin) }

    it { is_expected.to forbid_action(:show) }
  end

  context "being a system admin" do
    let(:user) { build(:user, :system_admin) }

    it { is_expected.to permit_action(:show) }
  end

end
