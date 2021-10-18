class WelcomesController < ActionController::Base
  include Filterable

  before_action :set_daterange
  before_action :set_query

  def access_info
    render json: @query.access_info, status: :ok
  end

  def service_tracked
    render json: @query.most_tracked_periodic, status: :ok
  end

  def feedback_trend
    render json: @query.feedback_trend, status: :ok
  end

  private
    def set_query
      @query = DashboardQuery.new(filter_options)
    end

    def set_daterange
      @start_date = params["start_date"] || default_start_date
      @end_date = params["end_date"] || default_end_date
    end

    def default_end_date
      Date.current.strftime(default_date_format)
    end

    def default_start_date
      Setting.dashboard_start_date.strftime(default_date_format)
    end
end
