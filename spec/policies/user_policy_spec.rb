require "rails_helper"

RSpec.describe UserPolicy do
  subject { described_class.new(user, record) }

  let(:resolved_scope) do
    described_class::Scope.new(user, User.all).resolve
  end

  permissions :new? do
    let(:record) { build(:user) }

    context "being an site_ombudsman" do
      let(:user) { build(:user, :site_ombudsman) }

      it { is_expected.to forbid_action(:new) }
    end

    context "being a site admin" do
      let(:user) { build(:user, :site_admin) }

      it { is_expected.to forbid_action(:new) }
    end

    context "being a program admin" do
      let(:user) { build(:user, :program_admin) }

      it { is_expected.to forbid_action(:new) }
    end

    context "being a system admin" do
      let(:user) { build(:user, :system_admin) }

      it { is_expected.to permit_action(:new) }
    end
  end

  permissions :create? do
    let(:record) { build(:user) }

    context "being an site_ombudsman" do
      let(:user) { build(:user, :site_ombudsman) }

      it { is_expected.to forbid_action(:create) }
    end

    context "being a site admin" do
      let(:user) { build(:user, :site_admin) }

      context "create site_ombudsman" do
        let(:record) { build(:user, :site_ombudsman) }

        it { is_expected.to forbid_action(:create) }
      end

      context "create site admin" do
        let(:record) { build(:user, :site_admin) }

        it { is_expected.to forbid_action(:create) }
      end

      context "create program admin" do
        let(:record) { build(:user, :program_admin) }

        it { is_expected.to forbid_action(:create) }
      end

      context "create system admin" do
        let(:record) { build(:user, :system_admin) }

        it { is_expected.to forbid_action(:create) }
      end
    end

    context "being a program admin" do
      let(:user) { build(:user, :program_admin) }

      context "create site_ombudsman" do
        let(:record) { build(:user, :site_ombudsman) }

        it { is_expected.to forbid_action(:create) }
      end

      context "create site admin" do
        let(:record) { build(:user, :site_admin) }

        it { is_expected.to forbid_action(:create) }
      end

      context "create program admin" do
        let(:record) { build(:user, :program_admin) }

        it { is_expected.to forbid_action(:create) }
      end

      context "create system admin" do
        let(:record) { build(:user, :system_admin) }

        it { is_expected.to forbid_action(:create) }
      end
    end

    context "being a system admin" do
      let(:user) { build(:user, :system_admin) }

      context "create site_ombudsman" do
        let(:record) { build(:user, :site_ombudsman) }

        it { is_expected.to permit_action(:create) }
      end

      context "create site admin" do
        let(:record) { build(:user, :site_admin) }

        it { is_expected.to permit_action(:create) }
      end

      context "create program admin" do
        let(:record) { build(:user, :program_admin) }

        it { is_expected.to permit_action(:create) }
      end
    end
  end

  permissions ".scope" do
    let(:new_user) { create(:user, :site_ombudsman) }

    context "site admin" do
      let(:user) { create(:user, :site_admin) }

      it "includes created user" do
        expect(resolved_scope).to include(new_user)
      end
    end

    context "program admin" do
      let(:user) { create(:user, :program_admin) }

      it "includes created user" do
        expect(resolved_scope).to include(new_user)
      end
    end

    context "system admin" do
      let(:user) { create(:user, :system_admin) }

      it "includes created user" do
        expect(resolved_scope).to include(new_user)
      end
    end
  end
end
