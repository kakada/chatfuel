class Filters::LocationFilter
  attr_reader :provinces, :districts

  def initialize(provinces = [], districts = [])
    @provinces = provinces
    @districts = districts
  end

  delegate :display_name, :name_i18n, to: :klazz
  delegate :described_name, to: :klazz

  # def field_address
  #   "address_#{I18n.locale}".to_sym
  # end

  # both chatbots and Ivr may capture `nil` or `null` value
  # `nu` happens when split first 2 characters that is assumed as province codes
  def self.dump_codes
    [nil, "nu", "null"]
  end

  private

  def klazz
    combined = [classify_province, classify_district].join
    klass = "Filters::#{combined}"
    klass.constantize.new(provinces, districts)
  end

  def classify_province
    "#{ Filters::NamedNumber.call(provinces.count) }Province"
  end

  def classify_district
    "#{ Filters::NamedNumber.call(districts.count) }District"
  end
end