class Gonify
  def initialize(query)
    @query = query
  end

  def chart_data
    data = {}
    data.merge! summary
    data.merge! dashboard_data
    data.merge! access_info_chart
    data.merge! citizen_feedback_chart 
  end

  def summary
    {
      totalUserVisitByCategory: @query.total_users_visit_by_category,
      totalUserFeedback: @query.users_feedback
    }
  end

  def dashboard_data
    {
      totalUserByGender: @query.users_by_genders,
      totalUserFeedbackByGender: @query.total_users_feedback_by_gender,
      ticketTracking: @query.ticket_tracking,
      overview: @query.goals
    }
  end

  private

  def access_info_chart
    {
      mostRequest: @query.most_requested_services,
      genderInfo: @query.gender_info,
      accessInfo: @query.access_info,
      accessMainService: @query.access_main_service,
      mostTrackedPeriodic: @query.most_tracked_periodic,
      ticketTrackingByGenders: @query.ticket_tracking_by_genders,
    }
  end

  def citizen_feedback_chart
    {
      overallRating: @query.overall_rating,
      feedbackTrend: @query.feedback_trend,
      feedbackSubCategories: @query.feedback_sub_categories
    }
  end
end
