# == Schema Information
#
# Table name: step_values
#
#  id                :bigint(8)        not null, primary key
#  created_at        :datetime
#  updated_at        :datetime
#  message_id        :bigint(8)
#  session_id        :bigint(8)
#  site_id           :bigint(8)
#  variable_id       :bigint(8)        not null
#  variable_value_id :bigint(8)        not null
#
# Indexes
#
#  index_step_values_on_message_id         (message_id)
#  index_step_values_on_session_id         (session_id)
#  index_step_values_on_site_id            (site_id)
#  index_step_values_on_variable_id        (variable_id)
#  index_step_values_on_variable_value_id  (variable_value_id)
#
# Foreign Keys
#
#  fk_rails_...  (message_id => messages.id)
#  fk_rails_...  (session_id => sessions.id)
#  fk_rails_...  (site_id => sites.id)
#  fk_rails_...  (variable_id => variables.id)
#  fk_rails_...  (variable_value_id => variable_values.id)
#
FactoryBot.define do
  factory :step_value do
    variable_value
    site
    message
    session
    variable

    trait :district_variable do
      association :variable, name: 'district', mark_as: 'district'
    end

    trait :district_value do
      association :variable_value, raw_value: "0101"
    end

    trait :province_variable do
      association :variable, name: 'province', mark_as: 'province'
    end

    trait :province_value do
      association :variable_value, raw_value: "01"
    end

    factory :district_step, traits: [:district_variable, :district_value]
    factory :province_step, traits: [:province_variable, :province_value]
  end
end
