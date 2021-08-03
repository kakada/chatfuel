class Dashboard::UserAccessController < DashboardController
  def index
    render json: @query.goals
  end
end