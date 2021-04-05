module Filterable
  extend ActiveSupport::Concern

  included do
    before_action :set_location_filter
  end

  def filter_options
    platform = Session::PLATFORM_DICT[params[:platform].to_sym] if params[:platform].present?
    {
      province_id: compact_province_codes,
      district_id: compact_district_codes,
      start_date: @start_date,
      end_date: @end_date,
      platform: platform,
      gender: params[:gender],
      period: params[:period]
    }.with_indifferent_access
  end

  def compact_province_codes
    Array.wrap(params_province_code).compact_blank
  end

  def params_province_code
    return [] unless params['province_code'].present?

    Array.wrap(params['province_code']).map { |code| code.split(",") }.flatten
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
    provinces = compact_province_codes.map { |code| Pumi::Province.find_by_id(code) }
    districts = compact_district_codes.map { |code| Pumi::District.find_by_id(code) }
    @location_filter = Filters::LocationFilter.new(provinces, districts)
  end
end
