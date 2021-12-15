require 'csv'

namespace :chatfuel do
  desc "Migrate missing session from chatfuel raw data"
  task migrate_missing_from_raw_data: :environment do
    ::CSV.foreach(Rails.root.join("corrected-data-in-november.csv")) do |row|
      id, session_id, feedback_unit, feedback_province, feedback_district = row

      StepValue.transaction do
        s = Session.find(id)
        s.step_values.clone_step :feedback_province, feedback_province
        s.step_values.clone_step :feedback_district, feedback_district
      end
    end
  end
end
