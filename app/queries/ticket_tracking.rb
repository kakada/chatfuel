class TicketTracking < BasicReport
  def dataset
    @query.number_of_tracking_tickets
  end
end
