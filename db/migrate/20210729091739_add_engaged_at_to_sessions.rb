class AddEngagedAtToSessions < ActiveRecord::Migration[6.0]
  def change
    add_column :sessions, :engaged_at, :datetime, default: -> { "CURRENT_TIMESTAMP" }
    Rake::Task["session:migrate_engaged_at"].invoke
  end
end
