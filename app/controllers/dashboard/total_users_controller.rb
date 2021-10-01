class Dashboard::TotalUsersController < DashboardController
  def index
    render json: number_with_delimiter(@query.user_count)
  end
end
