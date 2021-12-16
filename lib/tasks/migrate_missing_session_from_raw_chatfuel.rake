require 'csv'

namespace :chatfuel do
  desc "Ensure feedback unit is exists"
  task ensure_feedback_unit: :environment do
    feedback_unit = Variable.feedback_unit
    if feedback_unit.nil?
      feedback_unit = Variable.find_by(name: "feedback_unit")
      feedback_unit&.mark_as_feedback_unit!
    end
  end

  desc "Migrate missing session from chatfuel raw data"
  task migrate_missing_from_raw_data: :ensure_feedback_unit do
    StepValue.transaction do
      ::CSV.foreach(Rails.root.join("corrected-data-in-november.csv")) do |row|
        id, session_id, feedback_unit, feedback_province, feedback_district = row
        
        session = Session.find_by(id: id)
        if session.present?
          session.step_values.clone_step :feedback_unit, feedback_unit
          session.step_values.clone_step :feedback_province, feedback_province
          session.step_values.clone_step :feedback_district, feedback_district
          puts "cloning #{session.id} is completed!"
        end
      end
    end
  end
end
