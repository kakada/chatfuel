require "rails_helper"

RSpec.describe VariablePolicy do
  subject { described_class.new(user, nil) }

  permissions :index? do
    context "being an site_ombudsman" do
      let(:user) { build(:user, :site_ombudsman) }

      it { is_expected.to forbid_action(:index) }
    end

    context "being a site admin" do
      let(:user) { build(:user, :site_admin) }

      it { is_expected.to forbid_action(:index) }
    end

    context "being a program admin" do
      let(:user) { build(:user, :program_admin) }

      it { is_expected.to forbid_action(:index) }
    end

    context "being a system admin" do
      let(:user) { build(:user, :system_admin) }

      it { is_expected.to permit_action(:index) }
    end
  end
end
