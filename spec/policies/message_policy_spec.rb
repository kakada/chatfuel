require 'rails_helper'

RSpec.describe MessagePolicy do
  subject { described_class.new(user) }

  let(:resolved_scope) do
    described_class::Scope.new(user, Message.all).resolve
  end
  let(:message) { create(:message, :text) }

  context "being an site_ombudsman" do
    let(:user) { build(:user, :site_ombudsman) }

    it "not includes message in resolved scope" do
      expect(resolved_scope).to include(message)
    end
  end

  context "being a site admin" do
    let(:user) { build(:user, :site_admin) }

    it "includes message in resolved scope" do
      expect(resolved_scope).to include(message)
    end
  end

  context "being a program admin" do
    let(:user) { build(:user, :program_admin) }

    it "includes message in resolved scope" do
      expect(resolved_scope).to include(message)
    end
  end

  context "being a system admin" do
    let(:user) { build(:user, :system_admin) }

    it "includes message in resolved scope" do
      expect(resolved_scope).to include(message)
    end
  end
end
