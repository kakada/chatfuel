module DictionariesHelper
  def total_users_visit_each_functions
    result = StepValue\
      .joins(step: :message, variable_value: :variable)\
      .where(variables: { name: "main_menu" })\
      .where(messages: { platform_name: @platform_name, location_name: @location })
      .where("DATE(step_values.created_at) BETWEEN ? AND ?", @start_date, @end_date)\
      .order(:raw_value)\
      .group(:raw_value)\
      .count

    return {} if result.blank?
    # prevent inconsistent chartjs color
    default = { "feedback" => 0, "owso_info" => 0, "tracking" => 0 }
    default.merge(result)
  end

  def total_users_feedback
    StepValue
      .joins(step: :message, variable_value: :variable)\
      .where(messages: { platform_name: @platform_name, location_name: @location })\
      .where(variables: { report_enabled: true })\
      .where("DATE(step_values.created_at) BETWEEN ? AND ?", @start_date, @end_date)\
      .group(:raw_value)\
      .count
  end

  def number_of_tracking_tickets
    statuses = Ticket.statuses
    status_values = statuses.fetch_values(:incomplete, :completed)

    Track
      .joins(:ticket, step: :message)\
      .where(messages: { platform_name: @platform_name, location_name: @location })\
      .where(tickets: { status: status_values })
      .where("DATE(tracks.created_at) BETWEEN ? AND ?", @start_date, @end_date)
      .group("tickets.status")
      .count
      .transform_keys { |k| statuses.key(k).capitalize }
  end

  def most_requested_service
    StepValue\
      .joins(step: :message, variable_value: :variable)\
      .where(messages: { platform_name: @platform_name, location_name: @location })\
      .where(variables: { is_most_request: true })\
      .where("DATE(step_values.created_at) BETWEEN ? AND ?", @start_date, @end_date)
      .order("count_all DESC")\
      .group("variable_values.raw_value")\
      .limit(1)\
      .count
  end

  def join_text_message
    Message\
      .joins("INNER JOIN text_messages ON text_messages.id=messages.content_id")\
      .where("messages.location_name=?", @location)
      .where("DATE(text_messages.created_at) BETWEEN ? and ?", @start_date, @end_date)
  end

  def join_voice_message
    Message\
      .joins("INNER JOIN voice_messages ON voice_messages.id=messages.content_id")
      .where("DATE(voice_messages.created_at) BETWEEN ? and ?", @start_date, @end_date)
  end
end
