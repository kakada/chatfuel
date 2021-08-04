class TotalServiceDeliveredUsage
  def self.fetch(options)
    Session.filter(options)
            .joins(:step_values)
            .where(step_values: { variable: Variable.user_visit })
            .group(:province_id)
            .count
  end
end
