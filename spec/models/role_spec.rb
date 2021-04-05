# == Schema Information
#
# Table name: roles
#
#  id         :bigint(8)        not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "rails_helper"

RSpec.describe Role, type: :model do
  it { is_expected.to have_many(:users) }
  it { is_expected.to have_many(:role_variables) }
  it { is_expected.to have_many(:variables).through(:role_variables) }

  describe "constants" do
    let(:role_names) { %w(guest site_ombudsman site_admin system_admin) }

    it "defines ROLE_NAMES" do
      expect(described_class::ROLE_NAMES).to eq role_names
    end
  end

  describe "validations" do
    let(:new_role) { build(:role, name: "system_admin") }
    before { create(:role, name: "system_admin") }

    context "uniqueness" do
      it "is invalid" do
        expect(new_role).to be_invalid
      end

      it "is valid" do
        new_role.name = "site_admin"
        expect(new_role).to be_valid
      end
    end

    context "inclusion" do
      it "is included" do
        new_role.name = "site_ombudsman"
        expect(new_role).to be_valid
      end

      it "is excluded" do
        invalid_role_name = "invalid_role_name"
        new_role.name = invalid_role_name

        expect(new_role).to be_invalid
        expect(new_role.errors[:name]).to eq ["#{invalid_role_name} is not a valid role name"]
      end
    end
  end

  describe "methods" do
    let(:role) { build(:role) }
    let(:system_admin) { build(:role, name: "system_admin") }
    let(:site_admin) { build(:role, name: "site_admin") }
    let(:site_ombudsman) { build(:role, name: "site_ombudsman") }

    it "#system_admin?" do
      role.name = "system_admin"

      expect(role.system_admin?).to be_truthy
    end

    it "#site_admin?" do
      role.name = "site_admin"

      expect(role.site_admin?).to be_truthy
    end

    it "#site_ombudsman?" do
      role.name = "site_ombudsman"

      expect(role.site_ombudsman?).to be_truthy
    end

    describe "#position_level" do
      it "expects system_admin > site admin" do
        expect(system_admin.position_level).to be > site_admin.position_level
      end

      it "expects site admin > site ombudsman" do
        expect(site_admin.position_level).to be > site_ombudsman.position_level
      end
    end
  end
end
