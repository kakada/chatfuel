module StepValue::LoggableConcern
  extend ActiveSupport::Concern
  
  def log
    { value: variable_value.raw_value, mapping: variable_value.mapping_value }
  end

  module ClassMethods
    def log
      scope = includes(:variable, :variable_value)
      scope.order(:created_at).each_with_object({}) do |step, hash|
        hash[step.variable.name] = step.log
      end
    end
  end
end
