class Filters::LocationFilter
  attr_reader :province, :districts

  def initialize province, districts = []
    @province = province
    @districts = districts
  end

  def field_name
     "name_#{I18n.locale}".to_sym
  end

  def field_full_name
    "full_name_#{I18n.locale}".to_sym
  end

  def field_address
    "address_#{I18n.locale}".to_sym
  end

  def display_name
    return I18n.t("location_no_district", province: province_name) if !districts?
    return I18n.t("dashboard.all") if !province?
    return district_name if !multi_districts?

    I18n.t("location", province: province_name, district: district_name)
  end

  def province_name(type = :long)
    name_type = type == :short ? field_name : field_address
    province? ? province.send(name_type) : I18n.t("dashboard.all")
  end

  def district_name
    return I18n.t(:district_count, count: @districts.count) if multi_districts?

    return districts.first.send(field_address) if districts?

    return ""
  end

  def district_list_name
    return unless multi_districts?
    
    full_district_list_name
  end

  def full_district_list_name
    Array.wrap(districts).map { |district| district.send(field_name) }.to_sentence
  end

  # both chatbots and Ivr may capture `nil` or `null` value
  # `nu` happens when split first 2 characters that is assumed as province codes
  def self.dump_codes
    [nil, "nu", "null"]
  end

  private

  def province?
    province.present?
  end

  def multi_districts?
    districts? && districts.count > 1
  end

  def districts?
    districts.present?
  end
end
