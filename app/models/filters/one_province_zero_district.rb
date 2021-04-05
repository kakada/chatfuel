module Filters
  class OneProvinceZeroDistrict < ProvinceDistrict
    def display_name
      province.send(name_i18n)
    end
  end
end
