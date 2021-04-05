class ManifestsController < PrivateAccessController
  skip_before_action :authenticate_user_with_guisso!

  def show
    authorize :manifest
  end
end
