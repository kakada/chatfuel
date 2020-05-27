# == Schema Information
#
# Table name: ratings
#
#  id                :bigint(8)        not null, primary key
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  feedback_id       :bigint(8)        not null
#  variable_value_id :bigint(8)        not null
#
# Indexes
#
#  index_ratings_on_feedback_id        (feedback_id)
#  index_ratings_on_variable_value_id  (variable_value_id)
#
FactoryBot.define do
  factory :rating do
    feedback { nil }
    answer_variable { nil }
  end
end
