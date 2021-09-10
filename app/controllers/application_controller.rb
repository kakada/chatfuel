# frozen_string_literal: true

class ApplicationController < ActionController::Base

  include Pagy::Backend
  include Localization
  include Pundit

  before_action :set_raven_context
  after_action :track_action

  private

    def public_dashboard?
      ENV['DASHBOARD_VIEW'].to_s.downcase == 'public'
    end

    def track_action
      ahoy.track "track visitor", request.path_parameters
    end
    
    def set_raven_context
      Raven.user_context(id: session[:current_user_id])
      Raven.extra_context(params: params.to_unsafe_h, url: request.url)
    end

    def set_daterange
      @start_date = params["start_date"] || default_start_date
      @end_date = params["end_date"] || default_end_date
      @public_start_date = params["start_date"] || default_public_start_date
    end

    def default_end_date
      Date.current.strftime('%Y/%m/%d')
    end
end
