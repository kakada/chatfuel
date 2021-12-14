namespace :chatfuel do
  desc 'Copy missing session from chatfuel to step value'
  task :copy_session, [:from_date_str, :to_date_str] => :environment do |t, args|
    from_date = args[:from_date_str].to_date
    to_date = args[:to_date_str].to_date

    result = Session.joins(:step_values)\
      .joins('LEFT JOIN chatfuel_raw ON sessions.session_id = chatfuel_raw.chatfuel_user_id')\
      .where(step_values: { variable: Variable.feedback })\
      .where(feedback_province_id: nil)\
      .order(created_at: :desc)
      .where('DATE(engaged_at) BETWEEN ? AND ?', from_date, to_date)\

    unclone_sessions = []
    Session.record_timestamps = false

    result.each do |session|
      next if session.has_feedback_location_steps?

      unless session.clone_missing_feedback_location_from_chatfuel!
        unclone_sessions << session.id
      end
    end

    Session.record_timestamps = true

    puts "Unclone sessions: #{unclone_sessions.count} of #{result.count}"
    puts unclone_sessions
  end
end
