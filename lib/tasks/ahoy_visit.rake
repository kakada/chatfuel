namespace :ahoy_visit do
  desc "Clear ahoy visitor count"
  task clear: :environment do
    conn = ActiveRecord::Base.connection
    ActiveRecord::Base.transaction do
      raise "Must specify PUBLIC_START_DATE" unless ENV["PUBLIC_START_DATE"].present?
      raise "Prevent from accidentally run in the future" if Date.current > "2021-09-10".to_date

      conn.execute("DELETE FROM ahoy_visits WHERE DATE(started_at) < '#{ENV["PUBLIC_START_DATE"]}'")
      conn.execute("DELETE FROM social_providers;")
    end
  end
end
