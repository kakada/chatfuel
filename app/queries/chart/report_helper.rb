module Chart::ReportHelper
  # OWSO Information Accessed > Most Requested Service By OWSO
  def most_requested_services
    ::MostRequest.new(Variable.most_request, self).chart_options
  end

  def gender_info
    ::GenderInfo.new(nil, self).chart_options
  end

  # OWSO Information Accessed > Information Access By :period
  def access_info
    ::AccessInfo.new(nil, self).chart_options
  end

  def access_main_service
    main_service = Variable.service_accessed
    ::AccessMainService.new(main_service, self).chart_options
  rescue
    {}
  end

  def most_tracked_periodic
    ::MostTrackedPeriodic.new(nil, self).chart_options
  end

  def ticket_tracking_by_genders
    ::TicketTrackingByGenders.new(nil, self).chart_options
  end

  def overall_rating
    feedback = Variable.feedback
    ::OverallRating.new(feedback, self).chart_options
  rescue
    {}
  end

  def feedback_trend
    feedback = Variable.feedback
    ::FeedbackTrend.new(feedback, self).chart_options
  rescue
    {}
  end

  def total_users_visit_by_category
    ::UserVisitEachFunction.new(nil, self).chart_options
  end

  # OWSO Information Accessed > Information Access By Gender
  def users_by_genders
    ::UserByGender.new(nil, self).chart_options
  end

  def ticket_tracking
    ticket_tracking_report = ::TicketTracking.new(nil, self)
    ticket_tracking_report.chart_options
  end

  # Summary > Total User Feedback
  def users_feedback
    users_feedback_report = ::UserFeedback.new(nil, self)
    users_feedback_report.chart_options
  end

  def feedback_sub_categories
    categories_all.merge(categories_separate)
  rescue
    {}
  end

  private

  def categories_all
    ::FeedbackSubCategories.new(nil, self).chart_options
  end

  def categories_separate
    ::FeedbackSubCategoryItem.new(nil, self).chart_options
  end
end
