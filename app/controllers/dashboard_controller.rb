class DashboardController < PrivateAccessController
  include Filterable

  skip_before_action :authenticate_user_with_guisso!, :check_guisso_cookie, if: :public_dashboard?
  before_action :default_start_date
  before_action :set_daterange
  before_action :set_gon

  def show
    @criteria = VariableValue.criteria
    @variables ||= Variable.includes(:values).all
  end

  private

  def default_start_date
    Setting.dashboard_start_date.strftime(default_date_format)
  end

  def set_gon
    @query = DashboardQuery.new(filter_options)
    gon.push(static_gon)
  end

  def static_gon
    {
      locale: I18n.locale,
      no_data: I18n.t("no_data"),
      not_available: I18n.t(:not_available),
      start_date: @start_date,
      end_date: @end_date,
      params: params
    }
  end
end
