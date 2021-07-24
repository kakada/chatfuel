module LiquidServices
  class SiteLiquid
    def initialize(site_name, province_name)
      @site_name = site_name
      @province_name = province_name
    end

    def to_h
      { 
        'name' => @site_name,
        'province_name' => @province_name
      }
    end
  end
end
