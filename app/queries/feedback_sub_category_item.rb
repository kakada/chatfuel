class FeedbackSubCategoryItem < FeedbackSubCategories
  def chart_options
    @query.selected_district_codes.each_with_object({}) do |district_id, hash|
      hash[district_id] ||= {}
      hash[district_id][:labels] = result_set_mapping[district_id].keys rescue []
      hash[district_id][:dataset] = dataset(district_id)
    end
  end
  
  private

    def result_set
      scope = sql.where(district_id: @query.district_codes)
      scope = scope.group(:district_id)
      scope.count
    end
end