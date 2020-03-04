# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pagy::Backend
  include Pundit

  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!
end
