module Channels
  class MessengerChannel < BaseChannel
    def send_message(ticket)
      return if !ticket.message.reachable_period? || (ENV["ENABLE_FB_NOTIFY"] != "enable")

      RestClient.post(url, params(ticket), content_type: "application/json")
      Rails.logger.info "Sent: #{url} #{params}"
    end

    private
      def url
        @uri ||= "https://graph.facebook.com/v6.0/me/messages?access_token=#{ENV["FB_PAGE_TOKEN"]}"
      end

      def params(ticket)
        template = response_template ticket
        {
          messaging_type: "MESSAGE_TAG",
          tag: "CONFIRMED_EVENT_UPDATE",
          recipient: {
            id: ticket.message.try(:session_id)
          },
          message: {
            text: text_message(template)
          }
        }
      end
  end
end
