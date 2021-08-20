class MigrateFeedbackLocationToSessions < ActiveRecord::Migration[6.0]
  def up
    Rake::Task['session:migrate_feedback_location:up'].invoke
  end

  def down
    Rake::Task['session:migrate_feedback_location:down'].invoke
  end
end
