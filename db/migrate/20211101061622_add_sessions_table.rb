class AddSessionsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :active_record_sessions do |t|
      t.string :session_id, :null => false
      t.text :data
      t.timestamps
    end

    add_index :active_record_sessions, :session_id, :unique => true
    add_index :active_record_sessions, :updated_at
  end
end
