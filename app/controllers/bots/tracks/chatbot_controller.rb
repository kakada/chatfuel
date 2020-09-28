module Bots::Tracks
  class ChatbotController < ::Bots::TracksController
    def create
      render json: chatfuel_set_attributes.merge(json_response), status: :ok
    end

    private

    def chatfuel_set_attributes
      {
        set_attributes: { ticket_status: ticket_status }
      }
    end

    def json_response
      template = Template.for(ticket_status, params[:platform_name])

      return template.json_response if template

      Template.send_missing_response(ticket_status, params[:platform_name])
    end

    def ticket_status
      @ticket.nil? ? :incorrect : @ticket.progress_status
    end
  end
end
