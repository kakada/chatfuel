class AccessMainService < BasicReport
  def dataset
    result_set.each_with_object({}) do |(key, count), hash|
      value = VariableValue.find(key)
      prev_count = hash[value.mapping_value].to_i
      hash[value.mapping_value] ||= {}
      hash[value.mapping_value] = (prev_count + count)
    end
  end
  
  private
    def result_set
      Session.filter(@query.options)\
              .joins(:step_values)\
              .where(step_values: { variable: @variable })\
              .where(province_id: @query.province_codes)\
              .group(:variable_value_id)\
              .count
    end
end
