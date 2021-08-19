class AddFeedbackDistrictIdToSessions < ActiveRecord::Migration[6.0]
  def change
    add_column :sessions, :feedback_district_id, :string
    add_index :sessions, :feedback_district_id
  end
end
