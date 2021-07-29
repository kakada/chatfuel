class FeedbackTrend < Feedback
  def labels
    result_set_mapping.keys
  end
  
  def dataset
    display_values.map.with_index do |values|
      id, raw_value, mapping_value = values
      {
        label: mapping_value,
        backgroundColor: colors_mapping[raw_value],
        data: result_set_mapping.values.map { |raw| raw[mapping_value] || 0 }
      }
    end
  end
  
  private
    def result_set_mapping
      return {} unless result_set

      result_set.each_with_object({}).with_index do |((key, count), hash), index|
        date, value_id = key
        variable_value = VariableValue.find(value_id)
        month = month = format_label(date)

        hash[month] ||= {}
        hash[month][variable_value.mapping_value] = count
      end
    end

    def result_set
      Session.filter(@query.options)\
              .joins(:step_values)\
              .where(step_values: { variable: @variable })\
              .where(province_id: @query.province_codes)\
              .group_by_period(period, :created_at, format: '%b/%y,%Y')\
              .group(:variable_value_id)\
              .count
    end
end
