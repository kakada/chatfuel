namespace :step_value do
  desc "Migrate gender from step values to message"
  task migrate_gender: :environment do
    gender_variable = Variable.gender

    return if gender_variable.nil?

    ActiveRecord::Base.transaction do
      gender_variable.step_values.find_each do |step|
        gender = Gender.get(step.variable_value.raw_value)
        step.message.update!(gender: gender.name)
      end
    end
  end
end
