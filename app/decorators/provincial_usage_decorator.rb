class ProvincialUsageDecorator < ApplicationDecorator
  delegate_all

  def data
    [
      province_name,
      h.number_with_delimiter(visits_count),
      h.number_with_delimiter(unique_users_count),
      h.number_with_delimiter(service_delivered_count),
      most_request
    ]
  end

  def most_request
    return "" unless most_request_service.present?

    name, count, total = most_request_service
    info = "(#{h.number_with_delimiter(count)}/#{h.number_with_delimiter(total)})" if count.to_i > 0
    [name, info].compact.join(' ')
  end
end
