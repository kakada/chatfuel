class Dashboard::MostRequestedServiceByOwsoController < DashboardController
  def index
    render json: @query.most_requested_services
  end
end