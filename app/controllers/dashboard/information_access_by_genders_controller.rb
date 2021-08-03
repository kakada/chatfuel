class Dashboard::InformationAccessByGendersController < DashboardController
  def index
    render json: @query.users_by_genders
  end
end
