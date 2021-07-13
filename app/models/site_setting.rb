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
#  type                    :string
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

  scope :feedbacks_setting, -> { where type: 'SiteFeedbackSetting' }
  scope :do_reports_setting, -> { where type: 'SiteDoReportSetting' }

  validates :type, uniqueness: { scope: :site }

  has_many :site_settings_telegram_chat_groups
  has_many :telegram_chat_groups, through: :site_settings_telegram_chat_groups
end
