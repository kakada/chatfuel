# == Schema Information
#
# Table name: tickets
#
#  id                  :bigint(8)        not null, primary key
#  actual_completed_at :date
#  approved_date       :datetime
#  code                :string           not null
#  completed_at        :date
#  delivery_date       :datetime
#  dist_gis            :string
#  incomplete_at       :date
#  incorrect_at        :date
#  requested_date      :datetime
#  sector              :string           default("")
#  service_description :string
#  status              :string
#  tel                 :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  site_id             :bigint(8)        not null
#
# Indexes
#
#  index_tickets_on_code     (code)
#  index_tickets_on_site_id  (site_id)
#
# Foreign Keys
#
#  fk_rails_...  (site_id => sites.id)
#
class Ticket < ApplicationRecord
  STATUSES = %w(accepted paid approved rejected delivered)
  INCOMPLETE_STATUSES = %w(accepted paid)

  belongs_to :site

  # validations
  validates :code, presence: true
  validates :status, inclusion: { in: STATUSES }
  before_validation :set_status
  after_update :notify_completed_to_bot_user, if: :just_completed?

  # scopes
  scope :accepted, -> { where(status: 'accepted') }
  scope :delivered, -> { where(status: 'delivered') }
  scope :completed, -> { where(status: ['approved', 'delivered']) }

  scope :for_location, -> (code) { joins(:site).where(sites: { code: code }) }

  delegate :platform_name, to: :message, allow_nil: true
  delegate :platform_name, to: :session, allow_nil: true

  
  def self.submitted_from_synced_locations(options = {}, group_by_format = "%b %e, %y")
    ENV['TICKET_SYNCED_DISTRICT_CODES'].to_s.split(",").map do |district_code|
      data = filter(options)
              .for_location(district_code)
              .group_by_day(:requested_date, format: group_by_format)
              .count
      { name: I18n.t("dashboard.submitted", site_name: I18n.t(district_code)), data: data }
    rescue
      nil
    end
  end

  # Instand methods
  def progress_status
    return 'incomplete' if INCOMPLETE_STATUSES.include?(status)

    'completed'
  end

  def completed?
    progress_status == "completed"
  end

  def message
    Message.joins(step_values: :variable_value).
          order("messages.last_interaction_at DESC").
          find_by("variable_values.raw_value=?", code)
  end

  def session
    Session.joins(step_values: :variable_value).
          order("sessions.last_interaction_at DESC").
          find_by("variable_values.raw_value=?", code)
  end

  # Class methods
  def self.filter(params = {})
    scope = all
    scope = scope.joins(:site) if params[:province_id].present? || params[:district_id].present?
    scope = scope.where("LEFT(sites.code, 2) IN (?)", params[:province_id]) if params[:province_id].present?
    scope = scope.where("sites.code IN (?)", params[:district_id]) if params[:district_id].present?
    scope = scope.where('code LIKE ?', "%#{params[:keyword].downcase}%") if params[:keyword].present?
    scope = scope.where("DATE(requested_date) BETWEEN ? AND ?", params[:start_date], params[:end_date]) if params[:start_date].present? && params[:end_date].present?
    scope
  end

  def approve!
    update_attribute(:status, 'approved')
  end

  private
    def set_status
      self.status = status.try(:downcase) || STATUSES[0]
    end

    def notify_completed_to_bot_user
      BroadcastJob.perform_later(self)
    end

    def just_completed?
      progress_status == 'completed' && INCOMPLETE_STATUSES.include?(status_previous)
    end

    def status_previous
      status_previous_change&.first
    end
end
