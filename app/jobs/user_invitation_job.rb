class UserInvitationJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    invitee = User.find(user_id)
    invitee.invite!
  end
end
