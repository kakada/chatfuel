class CreateSessions < ActiveRecord::Migration[6.0]
  def change
    create_table :sessions do |t|
      t.string :session_id, null: false
      t.string :session_type, default: ""
      t.string :platform_name, default: ""
      t.integer :status, default: 0
      t.string :district_id
      t.string :province_id
      t.datetime :last_interaction_at

      t.timestamps
    end

    return unless defined? Message

    ActiveRecord::Base.transaction do
      Message.find_each do |message|
        Session.create do |session|
          session.id = message.id
          session.session_id = message.session_id
          session.session_type = message.type
          session.platform_name = message.platform_name
          session.status = message.status
          session.district_id = message.district_id
          session.province_id = message.province_id
          session.last_interaction_at = message.last_interaction_at
        end
      end
    end
  end
end
