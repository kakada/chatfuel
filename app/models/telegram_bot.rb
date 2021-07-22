# == Schema Information
#
# Table name: telegram_bots
#
#  id         :bigint(8)        not null, primary key
#  actived    :boolean          default(FALSE)
#  token      :string
#  username   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class TelegramBot < ApplicationRecord
  include TelegramBot::CoreApi
  validates :token, :username, presence: { message: I18n.t("presence") }

  before_save :post_webhook_to_telegram

  def post_webhook_to_telegram
    telegram_bot = Telegram::Bot::Client.new(token: token, username: username)

    begin
      request = telegram_bot.set_webhook(url: telegram_webhook_url)
      self.actived = request["ok"]
    rescue
      self.actived = false
    end
  end

  private

  def telegram_webhook_url
    host = ENV["HOST_#{Rails.env}".upcase]
    "#{host}/telegram"
  end
end
