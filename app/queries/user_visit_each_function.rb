class UserVisitEachFunction < Report
  def dataset
    total_visits.each_with_object({}) do |(key, count), hash|
      service_name, variable_value_id = key
      hash[service_name] ||= 0
      hash[service_name] += count
    end
  end

  private

  def total_visits
    @total_visits ||= @query.total_users_visit_each_functions
  end
end
