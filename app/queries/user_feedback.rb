class UserFeedback < Report
  FEEDBACK_STATUS = {
    dislike: { color: '#f63e3e', icon: '😞' },
    acceptable: { color: '#ffbc00', icon: '😊' },
    like: { color: '#1cc88a', icon: '😍' }
  }

  def dataset
    sql.transform_keys do |k|
      k = VariableValue.value_statuses.key(k)
      i18n = I18n.t(k)
      "#{icon_map[i18n]} #{i18n}"
    end
  end

  def colors
    keys_based_colors(sql.keys)
  end

  private

    def sql
      @sql ||= Session.feedback_filter(@query.options)\
                  .joins(step_values: [:variable, :variable_value])\
                  .where(step_values: { variable: Variable.feedback })\
                  .group('variable_values.value_status')\
                  .count('sessions.id')
    end

    def keys_based_colors(keys)
      keys.map do |k| 
        FEEDBACK_STATUS[VariableValue.value_statuses.key(k).to_sym][:color]
      end
    end

    def icon_map
      FEEDBACK_STATUS.each_with_object({}) { |(k,v), h| h[I18n.t(k)] = v[:icon] }
    end
end
