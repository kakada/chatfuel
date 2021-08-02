class Dashboard::TotalUsersController < DashboardController
  before_action :set_query

  def show
    render json: @query.user_count
  end

  private

  def set_query
    @query = DashboardQuery.new(filter_options)
  end
end
