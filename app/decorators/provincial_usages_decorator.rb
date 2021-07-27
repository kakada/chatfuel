class ProvincialUsagesDecorator < Draper::CollectionDecorator
  def csv_headers
    table_headers.map { |h| h[:col] }
  end

  def table_headers
    plain_headers.each_with_object([]) do |(col, attr), header|
      header << { sortable_attr: attr, col: I18n.t("#{translation_key}.#{col}") }
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

  def translation_key
    "provincial_usages"
  end

  def plain_headers
    {
      'code': nil,
      'location': nil,
      'visit': 'visits_count',
      'unique': 'unique_users_count',
      'delivered': 'service_delivered_count',
      'most_request': nil
    }
  end
end
