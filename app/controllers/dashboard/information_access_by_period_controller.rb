class Dashboard::InformationAccessByPeriodController < DashboardController
  def index
    render json: @query.access_info
  end
end