class Dashboard::TicketTrackingController < DashboardController
  def index
    render json: @query.ticket_tracking
  end
end