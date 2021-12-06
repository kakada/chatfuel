class FeedbackSession
  class FeedbackVariableRequiredError < StandardError; end
  class InvalidDateFormatError < StandardError; end
  class InvalidDateRangeError < StandardError; end

  def self.missing_location(from_str_date, to_str_date)
    raise FeedbackVariableRequiredError if Variable.feedback.nil?

    from_date = from_str_date.to_date rescue (raise InvalidDateFormatError)
    to_date   = to_str_date.to_date   rescue (raise InvalidDateFormatError)

    raise InvalidDateRangeError if from_date > to_date

    Session.joins(:step_values)\
          .where("DATE(sessions.engaged_at) >= :from AND 
                  DATE(sessions.engaged_at) <= :to", from: from_date, to: to_date)\
          .where("sessions.feedback_province_id IS NULL OR 
                  sessions.feedback_district_id IS NULL")\
          .where(step_values: { variable: Variable.feedback })
  end
end
