class DashboardQuery
  def initialize(options = {}, relation = StepValue)
    @relation = relation
    @options = options
  end

  def user_count
    @options[:user_count].map { |key| send(key).count }.inject(:+)
  end

  def total_users_visit_each_functions
    result = StepValue\
      .joins(step: :message, variable_value: :variable)\
      .where(variables: { is_user_visit: true })\
      .where(messages: { platform_name: @options[:platform_name] })\
      .where("DATE(step_values.created_at) BETWEEN ? AND ?", @options[:start_date], @options[:end_date])\
      .order(:raw_value)\
      .group(:raw_value)\
      .count

    return {} if result.blank?

    default_chartjs_color_mapping.merge(result)
  end

  # prevent inconsistent chartjs color
  def default_chartjs_color_mapping
    return {} unless user_visit.present?

    default = {}
    user_visit.values.each { |val| default[val.raw_value] = 0 }
    default
  end

  def number_of_tracking_tickets
    statuses = Ticket.statuses

    StepValue.joins(step: :message, variable_value: :variable)\
      .joins("INNER JOIN tickets on tickets.code=variable_values.raw_value")
      .where(messages: { platform_name: @options[:platform_name] })\
      .where("DATE(step_values.created_at) BETWEEN ? AND ?", @options[:start_date], @options[:end_date])\
      .group("tickets.status")\
      .count
      .transform_keys { |k| statuses.key(k).capitalize }
  end

  def join_text_message
    TextMessage.joins(message: { steps: { value: :variable } })\
      .where(variables: { name: "location_code" })
      .where("variable_values.raw_value LIKE ?", "#{@options[:location][0...2]}%")
      .where(messages: { platform_name: @options[:platform_name] })
      .where("DATE(messages.created_at) BETWEEN ? AND ?", @options[:start_date], @options[:end_date])
  end

  def join_voice_message
    VoiceMessage.joins(message: { steps: { value: :variable } })\
      .where(variables: { name: "location_code" })
      .where("variable_values.raw_value LIKE ?", "#{@options[:location][0...2]}%")
      .where(messages: { platform_name: @options[:platform_name] })
      .where("DATE(messages.created_at) BETWEEN ? AND ?", @options[:start_date], @options[:end_date])
  end

  def total_users_feedback
    @relation\
      .joins(step: :message, variable_value: :variable)\
      .where(messages: { platform_name: @options[:platform_name] })\
      .where(variables: { report_enabled: true })\
      .where("DATE(step_values.created_at) BETWEEN ? AND ?", @options[:start_date], @options[:end_date])\
      .group(:raw_value)\
      .count
  end

  def most_request_service
    @relation\
      .joins(step: :message, variable_value: :variable)\
      .where(messages: { platform_name: @options[:platform_name] })\
      .where(variables: { is_most_request: true })\
      .where("DATE(step_values.created_at) BETWEEN ? AND ?", @options[:start_date], @options[:end_date])
      .order("count_all DESC")\
      .group("variable_values.raw_value")\
      .limit(1)\
      .count
  end

  def goals
    @goals ||= [accessed, submitted, completed].compact
  end

  def user_visit
    @user_visit ||= Variable.find_by(is_user_visit: true)
  end

  def most_request
    @most_request ||= Variable.find_by(is_most_request: true)
  end

  def report_enabled
    @report_enabled ||= Variable.find_by(report_enabled: true)
  end


  private
    # TODO: filter :platform, location, start date , end date
    def accessed
      data = StepValue.joins(step: :message, variable_value: :variable)\
                      .where(messages: { platform_name: @options[:platform_name] })\
                      .where("variable_values.raw_value=:access_key OR
                              ( variables.name='location_name' AND
                                variable_values.raw_value=:location_value )", access_key: "owso_info", location_value: @options[:location])\
                      .where("DATE(step_values.created_at) BETWEEN ? AND ?", @options[:start_date], @options[:end_date])
                      .group_by_day(:created_at)\
                      .count
      { name: I18n.t("dashboard.accessed"), data: data } if data.present?
    end

    # Ticket does not need to care about about platform(both, chatbot, ivr)
    # because it syncs from desktop app).
    # TODO: location#name=>province, Site#name=>district
    def submitted
      data = Ticket.incomplete
                .where("DATE(updated_at) BETWEEN ? AND ?", @options[:start_date], @options[:end_date])
                .group_by_day(:updated_at)
                .count
      { name: I18n.t("dashboard.submitted"), data: data } if data.present?
    end

    # TODO: location#name=>province, Site#name=>district
    def completed
      data = Ticket.completed
                .where("DATE(updated_at) BETWEEN ? AND ?", @options[:start_date], @options[:end_date])
                .group_by_day(:updated_at)
                .count
      { name: I18n.t("dashboard.completed"), data: data } if data.present?
    end

end
