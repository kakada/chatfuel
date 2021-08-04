FactoryBot.define do
  factory :variable do
    name { FFaker::Name.unique.first_name }
  end

  trait :location

  trait :ticket_tracking do
    is_ticket_tracking { true }
  end

  trait :gender do
    name { 'gender' }
    mark_as { 'gender' }
    transient do
      genders { ['female', 'male'] }
    end

    after(:create) do |variable, evaluator|
      evaluator.genders.each do |gender|
        create :variable_value, raw_value: gender, variable: variable
      end
    end
  end

  trait :district do
    name { 'district' }
    mark_as { 'district' }

    transient do
      districts { ['0204', '0212'] }
    end

    after(:create) do |variable, evaluator|
      evaluator.districts.each do |district|
        create :variable_value, raw_value: district, variable: variable
      end
    end
  end
end
