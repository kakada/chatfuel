class Dashboard::MostPopularByOwsoController < DashboardController
  def index
    render json: @query.access_main_service
  end
end