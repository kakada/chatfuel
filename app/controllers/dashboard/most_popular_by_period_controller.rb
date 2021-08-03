class Dashboard::MostPopularByPeriodController < DashboardController
  def index
    render json: @query.most_tracked_periodic
  end
end