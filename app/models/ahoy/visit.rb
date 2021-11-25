class Ahoy::Visit < ApplicationRecord
  self.table_name = "ahoy_visits"

  has_many :events, class_name: "Ahoy::Event"
  belongs_to :user, optional: true

  scope :duration, -> (start_date, end_date) { where("DATE(started_at) BETWEEN ? AND ?", start_date, end_date) }

  def self.count_with_fragment start_date, end_date
    [duration(start_date.to_date, end_date.to_date).count, all.count]
  end

  def self.clear(scope_ids)
    Ahoy::Visit.where(id: scope_ids).delete_all
    Ahoy::Event.where(visit_id: scope_ids).delete_all
  end

  def self.from(started_at, ips = [])
    scope = where("started_at > ?", started_at)
    scope = where("ip in (?)", ips) if ips.present?
    scope.order(:ip, :started_at)
  end

  def self.duplicate_ids_within_period(options = {})
    deleted_ids = []
    started_ip = started_at = nil
    find_each do |visit|
      if started_ip == visit.ip
        if visit.less_than? started_at + options[:duration].to_i.minutes
          deleted_ids << visit.id 
        else
          started_at = visit.started_at
        end
      else
        started_ip = visit.ip
        started_at = visit.started_at
      end
    end

    deleted_ids
  end

  def less_than? datetime
    started_at < datetime
  end

end
