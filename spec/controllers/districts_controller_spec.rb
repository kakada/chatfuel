require "rails_helper"

RSpec.describe DistrictsController do
  context "without location" do
    it ":index" do
      get :index

      expect(response.status).to eq(200)
      expect(response.content_type).to eq("application/json; charset=utf-8")
    end
  end

  context "with location" do
    let(:value) { build(:variable_value, raw_value: "0204") }
    let!(:location) { create(:variable, :location, values: [ value ]) }

    it "is empty" do
      get :index

      expect( response.body ).to include("[]")
    end

    it "returns districts belongs to the province" do
      get :index, params: { province_id: "02" }

      expect( response.body ).to include(value.raw_value)
    end
  end
end
