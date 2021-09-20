class Ahoy::Visit < ApplicationRecord
  self.table_name = "ahoy_visits"

  has_many :events, class_name: "Ahoy::Event"
  belongs_to :user, optional: true

  scope :duration, -> (start_date, end_date) { where("DATE(started_at) BETWEEN ? AND ?", start_date, end_date) }

  def self.count_with_fragment start_date, end_date
    [duration(start_date.to_date, end_date.to_date).count, all.count]
  end
end
