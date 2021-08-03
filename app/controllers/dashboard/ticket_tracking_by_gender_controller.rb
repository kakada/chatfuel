class Dashboard::TicketTrackingByGenderController < DashboardController
  def index
    render json: @query.ticket_tracking_by_genders
  end
end