class FeedbackSubCategories < FeedbackReport
  def chart_options
    @query.province_codes_without_other.each_with_object({}) do |province_id, hash|
      hash[province_id] ||= {}
      hash[province_id][:labels] = result_set_mapping[province_id].keys rescue []
      hash[province_id][:dataset] = dataset(province_id)
    end
  end

  def dataset(key)
    @values = result_set_mapping[key].values rescue []
    
    values.map.with_index do |mapping_value, index|
      dataset_item(mapping_value, index, @values)
    end
  end

  def colors
    Color.generate(values.count)
  end

  private
    def result_set_mapping
      @result_set_mapping ||= accumulate_rating_each_variable(result_set)
    end

    def result_set
      scope = sql.group(:feedback_province_id)
      scope.count
    end
end