class Dashboard::TotalVisitsController < DashboardController
  before_action :set_query

  def index
    render json: @query.total_users_visit_by_category
  end

  private

  def set_query
    @query = DashboardQuery.new(filter_options)
  end
end
