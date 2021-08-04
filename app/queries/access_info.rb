class AccessInfo < BasicReport
  def dataset
    result_set.transform_keys { |k| format_label(k) }
  end

  private
    def result_set
      Session.accessed(period, '%b/%y,%Y', @query.options)
    end
end