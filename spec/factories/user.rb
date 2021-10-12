FactoryBot.define do
  factory :user do
    email { FFaker::Internet.email }
    password { FFaker::Internet.password }

    trait :site_ombudsman do
      association :role, :site_ombudsman
    end

    trait :site_admin do
      association :role, :site_admin
    end

    trait :program_admin do
      association :role, :program_admin
    end

    trait :system_admin do
      association :role, :system_admin
    end
  end
end
