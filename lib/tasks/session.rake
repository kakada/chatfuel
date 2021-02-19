require 'csv'

namespace :session do
  desc "Migrate gender from Message"
  task migrate_gender_from_message: :environment do
    unless defined? Message
      puts "Message model is undefined, Nothing to migrate!"
      exit
    end

    ActiveRecord::Base.record_timestamps = false

    ActiveRecord::Base.transaction do
      Message.find_each do |message|
        session = Session.find_by(session_id: message.session_id)
        session.gender = message.gender
        session.save
      end
    end

  ensure
    ActiveRecord::Base.record_timestamps = true
  end

  desc "Copy attribute session ID to source ID"
  task copy_session_id_to_source_id: :environment do
    unless Session.column_names.include? 'source_id'
      puts "source_id attribute is undefined or no longer exist, Nothing to migrate!"
      exit
    end

    ActiveRecord::Base.record_timestamps = false
    
    ActiveRecord::Base.transaction do
      Session.find_each do |session|
        session.source_id = session.session_id
        session.save
      end
    end
  ensure
    ActiveRecord::Base.record_timestamps = true
  end

  desc "Copy gender from message"
  task copy_gender_from_message: :environment do
    ActiveRecord::Base.record_timestamps = false
    Session.reset_column_information
    ActiveRecord::Base.transaction do
      Message.where.not(gender: ['', nil]).find_each do |message|
        session = Session.find(message.id)
        session.update!(gender: message.gender)
      end
    end
  ensure
    ActiveRecord::Base.record_timestamps = true
  end

  namespace :migrate_empty_gender_and_location_to_other do
    desc 'Migrate session\'s `""` or `nil` gender to `other`, `00` for province_id, `0000` for district_id'
    task up: :environment do
      ActiveRecord::Base.transaction do
        CSV.open(csv_file_path, "wb") do |csv|
          csv << header_csv

          Session.where(gender: nil).find_each do |session|
            session.set_other_gender
            session.set_00_province
            session.set_0000_district
            csv << session.row_csv
            raise session.err_msg unless session.save
          end
        end

      rescue => exception
        puts exception.message
      end
    end

    desc 'Rollback session empty gender, location to old state'
    task down: :environment do
      ActiveRecord::Base.transaction do
        CSV.foreach(csv_file_path, headers: true).each do |row|
          session = Session.find(row["session_id"])
          session.rollback_to_old_state(row)
        end
      rescue => e
        puts e.message
      end
    end
  end
  
  def header_csv
    %w(session_id migrated_at old_gender new_gender 
      old_province_id new_province_id old_district_id new_district_id)
  end

  def csv_file_path
    Rails.root.join('db', 'datasources', "empty_gender_location_#{current_date_as_num}.csv")
  end

  def current_date_as_num
    Date.current.to_formatted_s(:number)
  end
end
