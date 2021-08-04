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
  include StepValue::TrackableConcern
  include StepValue::FilterableConcern
  include StepValue::AggregatableConcern

  has_paper_trail

  belongs_to :variable_value, counter_cache: true
  belongs_to :site, optional: true
  belongs_to :message, optional: true
  belongs_to :variable
  belongs_to :session, optional: true

  validates :variable, uniqueness: { scope: :session }

  delegate :site_setting, to: :site, prefix: false, allow_nil: true

  after_create :push_notification, if: -> { variable_value.feedback? }
  after_commit :set_session_district_id,  on: [:create, :update],
                                          if: -> { variable_value.district? }
  after_commit :set_session_province_id,  on: [:create, :update],
                                          if: -> { variable_value.province? }
  after_commit :set_session_gender, on: [:create, :update], if: -> { variable.gender? }
  after_save :engage_session

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

  def self.clone_step(attr, value)
    variable = Variable.send(attr)
    variable_value = variable.values.find_or_create_by(raw_value: value)
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

    def set_session_district_id
      return if session.nil?

      session.update(district_id: variable_value.raw_value[0..3])
    end

    def set_session_province_id
      return if session.nil?

      session.update(province_id: variable_value.raw_value[0,2])
    end

    def set_session_gender
      return if session.nil?

      begin
        gender = Gender.get(variable_value.raw_value)
        session.update(gender: gender.name)
      rescue => e
        Rails.logger.info("#{e.message} for #{variable_value.raw_value}")
      end
    end

    def engage_session
      session.touch(:engaged_at) if session.present?
    end
end
