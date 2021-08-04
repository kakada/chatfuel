module StepValue::AggregatableConcern
  extend ActiveSupport::Concern

  included do
    def self.total_users_feedback(variable, params = {})
      scope = filter(params.merge(variable_id: variable))

      statuses = VariableValue.value_statuses
      default = statuses.transform_values { 0 }
      result = scope.joins(:variable_value).group(:value_status).count.map do |k, v|
        [statuses.key(k), v]
      end.to_h

      default.merge(result).transform_keys { |k| I18n.t(k.downcase.to_sym) }
    end

    def self.total_users_visit(variable, params = {})
      key = "mapping_value_#{ I18n.locale }".to_sym
      
      scope = joins(variable_value: :variable)
      scope = filter(params.merge(variable_id: variable), scope)
      scope = scope.order(key)
      scope = scope.group(key)

      scope.count
    end

    def self.agg_value_count(variable, params = {})
      scope = filter(params.merge(variable_id: variable))
      scope = scope.order("count_all DESC")
      scope = scope.group("variable_value_id")
      scope.count
    end
  end

  module ClassMethods
    def total_users_feedback_by_gender(variable_value, options)
      scope = StepValue.filter(options)
      scope = scope.where(variable_value: variable_value)
      scope = scope.joins(:session)
      scope = scope.group(:gender)
      scope.count
    end
  end
end
