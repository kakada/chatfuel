# frozen_string_literal: true

class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::MessageContext

  # call when create group with bot
  def start!
    group = TelegramChatGroup.find_or_initialize_by(chat_id: chat["id"])
    group.update(title: chat["title"], is_active: true)
  end

  def message(message)
    # {"id"=>952424355, "is_bot"=>true, "first_name"=>"ebs_bot", "username"=>"ebs_system_bot"}
    member = message["left_chat_member"] || message["new_chat_member"]
    return unless member.present? && member["is_bot"]

    # "chat"=>{"id"=>-369435878, "title"=>"ebs-group-chat", "type"=>"group", "all_members_are_administrators"=>true}
    chat = message["chat"]
    return unless chat["type"] == "group"

    group = TelegramChatGroup.find_or_initialize_by(chat_id: chat["id"])
    group.update(title: chat["title"], is_active: message["new_chat_member"].present?)
  end
end
