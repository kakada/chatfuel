class Dashboard::TotalUniqueUsersController < DashboardController
  def index
    render json: @query.user_unique_count
  end
end
