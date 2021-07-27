module Chart::ProvincialUsage
  def provincial_usages
    ProvincialUsages.new(usage_collection)
  end

  private

  def filtered_province_codes
    return ProvinceFilter.fetch(options[:province_id]) if options[:province_id].present?

    Session.province_ids
  end

  def result
    @result ||= ProvincialUsage.fetch_and_transform(options)
  end

  def usage_collection
    filtered_province_codes.map do |pro_code|
      ProvincialUsage.new(result, pro_code)
    end
  end
end
