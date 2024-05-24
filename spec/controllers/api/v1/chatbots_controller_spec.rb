require "rails_helper"

RSpec.describe Api::V1::ChatbotsController, type: :controller do
  describe "routes" do
    it { should route(:post, "/api/v1/chatbots").to(action: :create, format: :json) }
    it { should route(:post, "/api/v1/chatbots/mark_as_completed").to(action: :mark_as_completed, format: :json) }
  end

  describe "actions" do
    describe "POST :create" do
      it "creates new record" do
        expect {
          post :create, params: { messenger_user_id: 123, name: "main_menu", value: "owso_info" }
        }.to change { Variable.count }.by(1)
        .and change { VariableValue.count }.by(1)
        .and change { Session.count }.by(1)
      end

      describe "bulk update" do
        let(:feedback_province) { create(:variable, name: 'feedback_province', mark_as: 'feedback_province') }
        let(:session) { create(:session, session_id: 123) }

        before do
          session.update(feedback_province_id: "01")
        end

        it "#feedback_province_id" do
          expect(session.reload.feedback_province_id).to eq "01"
        end

        100.times.each do
          it "creates many records" do
            post :create, params: { messenger_user_id: 123, name: feedback_province.name, value: "02" }

            expect(assigns(:session).feedback_province_id).to eq "02"
          end
        end
      end
    end

    describe "PUT :mark_as_completed" do
      let!(:session) { create(:session, platform_name: "Messenger") }

      before do
        session.incomplete!
      end

      specify { expect(session).to be_incomplete }

      it "completed" do
        post :mark_as_completed, params: { messenger_user_id: session.session_id, name: "main_menu", value: "owso_info" }

        expect(session.reload).to be_completed
      end
    end
  end
end
