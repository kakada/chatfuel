class ProvincialUsagesDecorator < Draper::CollectionDecorator
  def t_headers
    plain_headers.map do |header|
      { sortable_attr: h.sortable_attributes[header], translate: h.t("provincial_usages.#{header}") }
    end
  end

  def sum_total_visit
    self.sum { |usage| usage.visits_count.to_i }
  end

  def sum_unique_users_count
    self.sum { |usage| usage.unique_users_count.to_i }
  end

  def sum_service_delivered_count
    self.sum { |usage| usage.service_delivered_count.to_i }
  end

  private

  def plain_headers
    %w(code location visit unique delivered most_request)
  end
end
