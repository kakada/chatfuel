# == Schema Information
#
# Table name: variable_values
#
#  id                :bigint(8)        not null, primary key
#  hint              :string(255)      default("")
#  mapping_value_en  :string           default("")
#  mapping_value_km  :string           default("")
#  raw_value         :string           not null
#  status            :string           default("acceptable")
#  step_values_count :integer(4)       default(0)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  variable_id       :bigint(8)        not null
#
# Indexes
#
#  index_variable_values_on_variable_id  (variable_id)
#
# Foreign Keys
#
#  fk_rails_...  (variable_id => variables.id)
#
FactoryBot.define do
  factory :variable_value do
    raw_value { "certify_docs" }
    mapping_value_en { "Certify Documents" }
    mapping_value_km { "បញ្ជាក់ឯកសារ" }
    value_status { "1" }
    association :variable
  end
end
