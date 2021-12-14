namespace :chatfuel do
  desc 'Copy missing session from chatfuel to step value'
  task copy_session: :environment do
    result = Session.joins(:step_values)\
      .joins("LEFT JOIN chatfuel_raw ON sessions.session_id = chatfuel_raw.chatfuel_user_id::VARCHAR")\
      .where(step_values: { variable: Variable.feedback })\
      .where(feedback_province_id: nil, feedback_district_id: nil)\
      .order(created_at: :desc)\
      .limit(1)

    # does not working using #find_each
    affected_sessions = {}

    result.each do |session|
      feedback_unit = session.chatfuel_raw.feedback_unit
      feedback_province = session.chatfuel_raw.feedback_province
      feedback_district = session.chatfuel_raw.feedback_district

      affected_sessions[session.id] ||= []

      if feedback_unit.present?
        session.step_values.clone_step :feedback_unit, feedback_unit
        affected_sessions[session.id] << feedback_unit
      end

      if feedback_province.present?
        session.step_values.clone_step :feedback_province, feedback_province
        affected_sessions[session.id] << feedback_province
      end

      if feedback_district.present?
        session.step_values.clone_step :feedback_district, feedback_district
        affected_sessions[session.id] << feedback_district
      end
    end

    puts "Affected sessions report:"
    puts affected_sessions.inspect
  end
end
