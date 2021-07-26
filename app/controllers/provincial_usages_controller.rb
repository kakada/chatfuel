class ProvincialUsagesController < ApplicationController
  include Filterable

  before_action :default_start_date
  before_action :set_daterange
  before_action :set_query
  before_action :set_gon

  def index
    @provincial_usages = ProvincialUsageDecorator.decorate_collection(@query.provincial_usages.sort_by_code(:asc))
    respond_to do |format|
      format.html
      format.csv { render csv: @provincial_usages, **csv_options }
    end
  end

  private

  def csv_options
    { filename: "#{file_name}.csv", disposition: :attachment }
  end

  def file_name
    "provincial_usage_from_#{@start_date}_to_#{@end_date}"
  end

  def set_query
    @query ||= DashboardQuery.new(filter_options)
  end

  def default_start_date
    Setting.dashboard_start_date.strftime('%Y/%m/%d')
  end

  def set_gon
    gon.push({
      locale: I18n.locale,
      fileName: file_name,
      start_date: @start_date,
      end_date: @end_date
    })
  end
end
