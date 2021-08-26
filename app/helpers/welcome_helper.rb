module WelcomeHelper
  def t_name(name = 'full_name')
    "#{name}_#{I18n.locale}".to_sym
  end

  def district(district_id)
    Pumi::District.find_by_id(district_id)
  end

  def province(province_id)
    Pumi::Province.find_by_id(province_id)
  end

  def show_location_detail
    @location_filter.provinces.one? && described_name ? @location_filter.display_name : I18n.t("dashboard.all_district")
  end

  def described_name
    @location_filter.described_name.presence
  end

  def human_size(num, units={ thousand: 'K', million: 'M' }, format: '%n%u')
    number_to_human num, units: units, format: format
  end

  def js_context
    [
      { dom: '#article',          template: 'welcomes/article' },
      { dom: '.switch-lang',      template: 'welcomes/switch_lang' },
      { dom: 'footer',            template: 'welcomes/footer' },
      { dom: '.sidebar-left',     template: 'welcomes/sidebar' },
      { dom: '#piloting-header',  template: 'welcomes/header' },
      { dom: '#form-query',       template: 'welcomes/form' },
      { dom: '.main-container',   template: 'welcomes/tabs/tabs' },
      { dom: '.visitor-counter',  template: 'shared/sidebar/visitor_count' },
    ]
  end
end
