class MostTrackedPeriodic < BasicReport
  
  def dataset
    result_set.each_with_object({}) do |(key, count), hash|
      date, sector = key
      month = format_label(date)

      hash[month] = {
        value: sector,
        count: count
      } if !hash[month] || hash[month][:count] < count
    end
  end

  private
    def result_set
      scope = Tracking.filter(@query.options)
      scope = scope.joins(""" INNER JOIN tickets ON
                              trackings.ticket_code = tickets.code""")
      scope = scope.group_by_period(period, "trackings.tracking_datetime", format: "%b/%y,%Y")
      scope = scope.group(:sector)
      scope.count
    end
end