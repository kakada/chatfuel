class ProvincialUsage
  attr_reader :result, :pro_code

  DEFAULT_SORT_ATTR = 'visits_count'
  DEFAULT_SORT_DIR = 'desc'

  def initialize(result, pro_code)
    @result = result
    @pro_code = pro_code
  end

  def province_name
    Pumi::Province.find_by_id(pro_code).send(address_i18n)
  end

  def visits_count
    result&.dig(pro_code, :visits).to_i
  end

  def unique_users_count
    result&.dig(pro_code, :uniques).to_i
  end

  def service_delivered_count
    result&.dig(pro_code, :service_delivered).to_i
  end

  def most_request_service
    result&.dig(pro_code, :most_request_services)
  end

  def self.fetch_and_transform(options)
    hash = fetch(options).to_h
    transform(hash)
  end

  private

  def address_i18n
    "address_#{I18n.locale}".to_sym
  end

  def self.transform(hash)
    hash.inject({}) do |memo, arr|
      service, result = arr
      result.each do |code, count|
        memo[code] ||= {}
        memo[code][service] = count
      end
      memo
    end
  end

  def self.fetch(options)
    {
      visits: TotalVisitUsage.fetch(options),
      uniques: TotalUniqueUserUsage.fetch(options),
      service_delivered: TotalServiceDeliveredUsage.fetch(options),
      most_request_services: TotalMostRequestServiceUsage.fetch(options)
    }
  end
end
