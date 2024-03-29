class FeedbackSubCategoryItem < FeedbackSubCategories
  def chart_options
    @query.district_codes_without_other.each_with_object({}) do |district_id, hash|
      hash[district_id] ||= {}
      hash[district_id][:labels] = result_set_mapping[district_id].keys rescue []
      hash[district_id][:dataset] = dataset(district_id)
    end
  end
  
  private

    def result_set
      scope = sql.where(feedback_district_id: @query.district_codes)
      scope = scope.group(:feedback_district_id)
      scope.count
    end
end