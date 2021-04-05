class DashboardQuery
  include Chart::ProvincialUsage
  include Chart::ReportHelper
  attr_reader :options

  def initialize(options = {})
    @options = options
    platform = platform_param[@options[:platform].try(:to_sym)]
    @options[:platform_name] = ["Messenger", "Telegram", "Verboice"]
    @options.merge!(platform) if platform.present?
  end

  def user_count
    sessions.count
  end

  def user_unique_count
    user_unique.length
  end

  def user_unique
    return [] if user_count <= 0

    sessions.select("DISTINCT ON (session_id) *").reorder(:session_id, :gender)
  end

  # Summary > Total Service Delivered
  def user_accessed_count
    total_users_visit_each_functions.values.sum
  end

  def unique_by_genders
    return if user_unique_count <= 0

    raw_sql = <<~SQL
      SELECT gender, COUNT(gender) AS gender_count FROM (
        #{ user_unique.to_sql }
      ) AS inner_query
      WHERE gender <> ''
      GROUP BY gender
      ORDER BY gender
    SQL

    Session.find_by_sql(raw_sql)
  end

  def sessions
    Session.filter(@options)
  end

  # Summary > Total Visits By Type Of Service
  def total_users_visit_each_functions
    Session.filter(@options)\
            .joins(step_values: [:variable, :variable_value])\
            .where(step_values: { variable: Variable.user_visit })\
            .group("mapping_value_#{I18n.locale}")\
            .count
  end

  def users_visited_by_each_genders
    result = Session.filter(@options)\
              .joins(:step_values)\
              .where(step_values: { variable_value: VariableValue.kind_of_criteria })\
              .where.not(gender: '')\
              .group(:gender)\
              .count

    return {} if Variable.gender.nil?

    result.each_with_object({}).with_index do |((raw_gender, count), gender), index|
      mapping_gender = mapping_variable_value[raw_gender]&.mapping_value
      gender[mapping_gender] = count
    end
  end

  def mapping_variable_value
    Variable.gender.values.inject({}) do |hash, variable_value|
      hash[variable_value.raw_value] = variable_value
      hash[variable_value.mapping_value_en] = variable_value
      hash[variable_value.mapping_value_km] = variable_value
      hash
    end
  end

  # OWSO Information Accessed > Ticket Tracking(times)
  def number_of_tracking_tickets
    result = Tracking.filter(@options).group(:status).count

    result.transform_keys { |k| I18n.t(k.downcase.to_sym) }
  end

  def total_users_feedback
    variable = Variable.feedback

    return [] if variable.nil?

    StepValue.total_users_feedback(variable, @options)
  end

  def total_users_feedback_by_gender
    report = ::UserFeedbackGender.new(nil, self)
    report.chart_options
  end

  def most_requested_service
    most_request_variable = Variable.most_request
    return unless most_request_variable.present?

    top_hit = most_request_variable.agg_value_count(@options).first
    most_request_variable.transform_key_result(*top_hit) if top_hit.present?
  end

  def total_requested_service
    Variable.most_request.agg_value_count(@options).values.sum
  end

  # OWSO Information Accessed > User Access
  def goals
    user_access = ::UserAccess.new nil, self
    user_access.chart_options[:dataset]
  end

  def user_visit
    @user_visit ||= Variable.user_visit
  end

  def feedback
    @feedback ||= Variable.feedback
  end

  def province_codes
    options[:province_id].presence || all_province_codes
  end

  def province_codes_without_other
    Array.wrap(province_codes) - ["00"]
  end

  def district_codes
    options[:district_id].presence || all_district_codes
  end

  def district_codes_without_other
    district_codes - ["0000"]
  end

  def selected_district_codes
    district_codes_without_other.select do |code|
      code.starts_with?(*province_codes_without_other)
    end
  end

  private

    # All provinces include in piloting areas
    def all_province_codes
      Filters::PumiFilter.pilot_province_codes
    end

    def all_district_codes
      Filters::PumiFilter.pilot_district_codes
    end

    def platform_param
      {
        ivr: { platform_name: ["Verboice"], content_type: 'VoiceMessage' },
        chatbot: { platform_name: ["Messenger", "Telegram"], content_type: 'TextMessage' }
      }
    end
end
