class Dashboard::InformationAccessByGendersController < DashboardController
  before_action :set_query

  def index
    render json: @query.users_by_genders
  end

  private

  def set_query
    @query = DashboardQuery.new(filter_options)
  end
end
