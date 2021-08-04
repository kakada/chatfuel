class UserAccess < BasicReport
  def dataset
    [
      accessed,
      *submitted_from_synced_locations
    ].compact
  end

  private

    # mark_as: service_accessed( variable = owso_info )
    def accessed
      data = Session.accessed(:day, "%b %e, %y", @query.options)
      format(name: I18n.t("dashboard.accessed"), data: data)
    end

    def submitted_from_synced_locations
      Ticket.submitted_from_synced_locations(@query.options).map do |result|
        format(result) if result.present?
      end
    end

    def format(result)
      {
        name: result[:name],
        data: result[:data],
        color: colors.next
      }
    end

    def colors
      @colors ||= Color.generate.cycle
    end
end