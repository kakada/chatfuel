class PrivateAccessController < ApplicationController
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :authenticate_user_with_guisso!

  private

  def user_not_authorized
    flash[:alert] = t("not_authorized")
    redirect_to(request.referrer || root_path)
  end
end
