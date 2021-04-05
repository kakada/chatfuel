class TicketsController < PrivateAccessController
  def index
    authorize Ticket
    @pagy, @tickets = pagy(Ticket.filter(params).order(requested_date: :desc))
  end
end
