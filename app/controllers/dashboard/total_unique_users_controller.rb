class Dashboard::TotalUniqueUsersController < DashboardController
  before_action :set_query

  def index
    render json: @query.user_unique_count
  end

  private

  def set_query
    @query = DashboardQuery.new(filter_options)
  end
end
