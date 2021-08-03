class Dashboard::TotalFeedbacksController < DashboardController
  def index
    render json: @query.users_feedback
  end
end
