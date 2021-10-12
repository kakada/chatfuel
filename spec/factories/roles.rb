# == Schema Information
#
# Table name: roles
#
#  id         :bigint(8)        not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :role do

    trait :site_ombudsman do
      name { "site_ombudsman" }
    end

    trait :site_admin do
      name { "site_admin" }
    end

    trait :program_admin do
      name { "program_admin" }
    end

    trait :system_admin do
      name { "system_admin" }
    end
  end
end
