class DoReportNotificationJob < ApplicationJob
  include Rails.application.routes.url_helpers
  queue_as :default

  def perform(*args)
    return unless pdf_template.present?

    settings.each do |setting|
      uri = URI.parse(document_url(setting.site.name_param))
      Net::HTTP.get_response(uri)
    end
  end

  private

  def settings
    SiteDoReportSetting.enable_notification.includes(:site)
  end

  def document_url(name_param)
    url = site_pdf_template_preview_url(site_code: name_param, id: pdf_template.name_param, format: :pdf, host: ENV["HOST_#{Rails.env}".upcase])
    "#{url}?v#{version}"
  end

  def pdf_template
    PdfTemplate.first
  end

  def version
    Time.current.to_i
  end
end
