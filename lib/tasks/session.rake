require_relative "sessions/fake"

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
      sessions = Session.where.not( province_id: [nil, ""], 
        district_id:[nil, ""], 
        gender: nil).limit(100)

        sessions.find_each do |session|
          cloned_attrib = session.attributes.except("id")
          platform_name, session_id, source_id = random_channel
        
          cloned_attrib["session_id"] = session_id
          cloned_attrib["source_id"] = source_id
          cloned_attrib["platform_name"] = platform_name
          cloned_attrib["gender"] = random_gender
          cloned_attrib["repeated"] = random_repeated
          cloned_attrib["district_id"] = random_district_ids
          cloned_attrib["province_id"] = kompong_chhnang_id
          cloned_attrib["status"] = random_statuses
        
          cloned = Session.new(cloned_attrib)
        
          cloned.clone_relations if cloned.save

          # most requested service
          cloned.step_values.clone_step :most_request, most_request_values.sample

          # feedback sub categories  like, dislike
          if [true, false].sample
            cloned.step_values.clone_step :feedback_like, like_values.sample
          else
            cloned.step_values.clone_step :feedback_dislike, dislike_values.sample
          end

          # overall rating by OWSO
          cloned.step_values.clone_step :feedback_rating, rating_values.sample if [true, false].sample

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
end
