module LiquidServices
  class BaseLiquid
    def initialize(site, start_date, end_date)
      @site = site
      @start_date = start_date
      @end_date = end_date
    end

    def to_h
      { 
        'site' => site_locals.to_h,
        'chart' => chart_locals.to_h,
        'date' => date_locals.to_h,
      }
    end

    private

    def site_locals
      @site_locals ||= SiteLiquid.new(site_name, province_name)
    end

    def date_locals
      @date_locals ||= DateLiquid.new(@start_date, @end_date)
    end

    def chart_locals
      @chart_locals ||= ChartLiquid.new(site_name)
    end

    def site_name
      district.send(name_18n)
    end

    def province_name
      district.province.send(name_18n)
    end

    def district
      @site.to_pumi
    end

    def name_18n
      "full_name_#{I18n.locale}".to_sym
    end
  end
end
