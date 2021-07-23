class DoReportNotificationJob < ApplicationJob
  include Rails.application.routes.url_helpers
  queue_as :default

  def perform
    return if pdf_template.nil?

    SiteDoReportSetting.enable_notification.includes(:site).each do |setting|
      uri = URI.parse(pdf_abs_url(setting.site.code))
      Net::HTTP.get_response(uri)
    end
  end

  private

  def pdf_abs_url(site_code)
    site_pdf_template_preview_url(site_code: site_code, id: pdf_template.id, format: :pdf, host: ENV['BASE_URL'])
  end

  def pdf_template
    PdfTemplate.first
  end
end
