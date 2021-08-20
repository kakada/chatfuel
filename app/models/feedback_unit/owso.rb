module FeedbackUnit
  class Owso < Base
    alias_method :feedback_province_id, :province_id
    alias_method :feedback_district_id, :district_id
  end
end
