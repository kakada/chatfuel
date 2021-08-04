require 'rails_helper'

RSpec.describe SchedulesController, type: :controller do
  setup_system_admin

  before do
    @schedule = create(:schedule)
  end

  it "GET :index" do
    get :index
    expect(assigns[:schedules]).to eq [@schedule]
  end

  it "GET #new" do
    @schedule.destroy
    get :new
    expect(assigns[:schedule]).to be_a_new(Schedule)
  end

  
  it "POST :create" do
    Schedule.destroy_all
    expect do
      post :create, params: { schedule: { name: 'My schedule', day: '1', time: '01:00' } }
    end.to change { Schedule.count }.by 1
  end

  it "PUT :update" do
    put :update, params: { id: @schedule.id, schedule: { name: 'New schedule'} }
    
    expect(response).to have_http_status(:found)
    expect(response).to redirect_to(schedules_path)
  end

  it "DELETE :destroy" do
    delete :destroy, params: { id: @schedule.id }
    
    expect(response).to redirect_to(schedules_path)
  end
end
