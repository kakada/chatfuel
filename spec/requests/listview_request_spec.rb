require 'rails_helper'

RSpec.describe "Listviews", type: :request do

  describe "GET /index" do
    it "returns http success" do
      get "/listview/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /showcase" do
    it "returns http success" do
      get "/listview/showcase"
      expect(response).to have_http_status(:success)
    end
  end

end
