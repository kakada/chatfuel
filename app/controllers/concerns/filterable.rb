module Filterable
  extend ActiveSupport::Concern

  included do
    before_action :set_location_filter
  end

  def filter_options
    platform = Session::PLATFORM_DICT[params[:platform].to_sym] if params[:platform].present?
    {
      province_id: province_codes_params,
      district_id: compact_district_codes,
      start_date: @start_date,
      end_date: @end_date,
      platform: platform,
      gender: params[:gender],
      period: params[:period]
    }.with_indifferent_access
  end

  # The reason to split: becuase store
  # in hidden input text values separated by comma
  # refactors : store in input that can store 
  # multiple values such as checkboxes.
  def province_codes_params
    province_codes = Array.wrap(params['province_code']).compact_blank
    province_codes.map { |code| code.split(",") }.flatten
  end

  def compact_district_codes
    params_district_code.compact_blank
  end

  def params_district_code
    district_codes = params['district_code'] || params['site_code']
    return [] unless district_codes.present?

    Array.wrap(district_codes).map { |code| code.split(",") }.flatten
  end

  def set_location_filter
    provinces = province_codes_params.map { |code| Pumi::Province.find_by_id(code) }
    districts = compact_district_codes.map { |code| Pumi::District.find_by_id(code) }
    @location_filter = Filters::LocationFilter.new(provinces, districts)
  end
end
