# frozen_string_literal: true

# == Schema Information
#
# Table name: site_settings
#
#  id                      :bigint(8)        not null, primary key
#  digest_message_template :text
#  enable_notification     :boolean          default(FALSE)
#  message_frequency       :integer(4)
#  message_template        :text
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  site_id                 :bigint(8)        not null
#
# Indexes
#
#  index_site_settings_on_site_id  (site_id)
#
# Foreign Keys
#
#  fk_rails_...  (site_id => sites.id)
#
class SiteSetting < ApplicationRecord
  belongs_to :site
  belongs_to :site_settingable, polymorphic: true
  # site_feedback_settings
  #     has_one :site_setting, as: :site_settingable
  # site_report_settings
  #     has_one :site_setting, as: :site_settingable
  # site_id, site_settingable_id, site_settingable_type
  # 1      , 1                  , 

  has_many :site_settings_telegram_chat_groups
  has_many :telegram_chat_groups, through: :site_settings_telegram_chat_groups
  validates :message_template, presence: true, if: -> { immediately? }
  validates :digest_message_template, presence: true, unless: -> { immediately? }

  enum message_frequency: {
    immediately: 1,
    daily: 2,
    weekly: 3
  }

  FEEDBACK_MESSAGE = "{{feedback_message}}"
  FEEDBACK_COUNT = "{{feedback_count}}"

  scope :enable_notification, -> { where(enable_notification: true) }

  def message_variables
    [FEEDBACK_MESSAGE]
  end

  def digest_message_variables
    [FEEDBACK_COUNT]
  end

  def notification_message(value)
    message_template.gsub(/#{FEEDBACK_MESSAGE}/, "<b>#{value}</b>")
  end

  def notification_digest_message(value)
    digest_message_template.to_s.gsub(/#{FEEDBACK_COUNT}/, "<b>#{value}</b>")
  end

  def message_frequency=(value)
    value = value.to_i if value.is_a? String
    super(value)
  end
end
