module Bots
  class TracksController < BotsController
    before_action :set_dictionary
    before_action :message
    before_action :ticket
    after_action :assign_track_to_step

    def create
      @track = Track.new(track_params)

      if @track.save
        @site = Site.find_by(code: @track.site_code)
        @track.update(site: @site, ticket: @ticket)
        render json: json_response, status: :ok
      end
    end

    private
      def json_response
        {
          "messages": [
            { "text": decorator.status },
            { "text": decorator.description }
          ]
        }
      end

      def decorator
        @decorator ||= TicketDecorator.new(ticket || invalid_ticket)
      end

      def ticket
        @ticket ||= Ticket.find_by(code: params[:code])
      end

      def invalid_ticket
        @invalid_ticket ||= OpenStruct.new(status: "invalid")
      end

      def assign_track_to_step
        return unless @track.persisted?

        message = Message.find_by(content: @message)
        message.steps.create(act: "tracking_ticket", value: params[:code], track: @track)
      end

      def track_params
        params.permit(:code)
      end
  end
end
