class BotsController < PrivateAccessController
  skip_before_action :authenticate_user_with_guisso!
  skip_before_action :verify_authenticity_token
end

