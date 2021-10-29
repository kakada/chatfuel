require 'rails_helper'
require_relative '../support/shared/omniauth.rb'

RSpec.describe OmniauthCallbacksController do
  include_context "shared omniauth"

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  it "redirects to dashboard path" do
    request.env["omniauth.auth"] = auth

    expect {
      get :instedd
    }.to raise_error(OmniauthCallbacksController::Forbidden, "You are not allowed to access this page.")
  end
end
