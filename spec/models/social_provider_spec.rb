require "rails_helper"

RSpec.describe SocialProvider do
  it { is_expected.to have_attribute(:provider_name) }
  
  context "WITHOUT :provider_name" do
    let(:social_provider) { build(:social_provider) }

    it "is invalid" do
      expect(social_provider).to be_invalid
    end
  end

  context "WITH :provider_name" do
    let(:social_provider) { build(:social_provider, provider_name: "facebook") }

    it "is valid" do
      expect(social_provider).to be_valid
    end

    it "is invalid" do
      social_provider.provider_name = "invalid_site"
      expect(social_provider).to be_invalid
    end
  end
end
