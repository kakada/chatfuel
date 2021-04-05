class Report
  def initialize(variable, query = nil)
    @variable = variable
    @query = query
  end

  def chart_options
    { colors: colors, dataset: dataset }
  end

  def dataset; raise 'must be implemented in subclass' end

  private

  def find_objects_by(key)
    district_id, variable_value_id = key

    district = Pumi::District.find_by_id(district_id)
    variable_value = VariableValue.find(variable_value_id)

    [district, variable_value]
  end

  def period
    (@query.options[:period].presence || 'month').to_sym
  end

  def format_label(k)
    label = ChartLabels::BaseLabel.new(period, k)
    label.instance.format
  end

  def location_filter
    @location_filter = Filters::LocationFilter.new(province, districts)
  end

  def colors
    Color.generate(dataset&.count.to_i)
  end

  def province
    Pumi::Province.find_by_id(@query.options['province_id']) 
  end

  def districts
    @query.options['district_id'].map { |code| Pumi::District.find_by_id(code) }
  end
end
