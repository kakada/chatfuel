# frozen_string_literal: true

class TelegramDoReportWebhooksController < Telegram::Bot::UpdatesController
  # include Telegram::Bot::UpdatesController::MessageContext

  # # call when create group with bot
  def start!
    puts "-----------------start!----------------------"
    puts chart.inspect
    puts from.inspect
    puts "---------------------------------------"

    return if chat["title"].nil?
    group = TelegramChatGroup.find_or_initialize_by(chat_id: chat["id"])
    group.update(title: chat["title"], is_active: true)
  end

  def message(message)
    puts "----------------message-----------------------"
    puts message.inspect
    puts "---------------------------------------"
    return unless bot_updated?(message)

    group = TelegramChatGroup.find_or_initialize_by(chat_id: chat["id"])
    group.update(title: chat["title"], is_active: true)
  end

  # message
  # edited_message
  # channel_post
  # edited_channel_post
  # inline_query
  # chosen_inline_result
  # callback_query
  # shipping_query
  # pre_checkout_query
  # poll
  # poll_answer
  # my_chat_member
  # chat_member

  private
    def bot_updated?(message)
      new_member = message["new_chat_member"]

      message["new_chat_title"] ||
      message["group_chat_created"] || 
      TelegramBot.exists?(username: new_member.try(:[], "username"))
    end
end
