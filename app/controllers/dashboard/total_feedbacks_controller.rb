class Dashboard::TotalFeedbacksController < DashboardController
  before_action :set_query

  def index
    render json: @query.users_feedback
  end

  private

  def set_query
    @query = DashboardQuery.new(filter_options)
  end
end
