# frozen_string_literal: true

class ApplicationController < ActionController::Base
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  include Pagy::Backend
  include Pundit

  before_action :authenticate_user_with_guisso!
  before_action :set_raven_context
  before_action :switch_locale

  private
    def user_not_authorized
      flash[:alert] = t("not_authorized")
      redirect_to(request.referrer || root_path)
    end

    def switch_locale
      I18n.locale = params[:locale] || Setting.default_locale || I18n.default_locale
    end

    def set_raven_context
      Raven.user_context(id: session[:current_user_id])
      Raven.extra_context(params: params.to_unsafe_h, url: request.url)
    end

    def set_daterange
      @start_date = params["start_date"] || default_start_date
      @end_date = params["end_date"] || default_end_date
    end

    def default_start_date
      27.days.ago.strftime('%Y/%m/%d')
    end

    def default_end_date
      Date.current.strftime('%Y/%m/%d')
    end

    def filter_options
      {
        province_id: params['province_code'],
        district_id: params['district_code'],
        start_date: @start_date,
        end_date: @end_date,
        platform: params[:platform]
      }.with_indifferent_access
    end
end
