class Users::InvitationsController < Devise::InvitationsController
  after_action :authenticate_user_with_guisso!, only: :accept_resource
end
