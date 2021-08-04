class TicketTrackingByGenders < BasicReport
  def dataset
    result_set.transform_keys do |raw|
      gender = @query.mapping_variable_value[raw]
      gender.mapping_value if gender.present?
    end
  end

  def colors
    Gender::COLORS
  end
  
  private
    def result_set
      Session.filter(@query.options)\
            .with_genders\
            .joins(:trackings)\
            .group(:gender)\
            .count
    end
end