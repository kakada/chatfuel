module Filters
  class ManyProvinceZeroDistrict < ProvinceDistrict
    def display_name
      I18n.t(:selected_provinces, count: provinces.count)
    end
    
    def described_name
      provinces.map {|p| p.send(name_i18n)}.to_sentence
    end
  end
end

