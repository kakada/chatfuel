require 'rails_helper'

RSpec.describe PdfTemplatesController, type: :controller do
  setup_system_admin

  before do
    @pdf_template = create(:pdf_template)
  end

  it "GET :index" do
    get :index
    expect(assigns[:pdf_templates]).to eq [@pdf_template]
  end

  it "GET #new" do
    get :new
    expect(response).to render_template(:new)
  end

  it "GET :show" do
    get :show, params: { id: @pdf_template.id }
    expect(assigns[:pdf_template]).to eq @pdf_template
  end

  it "POST :create" do
    expect do
      post :create, params: { pdf_template: { name: 'My pdf template', content: 'pdf template content', lang_code: 'km' } }
    end.to change { PdfTemplate.count }.by 1
  end

  it "PUT :update" do
    put :update, params: { id: @pdf_template.id, pdf_template: { name: 'new template'} }
    
    @pdf_template.reload
    expect(response).to have_http_status(:found)
    expect(response).to redirect_to(@pdf_template)
  end

  it "DELETE :destroy" do
    delete :destroy, params: { id: @pdf_template.id }
    
    expect(response).to redirect_to(pdf_templates_path)
  end
end
