class FeedbackTrend < Feedback
  def chart_options
    province.merge(district)
  end
  
  private

    def province
      province_group = group_result(province_sql)
      shape_result(province_group)
    end

    def district
      district_group = group_result(district_sql)
      shape_result(district_group)
    end

    def shape_result(result)
      result.each_with_object({}) do |(pro_code, periods), hash|
        hash[pro_code] ||= {}
        hash[pro_code][:labels] = periods.keys
        hash[pro_code][:dataset] = dataset(periods)
      end
    end

    def dataset(periods)
      satisfied.map do |status|
        {
          label: I18n.t(status),
          backgroundColor: colors_mapping[status],
          data: periods.keys.map { |period| periods[period][status] }
        }
      end
    end

    def colors_mapping
      satisfied.zip(COLORS).to_h
    end

    def satisfied
      VariableValue.statuses.keys.reverse
    end

    def group_result(collection)
      collection.each_with_object({}) do |(key, count), hash|
        province_code, duration, value_id = key
        variable_value = VariableValue.find(value_id)

        format_duration = format_label(duration)
        hash[province_code] ||= {}
        hash[province_code][format_duration] ||= {}
        prev_count = hash[province_code][format_duration][variable_value.status].to_i
        hash[province_code][format_duration][variable_value.status] = (prev_count + count)
      end
    end

    def result_set
      Session.filter(@query.options)\
              .joins(:step_values)\
              .where(step_values: { variable: @variable })\
              .where(feedback_province_id: @query.province_codes)\
              .group_by_period(period, :created_at, format: '%b/%y,%Y')\
              .group(:variable_value_id)\
              .count
    end

    def province_sql
      sql(:province_id)
    end

    def district_sql
      sql(:district_id)
    end
end