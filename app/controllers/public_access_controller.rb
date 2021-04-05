class PublicAccessController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :check_guisso_cookie
  
  def current_user
    Guest.new
  end
end
