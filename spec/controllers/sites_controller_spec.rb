require "rails_helper"

RSpec.describe SitesController, type: :controller do
  setup_system_admin

  it "GET :index" do
    get :index

    expect(response).to render_template("index")
  end

  it "GET :show" do
    get :show, params: { id: create(:site).id }

    expect(response).to render_template("show")
  end

  it "POST :create" do
    expect do
      post :create, params: { site: { name: "new site", code: "0212" } }
    end.to change { Site.count }.by(1)
  end

  describe "POST :import" do
    context "success" do
      it "attach a file" do
        expect do
          post :import, params: { site: { file: fixture_file_upload(file_path("site.csv"), "image/png") } }
        end.to change { Site.count }
      end
    end

    context "fail" do
      it "does not attach a file" do
        expect do
          post :import
        end.not_to change { Site.count }
      end
    end

  end

  context "updates" do
    let(:kamrieng) { create(:site, name: "kamrieng", code: "0212") }

    it "PUT :update" do
      put :update, params: { id: kamrieng.id, site: { name: "bavil", code: "0211" } }

      updated = assigns(:site)

      expect(updated.name).to eq "bavil"
      expect(updated.code).to eq "0211"
    end
  end

  context "destroy" do
    before do
      @kamrieng = create(:site, name: "kamrieng")
    end

    it "DELETE :destroy" do
      expect do
        delete :destroy, params: { id: @kamrieng.id }
      end.to change { Site.count }.by(-1)
    end
  end
end
