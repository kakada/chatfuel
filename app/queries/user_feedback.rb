class UserFeedback < BasicReport
  def dataset
    raw = Session.filter(@query.options)\
            .joins(step_values: [:variable, :variable_value])\
            .where(step_values: { variable: Variable.feedback })\
            .group('variable_values.value_status')\
            .count('sessions.id')

    raw.transform_keys do |k|
      k = VariableValue.value_statuses.key(k)
      i18n = I18n.t(k)
      "#{icon_map[i18n]} #{i18n}"
    end
  end

  def colors
    Feedback::COLORS.reverse
  end

  private

    def icon_map
      status_to_icon.each_with_object({}) { |(k,v), h| h[I18n.t(k)] = v }
    end

    def status_to_icon
      { like: "😍", acceptable: "😊", dislike: "😞" }
    end
end
