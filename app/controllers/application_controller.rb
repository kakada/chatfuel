# frozen_string_literal: true

class ApplicationController < ActionController::Base
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  include Pagy::Backend
  include Localization
  include Pundit

  before_action :authenticate_user_with_guisso!
  before_action :set_raven_context

  private

    def redirect_to_guisso
      redirect_to user_instedd_omniauth_authorize_path(signup: true, origin: request.url), status: :found
    end

    def user_not_authorized
      flash[:alert] = t("not_authorized")
      redirect_to(request.referrer || dashboard_path)
    end

    def set_raven_context
      Raven.user_context(id: session[:current_user_id])
      Raven.extra_context(params: params.to_unsafe_h, url: request.url)
    end

    def set_daterange
      @start_date = params["start_date"] || default_start_date
      @end_date = params["end_date"] || default_end_date
    end

    def default_end_date
      Date.current.strftime(default_date_format)
    end

    def default_date_format
      Setting.default_date_format
    end

    def default_url_options
      { locale: I18n.locale }
    end
end
