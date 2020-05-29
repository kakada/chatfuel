# == Schema Information
#
# Table name: templates
#
#  id            :bigint(8)        not null, primary key
#  content       :string           default("")
#  platform_name :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
FactoryBot.define do
  factory :template do
    content { "My template" }
  end
end
