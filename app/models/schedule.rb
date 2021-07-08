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

  validates :name, :cron, :worker, presence: true

  validate :ensure_valid_cron
  validate :ensure_worker_defined, if: -> { worker.present? }

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
    errors.add(:cron) if Fugit.parse(cron).nil?
  end

  def ensure_worker_defined
    errors.add(:worker, I18n.t('schedules.empty_worker')) if worker.to_s.safe_constantize.nil?
  end
end
