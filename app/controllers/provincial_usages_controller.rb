class ProvincialUsagesController < ApplicationController
  include Filterable
  include Sortable

  before_action :default_start_date
  before_action :set_daterange
  before_action :set_query
  before_action :set_gon

  def index
    collection = @query.provincial_usages.sort(@sort_attr, @sort_dir)
    @provincial_usages = ProvincialUsageDecorator.decorate_collection(collection)

    respond_to do |format|
      format.html
      format.csv { render csv: @provincial_usages, **csv_options }
    end
  end

  private

  def set_sort
    @sort_attr = params[:sort_attr] || ProvincialUsage::DEFAULT_SORT_ATTR
    @sort_dir = params[:sort_dir] || ProvincialUsage::DEFAULT_SORT_DIR
  end

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
    Setting.dashboard_start_date.strftime(default_date_format)
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
