FactoryBot.define do
  factory :variable do
    name { FFaker::Name.unique.first_name }

    trait :feedback do
      name { "feedback" }
      mark_as { "feedback" }
    end

    trait :feedback_unit do
      name { "feedback_unit" }
      mark_as { "feedback_unit" }
    end

    trait :feedback_province do
      name { "feedback_province" }
      mark_as { "feedback_province" }
    end

    trait :feedback_district do
      name { "feedback_district" }
      mark_as { "feedback_district" }
    end
  end

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
