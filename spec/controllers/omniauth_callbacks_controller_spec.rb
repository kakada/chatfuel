require 'rails_helper'
require_relative '../support/shared/omniauth.rb'

RSpec.describe OmniauthCallbacksController do
  include_context "shared omniauth"

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  it "redirects to dashboard path" do
    request.env["omniauth.auth"] = auth

    get :instedd

    expect(response).to redirect_to(dashboard_path)
    expect(flash[:notice]).to match /success/
  end
end
