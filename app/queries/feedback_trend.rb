class FeedbackTrend < Feedback
  def labels
    result_set_mapping.keys
  end
  
  def dataset
    satisfied.map do |status|
      {
        label: I18n.t(status),
        backgroundColor: colors_mapping[status],
        data: result_set_mapping.values.map { |result| result[status] || 0 }
      }
    end
  end
  
  private
    def colors_mapping
      satisfied.zip(COLORS).to_h
    end

    def satisfied
      VariableValue.value_statuses.keys.reverse
    end

    def result_set_mapping
      return {} unless result_set

      result_set.each_with_object({}).with_index do |((key, count), hash), index|
        date, value_id = key
        variable_value = VariableValue.find(value_id)
        month = format_label(date)

        hash[month] ||= {}
        prev_count = hash[month][variable_value.value_status].to_i
        hash[month][variable_value.value_status] = (prev_count + count)
      end
    end

    def result_set

      puts @query.options
      puts @query.province_codes
      puts @query.district_codes
      Session.feedback_filter(@query.options)\
              .joins(:step_values)\
              .where(step_values: { variable: @variable })\
              .where(feedback_province_id: @query.province_codes)\
              .where(feedback_district_id: @query.district_codes)\
              .group_by_period(period, :created_at, format: '%b/%y,%Y')\
              .group(:variable_value_id)\
              .count
    end
end
