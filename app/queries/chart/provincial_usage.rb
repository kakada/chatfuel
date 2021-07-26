module Chart::ProvincialUsage
  def provincial_usages
    provincial_usages = filtered_province_codes.map do |pro_code|
      ProvincialUsage.new(options, pro_code)
    end

    ProvincialUsages.new(provincial_usages)
  end

  def filtered_province_codes
    return ProvinceFilter.fetch(options[:province_id]) if options[:province_id].present?

    Session.province_ids
  end
end
