# == Schema Information
#
# Table name: schedules
#
#  id         :bigint(8)        not null, primary key
#  day        :string           not null
#  enabled    :boolean          default(FALSE)
#  name       :string           not null
#  time       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Schedule < ApplicationRecord
  attr_reader :cron
  include Schedule::WorkerConcern

  has_one :pdf_template, dependent: :destroy
  accepts_nested_attributes_for :pdf_template, allow_destroy: true

  validates :name, :day, :time, presence: true

  after_save :set_schedule, if: -> { enabled? }
  after_save :remove_schedule, if: -> { !enabled? }
  after_destroy :remove_schedule

  def cron_description
    Cronex::ExpressionDescriptor.new(cron).description
  end

  def cron
    hour, min = time.split(":")
    @cron = "#{min} #{hour} #{day} * *"
  end
end
