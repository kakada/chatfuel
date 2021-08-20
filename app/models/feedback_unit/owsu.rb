module FeedbackUnit
  class Owsu < Base
    alias_method :feedback_province_id, :province_id
    
    def feedback_district_id
      feedback_province_id + VariableValue::OWSU_CODE_SUFFIX
    end
  end
end
