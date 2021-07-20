class DoReportNotificationJob < ApplicationJob
  include Rails.application.routes.url_helpers
  queue_as :default

  def perform(*args)
    return if telegram_bot.nil? || pdf_template.nil?

    SiteDoReportSetting.enable_notification.includes(:site).find_each do |setting|
      setting.telegram_chat_groups.each do |group|
        # request to generate pdf
        uri = URI.parse(document_url(setting.site.name_param))
        response = Net::HTTP.get_response(uri)

        site = setting.site.reload
        # sending by file_id, only if it's exists on telegram server
        # sending by url of pdf is not guarantee(https://stackoverflow.com/questions/49645510/telegram-bot-send-photo-by-url-returns-bad-request-wrong-file-identifier-http)
        # send the generated pdf to telegram (multipart/form-data)
        `curl -v -F "chat_id=#{group.chat_id}" -F document=@/app/pdfs/#{site.latest_generated_pdf_name} https://api.telegram.org/bot#{telegram_bot.token}/sendDocument`
        sleep(delay_in_msec)
      end
    end
  end

  private

  def delay_in_msec
    (ENV['JS_DELAY_IN_MILLISECONDS'].to_i + wait_in_msec).in_milliseconds
  end

  def wait_in_msec
    2000
  end

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
