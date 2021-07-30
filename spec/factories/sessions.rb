# == Schema Information
#
# Table name: sessions
#
#  id                  :bigint(8)        not null, primary key
#  last_interaction_at :datetime
#  platform_name       :string           default("")
#  session_type        :string           default("")
#  status              :integer(4)       default("incomplete")
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  district_id         :string
#  province_id         :string
#  session_id          :string           not null
#
FactoryBot.define do
  factory :session do
    session_id { FFaker::SSNSE.ssn }
    source_id { "11112222" }
    platform_name { %w(Messenger Telegram Verboice).sample }
    district_id { "02122334" }
    province_id { district_id[0..1] }
    last_interaction_at { "2020-08-24 08:29:17" }
    gender { %w(male female).sample }

    before(:create) do |session, evaluator|
      session.source_id = session.session_id
    end

    trait :messenger do
      platform_name { "Messenger" }
    end

    trait :incomplete do
      status { 'incomplete' }
    end

    trait :completed do
      status { 'completed' }
    end

    trait :kamrieng do
      province_id { '02' }
      district_id { '0212' }
    end
  end
end
