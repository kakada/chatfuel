class FeedbackSession
  class WrongDateFormatError < StandardError; end
  class InvalidDateError < StandardError; end

  def self.missing(from_str_date, to_str_date)
    raise "feedback variable must be present" unless Variable.feedback

    from_date = from_str_date.to_date rescue raise WrongDateFormatError
    to_date   = to_str_date.to_date   rescue raise WrongDateFormatError

    raise InvalidDateError if from_date >= to_date

    Session.joins(:step_values)\
          .where("DATE(sessions.engaged_at) >= :from AND 
                  DATE(sessions.engaged_at) <= :to", from: from_date, to: to_date)\
          .where("sessions.feedback_province_id IS NULL OR 
                  sessions.feedback_district_id IS NULL")\
          .where(step_values: { variable: Variable.feedback })
  end
end
