module Filters
  class ProvinceDistrict
    attr_reader :provinces, :districts

    def initialize(provinces, districts)
      @provinces = provinces
      @districts = districts
    end

    def display_name;end
    def described_name;end

    def name_i18n
      "full_name_#{I18n.locale}".to_sym
    end

    private

    def province
      provinces.first
    end

    def district
      districts.first
    end
  end
end
