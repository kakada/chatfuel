# == Schema Information
#
# Table name: settings
#
#  id               :bigint(8)        not null, primary key
#  completed_text   :text
#  incompleted_text :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
FactoryBot.define do
  factory :setting do
    incompleted_text { "MyText" }
    completed_text { "MyText" }

    trait :with_completed_audio do
      completed_audio { Rack::Test::UploadedFile.new(Rails.root.join("spec", "fixtures", "files", "completed_audio.mp3"), "audio/mpeg") }
    end

    trait :with_incompleted_audio do
      incompleted_audio { Rack::Test::UploadedFile.new(Rails.root.join("spec", "fixtures", "files", "incompleted_audio.mp3"), "audio/mpeg") }
    end
  end
end
