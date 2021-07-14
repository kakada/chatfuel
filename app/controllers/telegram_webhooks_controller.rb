# frozen_string_literal: true

class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::MessageContext

  # call when create group with bot
  def start!
    return if chat["title"].nil?
    group = TelegramChatGroup.find_or_initialize_by(chat_id: chat["id"])
    group.update(title: chat["title"], is_active: true)
  end

  def message(message)
    return unless bot_added?(message)

    group = TelegramChatGroup.find_or_initialize_by(chat_id: chat["id"])
    group.update(title: chat["title"], is_active: true)
  end

  private
    def bot_added?(message)
      message["new_chat_title"] || 
      message["group_chat_created"] || 
      telegram_bot_exists?(message["new_chat_member"])
    end

    def telegram_bot_exists?(new_member)
      TelegramBot.exists?(username: new_member.try(:[], "username"))
    end
end
