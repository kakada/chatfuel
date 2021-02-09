module Filterable
  extend ActiveSupport::Concern

  included do
    before_action :set_location_filter
  end

  def filter_options
    platform = Session::PLATFORM_DICT[params[:platform].to_sym] if params[:platform].present?
    {
      province_id: params['province_code'],
      district_id: compact_district_codes,
      start_date: @start_date,
      end_date: @end_date,
      platform: platform,
      gender: params[:gender]
    }.with_indifferent_access
  end

  def compact_district_codes
    Array.wrap(params['district_code']).compact_blank
  end

  def set_location_filter
    province = Pumi::Province.find_by_id(params['province_code']) if params['province_code'].present?
    districts = compact_district_codes.map { |code| Pumi::District.find_by_id(code) } if params['district_code'].present?
    @location_filter = Filters::LocationFilter.new(province, districts)
  end
end
