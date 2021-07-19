class DoReportNotificationJob < ApplicationJob
  include Rails.application.routes.url_helpers
  queue_as :default

  def perform(*args)
    return if telegram_bot.nil? || pdf_template.nil?

    SiteDoReportSetting.enable_notification.includes(:site).find_each do |setting|
      setting.telegram_chat_groups.each do |group|
        #client.send_message(chat_id: group.chat_id, text: "DO report for #{setting.site.code}")
        puts "------------------"
        puts document_url(setting.site.name_param)
        client.send_document(chat_id: group.chat_id, document: document_url(setting.site.name_param), timeout: 10000)
        sleep(5.seconds)
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

  def document_url(name_param)
    url = site_pdf_template_preview_url(site_code: name_param, id: pdf_template.name_param, format: :pdf, host: ENV["HOST_#{Rails.env}".upcase])
    "#{url}?v#{version}"
  end

  def version
    Time.current.to_i
  end
end
