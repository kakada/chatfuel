class DoReportNotificationJob < ApplicationJob
  include Rails.application.routes.url_helpers
  queue_as :default

  def perform(*args)
    return if telegram_bot.nil? || pdf_template.nil?

    SiteDoReportSetting.enable_notification.includes(:site).find_each do |setting|
      setting.telegram_chat_groups.each do |group|
        #client.send_message(chat_id: group.chat_id, text: "DO report for #{setting.site.code}")
        client.send_document(chat_id: group.chat_id, document: document_url(setting.site.code))
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

  def pdf_template
    @pdf_template ||= PdfTemplate.first
  end

  def document_url(site_code)
    site_pdf_template_preview_path(site_code: site_code, id: pdf_template.id, format: :pdf)
  end
end
