class AddEngagedAtToSessions < ActiveRecord::Migration[6.0]
  def up
    add_column :sessions, :engaged_at, :datetime, default: -> { "CURRENT_TIMESTAMP" }
    Rake::Task["session:migrate_engaged_at"].invoke
  end

  def down
    remove_column :sessions, :engaged_at
  end
end
