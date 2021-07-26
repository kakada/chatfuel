module Chart::ProvincialUsage
  def provincial_usages
    provincial_usages = ProvinceFilter.fetch(province_codes).map do |pro_code|
      ProvincialUsage.new(options, pro_code)
    end

    ProvincialUsages.new(provincial_usages)
  end
end
