class AddFeedbackProvinceIdToSessions < ActiveRecord::Migration[6.0]
  def change
    add_column :sessions, :feedback_province_id, :string
    add_index :sessions, :feedback_province_id
  end
end
