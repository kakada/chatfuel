module StepValue::LocationCallbackConcern
  extend ActiveSupport::Concern

  included do
    with_options on: [:create, :update] do
      # owso's location
      after_commit :set_session_district_id, if: -> { variable_value.district? }
      after_commit :set_session_province_id, if: -> { variable_value.province? }
      
      # feedback's location
      after_commit :set_session_feedback_district_id, if: -> { variable_value.feedback_district? }
      after_commit :set_session_feedback_province_id, if: -> { variable_value.feedback_province? }
    end

    def self.destroy_district_id
      destroy_by( variable: Variable.district )
    end

    def self.destroy_feedback_district_id
      destroy_by( variable: Variable.feedback_district )
    end
  end

  private

  # owso location
  def set_session_district_id
    update_location do
      { province_id: province_id, district_id: district_id }
    end
  end

  def set_session_province_id
    update_location do
      { province_id: province_id, district_id: province_id == session.province_id ? session.district_id : nil }
    end
  end

  # feedback location
  def set_session_feedback_district_id
    update_location do
      { feedback_province_id: province_id, feedback_district_id: district_id }
    end
  end

  def set_session_feedback_province_id
    update_location do
      { feedback_province_id: province_id, feedback_district_id: feedback_province_id == session.feedback_province_id ? session.feedback_district_id : nil }
    end
  end

  def update_location
    return if session.nil?
    session.update yield
  end

  def province_id
    variable_value.raw_value[0, 2]
  end

  alias_method :feedback_province_id, :province_id

  def district_id
    variable_value.raw_value[0, 4]
  end
end
