# == Schema Information
#
# Table name: schedules
#
#  id         :bigint(8)        not null, primary key
#  day        :string           not null
#  enabled    :boolean          default(FALSE)
#  name       :string           not null
#  time       :string           not null
#  worker     :string           default("")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Schedule < ApplicationRecord
  attr_reader :cron
  include Schedule::WorkerConcern

  validates :name, :worker, presence: true
  validate :ensure_worker_class_exists, if: -> { worker.present? }

  after_save :set_schedule, if: -> { ready? }
  after_save :remove_schedule, unless: -> { ready? }
  after_destroy :remove_schedule

  def ready?
    enabled? && worker.present?
  end

  def cron_description
    Cronex::ExpressionDescriptor.new(cron).description
  end

  private

  def cron
    hour, min = time.split(":")
    @cron = "#{min} #{hour} #{day} * *"
  end

  def ensure_worker_class_exists
    errors.add(:worker, I18n.t('schedules.empty_worker')) if worker.to_s.safe_constantize.nil?
  end
end
