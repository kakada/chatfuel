FactoryBot.define do
  factory :visit, class: Ahoy::Visit do
    ip { FFaker::Internet.ip_v4_address }

    trait :random_grace_period do
      started_at { 1.minute.from_now }
    end
  end
end
