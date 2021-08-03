class Dashboard::TotalUsersAccessedController < DashboardController
  def index
    render json: @query.user_accessed_count
  end
end
