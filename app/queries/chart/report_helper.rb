module Chart::ReportHelper
  # OWSO Information Accessed > Most Requested Service By OWSO
  def most_requested_services
    ::MostRequest.new(Variable.most_request, self).chart_options
  end

  # Citizen feedback > Total Feedback By Gender
  def gender_info
    ::GenderInfo.new(nil, self).chart_options
  end

  # OWSO Information Accessed > Information Access By :period
  def access_info
    ::AccessInfo.new(nil, self).chart_options
  end

  # OWSO Information Accessed > Most Popular Service Information Requested By OWSO (scatter chart)
  def access_main_service
    ::AccessMainService.new(Variable.service_accessed, self).chart_options
  end

  # OWSO Information Accessed > Most Popular By :period (Not related to session)
  def most_tracked_periodic
    ::MostTrackedPeriodic.new(nil, self).chart_options
  end

  # OWSO Information Accessed > Ticket Tracking by Gender
  def ticket_tracking_by_genders
    ::TicketTrackingByGenders.new(nil, self).chart_options
  end

  # Citizen Feedback > :pro_code > Overall Rating by OWSO
  def overall_rating
    ::OverallRating.new(Variable.feedback, self).chart_options
  end

  def feedback_trend
    ::FeedbackTrend.new(Variable.feedback, self).chart_options
  end

  def total_users_visit_by_category
    ::UserVisitEachFunction.new(nil, self).chart_options
  end

  # OWSO Information Accessed > Information Access By Gender
  def users_by_genders
    ::UserByGender.new(nil, self).chart_options
  end

  # OWSO Information Accessed > Ticket Tracking(Times)
  def ticket_tracking
    ::TicketTracking.new(nil, self).chart_options
  end

  # Summary > Total User Feedback
  def users_feedback
    users_feedback_report = ::UserFeedback.new(nil, self)
    users_feedback_report.chart_options
  end

  # Citizen Feedback > Feedback By Sub Categories
  def feedback_sub_categories
    categories_all.merge(categories_separate)
  end

  private

  def categories_all
    ::FeedbackSubCategories.new(nil, self).chart_options
  end

  def categories_separate
    ::FeedbackSubCategoryItem.new(nil, self).chart_options
  end
end
