require 'rails_helper'

RSpec.describe OmniauthCallbacksController do
  let!(:role) { create(:role, :site_ombudsman) }
  let(:auth) do
    { 
      provider: "instedd", 
      uid: "https://login.instedd.org/openid/user@instedd.org",
      info: {
        email: "user@instedd.org"
      }
    }.with_indifferent_access
  end

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  it "redirects to root path" do
    request.env["omniauth.auth"] = auth

    get :instedd

    expect(response).to redirect_to(dashboard_path)
    expect(flash[:notice]).to match /success/
  end
end
