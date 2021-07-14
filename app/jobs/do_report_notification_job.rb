class DoReportNotificationJob < ApplicationJob
  queue_as :default

  def perform(*args)
    return if telegram_bot.blank?

    SiteDoReportSetting.enable_notification.includes(:site).find_each do |setting|
      setting.telegram_chat_groups.each do |group|
        client.send_message(chat_id: group.chat_id, text: "DO report for #{setting.site.code}")
      end
    end
  end

  private

  def client
    Telegram::Bot::Client.new(token: telegram_bot.token, username: telegram_bot.username)
  end

  def telegram_bot
    @telegram_bot ||= TelegramBot.first
  end
end
