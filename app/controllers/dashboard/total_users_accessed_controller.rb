class Dashboard::TotalUsersAccessedController < DashboardController
  def index
    render json: number_with_delimiter(@query.user_accessed_count)
  end
end
