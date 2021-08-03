class Dashboard::TotalVisitsController < DashboardController
  def index
    render json: @query.total_users_visit_by_category
  end
end
