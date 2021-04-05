require_relative "sessions/fake"
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

  desc "Simulate sessions from kompong chhnang"
  task simulate_data: :environment do
    ActiveRecord::Base.transaction do
      sessions = Session.unscoped.where.not( province_id: [nil, ""],
        district_id:[nil, ""], 
        gender: nil).order("RANDOM()").limit(300)

        sessions.find_each do |session|
          cloned_attrib = session.attributes.except("id")
          faker = Sessions::Fake.new
        
          cloned_attrib["session_id"] = faker.session_id
          cloned_attrib["source_id"] = faker.source_id
          cloned_attrib["platform_name"] = faker.platform_name
          cloned_attrib["gender"] = faker.gender
          cloned_attrib["repeated"] = faker.repeated
          cloned_attrib["district_id"] = faker.province_id
          cloned_attrib["province_id"] = faker.district_id
          cloned_attrib["status"] = faker.status
        
          cloned = Session.new(cloned_attrib)
        
          cloned.clone_relations if cloned.save

          # most requested service
          cloned.step_values.clone_step :most_request, faker.most_request_raw_value

          # feedback sub categories  like, dislike
          if [true, false].sample
            cloned.step_values.clone_step :feedback_like, faker.like_raw_value
          else
            cloned.step_values.clone_step :feedback_dislike, faker.dislike_raw_value
          end

          # overall rating by OWSO
          cloned.step_values.clone_step :feedback, faker.feedback_raw_value if [true, false].sample

          print "."

        rescue => e
          puts e.message
        end
    end
  end

  desc "Copy created at to engaged at"
  task migrate_engaged_at: :environment do
    Session.reset_column_information
    Session.record_timestamps = false
    Session.update_all('engaged_at=created_at')
  ensure
    Session.record_timestamps = true
  end

  namespace :migrate_feedback_location do
    desc "Migrate feedback location"
    task up: :environment do
      Session.record_timestamps = false

      feedback_unit = Variable.find_by(name: 'feedback_unit')
      sessions = Session.joins(step_values: :variable)\
                        .includes(step_values: [:variable, :variable_value])\
                        .where(step_values: { variable: feedback_unit })

      sessions.each do |session|
        unit_value = province_id = district_id = ""
        feedback_province_id = feedback_district_id = ""

        session.step_values.includes(:variable, :variable_value).order(:created_at).each do |step|
          unit_value  = step.variable_value.mapping_value_en if step.variable == feedback_unit
          province_id = step.variable_value.raw_value if step.variable.feedback_province?
          district_id = step.variable_value.mapping_value_en if step.variable.feedback_district?

          if unit_value == 'owsu' && province_id.present?
            session.step_values.clone_step(:feedback_district, (province_id + VariableValue::OWSU_CODE_SUFFIX))
          end
        end

        unit = "feedback_unit/#{unit_value}".classify.constantize.new(province_id: province_id, district_id: district_id)

        session.update_columns(
          feedback_province_id: unit.feedback_province_id,
          feedback_district_id: unit.feedback_district_id
        )
      rescue
        next
      end
    ensure
      Session.record_timestamps = true
    end

    desc "Rollback feedback location"
    task down: :environment do
      Session.record_timestamps = false
      
      Session.transaction do
        Session.where.not(feedback_province_id: nil)\
          .or(Session.where.not(feedback_district_id: nil)).find_each do |session|
          session.update_columns feedback_province_id: nil, feedback_district_id: nil
          if session.step_values.owsu?
            session.step_values.delete_step(:feedback_district)
          end
        end
      end
    ensure
      Session.record_timestamps = true
    end
  end
  
  namespace :migrate_empty_gender_and_location_to_other do
    csv_file = Rails.root.join('db', 'datasources', "empty_gender_location_#{Time.current.to_formatted_s(:number)}.csv")

    desc 'Migrate session\'s `""` or `nil` gender to `other`, `00` for province_id, `0000` for district_id'
    task up: :environment do
      ActiveRecord::Base.record_timestamps = false
      ActiveRecord::Base.transaction do
        CSV.open(csv_file, "wb") do |csv|
          csv << header_csv

          Session.where(gender: nil, platform_name: "Messenger").find_each do |session|
            session.set_other_gender
            session.set_00_province
            session.set_0000_district
            csv << session.row_csv
            raise session.err_msg unless session.save
          end
        end

      rescue => exception
        puts exception.message
      ensure
        ActiveRecord::Base.record_timestamps = true
      end
    end

    desc 'Rollback session empty gender, location to old state'
    task down: :environment do
      ActiveRecord::Base.record_timestamps = false
      ActiveRecord::Base.transaction do
        CSV.foreach(csv_file, headers: true, encoding: "bom|utf-8").each do |row|
          session = Session.find(row["session_id"])

          if session.present?
            session.update_columns(
              gender: row["old_gender"],
              province_id: row["old_province_id"],
              district_id: row["old_district_id"] )
          end
        end
      rescue => e
        puts e.message
      ensure
        ActiveRecord::Base.record_timestamps = true
      end
    end
  end
  
  def header_csv
    %w(session_id migrated_at platform_name old_gender new_gender 
      old_province_id new_province_id old_district_id new_district_id)
  end

  def body_csv(session)
    row = [session.id, Date.current.strftime]
    [:gender, :province_id, :district_id].each do |attr|
      row << session.send("#{attr}_was".to_sym)
      row << session.send(attr)
    end
    row
  end
end
