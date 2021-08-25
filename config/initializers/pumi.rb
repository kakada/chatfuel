module Pumi
  class Province
    def address_en
      return super if id != "00"
      "Other Province"
    end

    def address_km
      return super if id != "00"
      "ខេត្តផ្សេងៗ"
    end

    def pilot_districts
      ENV["PILOT_DISTRICT_CODES_FOR_#{id}"].to_s.split(",").reverse.map do |code|
        District.find_by_id(code)
      end
    end

    def self.pilots
      ENV["PILOT_PROVINCE_CODES"].to_s.split(",").map do |code|
        find_by_id(code)
      end
    end
  end

  class District
    def address_en
      return super if id != "0000"
      "Other District, Other Province"
    end

    def address_km
      return super if id != "0000"
      "ស្រុកផ្សេងៗ, ខេត្តផ្សេងៗ"
    end
  end
end
