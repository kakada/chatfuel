class Dashboard::TotalFeedbackByGenderController < DashboardController
  def index
    render json: @query.gender_info
  end
end