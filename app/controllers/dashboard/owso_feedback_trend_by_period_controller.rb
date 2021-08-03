class Dashboard::OwsoFeedbackTrendByPeriodController < DashboardController
  def index
    render json: @query.feedback_trend
  end
end