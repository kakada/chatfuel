class ProvincialUsage
  def initialize(options, pro_code)
    @options = options
    @pro_code = pro_code
  end

  def code
    @pro_code
  end

  def province_name
    Pumi::Province.find_by_id(@pro_code).send("address_#{I18n.locale}".to_sym)
  end

  def visits_count
    visits[@pro_code]
  end

  def unique_users_count
    uniques[@pro_code]
  end

  def service_delivered_count
    service_delivered[@pro_code]
  end

  def most_request_service
    most_request_services[@pro_code]
  end
  
  private

  def visits
    @visits ||= TotalVisitUsage.fetch(@options)
  end

  def uniques
    @uniques ||= TotalUniqueUserUsage.fetch(@options)
  end

  def service_delivered
    @service_delivered ||= TotalServiceDeliveredUsage.fetch(@options) 
  end

  def most_request_services
    @most_request_services ||= TotalMostRequestServiceUsage.fetch(@options)
  end
end
