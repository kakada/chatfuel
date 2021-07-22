class DoReportSendPdfJob < ApplicationJob
  queue_as :default

  after_perform :remove_pdf

  def perform(site_code, pdf_path)
    site = Site.find_by(code: site_code)

    if site.present? && telegram_bot.present?
      site.telegram_chat_groups.find_each do |group|
        cmd = "curl -H \"Cache-Control: no-cache\" -F document=@\"#{pdf_path}\" https://api.telegram.org/bot#{telegram_bot.token}/sendDocument?chat_id=#{group.chat_id}"
        log { puts cmd }
        system(cmd, exception: true)
      rescue => e
        log { puts "it raises Class: #{e.class}, Message: #{e.message}, Inspect: #{e.inspect}" }
      end
    end  
  end

  private

  def remove_pdf
    `rm #{Rails.root.join('pdfs', '*.pdf').to_s}`
  end

  def log &block
    puts "*" * 100
    yield if block_given?
    puts "*" * 100
  end

  def telegram_bot
    TelegramBot.first
  end
end
