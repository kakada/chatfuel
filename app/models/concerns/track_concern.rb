module TrackConcern
  extend ActiveSupport::Concern

  included do
    after_create :create_tracking, if: -> { variable.is_ticket_tracking? }
  end

  def create_tracking
    Tracking.create do |t|
      t.ticket_code = variable_value.raw_value
      t.site_code = variable_value.raw_value[0...4]
      t.status = variable_value.ticket_status
      t.tracking_datetime = created_at
      t.message = message
    end
  end
end
