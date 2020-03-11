# frozen_string_literal: true

# == Schema Information
#
# Table name: settings
#
#  id               :bigint(8)        not null, primary key
#  completed_text   :text
#  uncompleted_text :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Setting < ApplicationRecord
  has_one_attached :uncompleted_audio
  has_one_attached :completed_audio

  validates :uncompleted_audio, content_type: [:mp3]
  validates :completed_audio, content_type: [:mp3]
end
