class ProvincialUsageDecorator < ApplicationDecorator
  delegate_all

  def data
    [
      code,
      province_name,
      visits_count,
      unique_users_count,
      service_delivered_count,
      most_request
    ]
  end

  def most_request
    return "" unless most_request_service.present?

    name, count, total = most_request_service
    "#{name} (#{count}/#{total})"
  end
end
