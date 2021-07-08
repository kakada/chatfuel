# == Schema Information
#
# Table name: schedules
#
#  id         :bigint(8)        not null, primary key
#  cron       :string           not null
#  enabled    :boolean          default(FALSE)
#  name       :string           not null
#  worker     :string           default("")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Schedule < ApplicationRecord
  include Schedule::WorkerConcern

  validate :ensure_valid_cron

  after_save :run!
  after_destroy :remove_schedule

  def ready?
    enabled? && worker.present?
  end

  private

  def remove_schedule
    Sidekiq.remove_schedule worker
  end

  def ensure_valid_cron
    errors.add(:cron, I18n.t('schedules.invalid_cron_html')) if Fugit.parse(cron).nil?
  end
end
