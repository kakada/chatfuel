# frozen_string_literal: true

module Sites
  class PdfTemplatesController < ApplicationController
    skip_before_action :authenticate_user_with_guisso!
    include Filterable

    before_action :default_start_date
    before_action :set_daterange
    before_action :set_site
    before_action :set_gon

    def show
      @pdf_template = PdfTemplate.find(params[:id]).decorate

      respond_to do |format|
        format.html { render template: template_path, layout: 'pdf' }
        format.pdf do
          unless params[:preview].present?
            create_and_send_pdf do |pdf|
              pdf_path = Rails.root.join('pdfs', "#{pdf_name}.pdf").to_path
              save_to_file(pdf, pdf_path)
              DoReportSendPdfJob.perform_later(filter_options[:district_id], pdf_path)
            end
          end

          send_data pdf, type: 'application/pdf', disposition: 'inline'
        end
      end
    end

    private

    def save_to_file(pdf, path)
      File.open(path, 'wb') { |f| f << pdf }
    end

    def create_and_send_pdf &block
      yield pdf
    end

    def pdf
      WickedPdf.new.pdf_from_string(
        render_to_string(template_path, layout: 'pdf'),
      )
    end

    def set_site
      @site = Site.find_by(code: filter_options[:district_id])
    end

    def template_path
      'sites/pdf_templates/show.html'
    end

    def pdf_name
      "DO-report-#{DateTime.current.strftime("%Y%m%d%H%M%S")}"
    end

    def default_start_date
      @start_date = schedule_date.strftime('%Y/%m/%d')
    end

    def schedule_date
      schedule = Schedule.first
      date_str = Date.current.strftime("%Y-%m-#{schedule.day}")
      Date.parse(date_str).last_month
    rescue
      Setting.dashboard_start_date
    end

    def set_gon
      I18n.with_locale(:km) do
        @query = DashboardQuery.new(filter_options)
        gon.push({
          totalUserVisitByCategory: @query.total_users_visit_by_category,
          totalUserFeedback: @query.users_feedback,
          feedbackSubCategories: @query.feedback_sub_categories[@site.code],
          accessMainService: @query.access_main_service,
          no_data: I18n.t("no_data"),
        })
      end
    end
  end
end
