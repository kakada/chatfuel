namespace :chatfuel do
  desc 'Copy missing session from chatfuel to step value'
  task copy_session: :environment do
    result = Session.joins(:step_values)\
      .joins("LEFT JOIN chatfuel_raw ON sessions.session_id = chatfuel_raw.chatfuel_user_id::VARCHAR")\
      .where(step_values: { variable: Variable.feedback })\
      .where(feedback_province_id: nil, feedback_district_id: nil)\
      .order(created_at: :desc)

    # does not working using #find_each
    result.each do |session|
      session.clone_missing_feedback_location_from_chatfuel!
    end
  end
end
