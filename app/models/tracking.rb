# == Schema Information
#
# Table name: trackings
#
#  id                :bigint(8)        not null, primary key
#  site_code         :string
#  status            :integer(4)
#  ticket_code       :string
#  tracking_datetime :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  session_id        :bigint(8)
#
# Indexes
#
#  index_trackings_on_session_id  (session_id)
#
# Foreign Keys
#
#  fk_rails_...  (session_id => sessions.id)
#
class Tracking < ApplicationRecord
  enum status: %i[incorrect incomplete completed]

  belongs_to :session

  validates :status, uniqueness: { scope: :session }

  def self.filter(params = {})
    scope = all
    scope = scope.where(session_id: Session.where(gender: params[:gender])) if params[:gender].present?
    scope = scope.where(session_id: Session.where(content_type: params[:content_type])) if params[:content_type].present?
    scope = scope.where(session_id: Session.where(province_id: params[:province_id])) if params[:province_id].present?
    scope = scope.where(session_id: Session.where(district_id: params[:district_id])) if params[:district_id].present?
    scope = scope.where(session_id: Session.where(platform_name: params[:platform])) if params[:platform].present?
    scope = scope.where("DATE(tracking_datetime) BETWEEN ? AND ?", params[:start_date].to_date, params[:end_date].to_date) if params[:start_date].present? && params[:end_date].present?
    scope
  end
end
