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
      @pdf_template = PdfTemplate.find(number_suffix(params[:id])).decorate

      respond_to do |format|
        format.html { render template: template_path, layout: 'pdf' }
        format.pdf do
          @site.update(latest_generated_pdf_name: "#{pdf_name}.pdf")
          render  pdf: pdf_name,
                  template: template_path,
                  layout: 'pdf',
                  orientation: 'Portrait',
                  lowquality: false,
                  page_offset: 0,
                  save_to_file: Rails.root.join('pdfs', "#{pdf_name}.pdf"),
                  disable_smart_shrinking: false,
                  zoom: 1,
                  book: false,
                  print_media_type: false,
                  dpi: 300,
                  encoding: 'utf8',
                  page_size: 'A4',
                  default_protocol: 'https',
                  header: { right: '[page] of [topage]' },
                  content_type: 'application/pdf',
                  # Delay for chartjs to execute before render pdf
                  javascript_delay: ENV['JS_DELAY_IN_MILLISECONDS']
        end
      end
    end

    def set_site
      @site = Site.find_by(code: filter_options[:district_id])
    end

    private

    def template_path
      'sites/pdf_templates/show.html'
    end

    def pdf_name
      "DO-report-#{DateTime.current.strftime("%Y%m%d%H%M%S")}".downcase
    end

    def default_start_date
      Setting.dashboard_start_date.strftime('%Y/%m/%d')
    end

    def set_gon
      @query = DashboardQuery.new(filter_options)
      gon.push({
        totalUserVisitByCategory: @query.total_users_visit_by_category,
        totalUserFeedback: @query.users_feedback,
        feedbackSubCategories: @query.feedback_sub_categories[@site.code],
        accessMainService: @query.access_main_service
      })
    end
  end
end
