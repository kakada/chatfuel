module Filters
  class OneProvinceManyDistrict < ProvinceDistrict
    def display_name
      I18n.t(:selected_districts, count: districts.count)
    end
    
    def described_name
      districts.map {|d| d.send(name_i18n)}.to_sentence
    end
  end
end
