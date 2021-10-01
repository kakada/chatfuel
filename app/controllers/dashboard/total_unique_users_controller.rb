class Dashboard::TotalUniqueUsersController < DashboardController
  def index
    render json: number_with_delimiter(@query.user_unique_count)
  end
end
