class UserFeedback < BasicReport
  def dataset
    hash = StepValue.total_users_feedback(Variable.feedback, @query.options)
    hash.transform_keys { |k| "#{icon_map[k]} #{k}" }
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
