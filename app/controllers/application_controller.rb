# frozen_string_literal: true

class ApplicationController < ActionController::Base

  include Pagy::Backend
  include Localization
  include Pundit

  before_action :set_raven_context
  after_action :track_action
  
  private
    def track_action
      ahoy.track "track visitor", request.path_parameters
    end
  
    def user_not_authorized
      flash[:alert] = t("not_authorized")
      redirect_to(request.referrer || root_path)
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
      Date.current.strftime('%Y/%m/%d')
    end

    def default_url_options
      { locale: I18n.locale }
    end
end
