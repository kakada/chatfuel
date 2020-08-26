# == Schema Information
#
# Table name: step_values
#
#  id                :bigint(8)        not null, primary key
#  created_at        :datetime
#  updated_at        :datetime
#  message_id        :bigint(8)
#  session_id        :bigint(8)
#  site_id           :bigint(8)
#  variable_id       :bigint(8)        not null
#  variable_value_id :bigint(8)        not null
#
# Indexes
#
#  index_step_values_on_message_id         (message_id)
#  index_step_values_on_session_id         (session_id)
#  index_step_values_on_site_id            (site_id)
#  index_step_values_on_variable_id        (variable_id)
#  index_step_values_on_variable_value_id  (variable_value_id)
#
# Foreign Keys
#
#  fk_rails_...  (message_id => messages.id)
#  fk_rails_...  (session_id => sessions.id)
#  fk_rails_...  (site_id => sites.id)
#  fk_rails_...  (variable_id => variables.id)
#  fk_rails_...  (variable_value_id => variable_values.id)
#
class StepValue < ApplicationRecord
  include TrackConcern

  has_paper_trail

  belongs_to :variable_value, counter_cache: true
  belongs_to :site, optional: true
  belongs_to :message, optional: true
  belongs_to :variable
  belongs_to :session, optional: true

  validates :variable, uniqueness: { scope: :session }

  delegate :site_setting, to: :site, prefix: false, allow_nil: true

  after_create :push_notification, if: -> { variable_value.feedback? }
  after_commit :set_message_district_id,  on: [:create, :update],
                                          if: -> { variable_value.location? }
  after_commit :set_message_gender, on: [:create, :update], if: -> { variable.gender? }

  scope :most_recent, -> { select("DISTINCT ON (variable_id) variable_id, variable_value_id, id").order("variable_id, updated_at DESC") }

  def self.satisfied
    return [] unless feedback_column

    satisfied = feedback_column.values.satisfied
    joins(:variable_value).where("variable_values.id in (?)", satisfied.ids)
  end

  def self.disatisfied
    return [] unless feedback_column

    disatisfied = feedback_column.values.disatisfied
    joins(:variable_value).where("variable_values.id in (?)", disatisfied.ids)
  end

  def self.total_users_visit_each_functions(params = {})
    key = "mapping_value_#{ I18n.locale }".to_sym

    scope = all
    scope = scope.joins(variable_value: :variable)
    scope = filter(scope, params)
    scope = scope.where(variable_id: Variable.user_visit)
    scope = scope.order(key)
    scope = scope.group(key)
    scope.count
  end

  def self.total_users_feedback(params = {})
    scope = all
    statuses = VariableValue.statuses

    scope = filter(scope, params)
    feedback_variable = Variable.feedback
    scope = scope.where(variable_id: feedback_variable)

    default = statuses.transform_values { 0 }
    result = scope.joins(:variable_value).group(:status).count.map do |k, v|
      [statuses.key(k), v]
    end.to_h

    default.merge(result).transform_keys { |k| I18n.t(k.downcase.to_sym) }
  end

  def self.filter(scope, params={})
    scope = scope.where(session_id: Session.where(gender: params[:gender])) if params[:gender].present?
    scope = scope.where(session_id: Session.where(session_type: params[:content_type])) if params[:content_type].present?
    scope = scope.where(session_id: Session.where(province_id: params[:province_id])) if params[:province_id].present?
    scope = scope.where(session_id: Session.where(district_id: params[:district_id])) if params[:district_id].present?
    scope = scope.where(session_id: Session.where(platform_name: params[:platform_name])) if params[:platform_name].present?
    scope = scope.where("DATE(step_values.created_at) BETWEEN ? AND ?", params[:start_date], params[:end_date]) if params[:start_date].present? && params[:end_date].present?
    scope
  end

  def self.users_visited_by_each_genders(params = {})
    scope = joins(:message).where.not(messages: { gender: '' })
    scope = scope.where(variable_value: VariableValue.kind_of_criteria)
    scope = filter(scope, params)
  end

  def self.clone_step(attr, value)
    variable = Variable.send(attr)
    variable_value = variable.values.find_by(raw_value: value)
    create variable: variable, variable_value: variable_value
  rescue
    nil
  end

  private
    def self.feedback_column
      @feedback_column ||= Variable.feedback
    end

    def push_notification
      return unless (site_setting.present? && site_setting.message_frequency == 'immediately')

      AlertNotificationJob.perform_later(id)
    end

    def set_message_district_id
      return if session.nil?

      message.update(district_id: variable_value.raw_value[0..3])
    end

    def set_message_gender
      return if message.nil?

      begin
        gender = Gender.get(variable_value.raw_value)
        message.update(gender: gender.name)
      rescue => e
        Rails.logger.info("#{e.message} for #{variable_value.raw_value}")
      end
    end
end
