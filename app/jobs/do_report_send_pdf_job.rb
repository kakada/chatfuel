class DoReportSendPdfJob < ApplicationJob
  queue_as :default

  def perform(site_code, pdf_path)
    site = Site.find_by(code: site_code)

    return if site.nil? || telegram_bot.nil?

    site.telegram_chat_groups.find_each do |group|
      telegram_bot.send_document(pdf_path, group.chat_id, after_send: :remove_file)
    rescue => e
      log { puts e.message }
    end
  end

  private

  def telegram_bot
    TelegramBot.enabled.first
  end
end
