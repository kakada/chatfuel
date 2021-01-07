class FeedbackTrend < Feedback
  def result
    @result = group_count
    self
  end

  def transform
    {
      ratingLabels: raw_dataset.keys,
      dataset: tuned_dataset
    }
  end

  private

    def tuned_dataset
      @values = raw_dataset.values

      display_values.map.with_index do |values|
        raw_value, mapping_value = values
        {
          label: mapping_value,
          backgroundColor: colors_mapping[raw_value],
          data: @values.map { |raw| raw[mapping_value] || 0 }
        }
      end
    end

    def raw_dataset
      return {} unless @result

      @result.each_with_object({}).with_index do |((key, count), hash), index|
        month, value_id = key
        variable_value = VariableValue.find(value_id)

        hash[month] ||= {}
        hash[month][variable_value.mapping_value] = count
      end
    end

    def group_count
      scope = StepValue.filter(@variable.step_values, @query.options)
      scope = scope.joins(:message)
      scope = scope.where(messages: { district_id: @query.district_codes_without_other })
      scope = scope.group_by_period(period, "messages.created_at", format: "%b")
      scope = scope.group(:variable_value_id)
      scope.count
    end
end
