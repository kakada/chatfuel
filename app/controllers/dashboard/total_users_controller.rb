class Dashboard::TotalUsersController < DashboardController
  def index
    render json: @query.user_count
  end
end
