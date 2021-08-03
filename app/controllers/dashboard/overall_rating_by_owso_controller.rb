class Dashboard::OverallRatingByOwsoController < DashboardController
  def index
    render json: @query.overall_rating
  end
end