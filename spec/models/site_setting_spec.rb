require 'rails_helper'

RSpec.describe SiteSetting, type: :model do
  it { is_expected.to have_attribute(:type) }
  it { is_expected.to have_attribute(:digest_message_template) }
  it { is_expected.to have_attribute(:enable_notification) }
  it { is_expected.to have_attribute(:message_frequency) }
  it { is_expected.to have_attribute(:message_template) }

  it { is_expected.to belong_to(:site) }
  it { is_expected.to have_many(:site_settings_telegram_chat_groups) }
  it { is_expected.to have_many(:telegram_chat_groups).through(:site_settings_telegram_chat_groups) }
end
