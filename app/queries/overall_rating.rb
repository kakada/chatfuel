class OverallRating < Feedback
  def chart_options
    mapping.each_with_object({}) do |(pro_code, districts), hash|
      hash[pro_code] ||= {}
      hash[pro_code][:labels] = districts.keys
      hash[pro_code][:dataset] = dataset(districts)
    end
  end

  private
    def dataset(districts)
      satisfied.map do |status|
        {
          label: I18n.t(status),
          backgroundColor: colors_mapping[status],
          data: districts.keys.map { |district_name| districts[district_name][status].to_i }
        }
      end
    end

    def colors_mapping
      satisfied.zip(COLORS).to_h
    end

    def satisfied
      VariableValue.statuses.keys.reverse
    end
    
    def mapping
      result_set.each_with_object({}) do |(key, count), hash|
        pro_code, district, value = find_objects_by(key)
        district = district.send("name_#{I18n.locale}".to_sym)
      
        hash[pro_code] ||= {}
        hash[pro_code][district] ||= {}
        prev_count = hash[pro_code][district][value.status].to_i
        hash[pro_code][district][value.status] = (prev_count + count)
      end
    end

    def find_objects_by(key)
      pro_code = key.shift
      [pro_code] + super(key)
    end

    def result_set
      scope = StepValue.filter(@query.options, @variable.step_values)
      scope = scope.joins(:session)
      scope = scope.where(sessions: { province_id: @query.province_codes })
      scope = scope.where(sessions: { district_id: @query.district_codes })
      scope = scope.group("sessions.province_id")
      scope = scope.group("sessions.district_id")
      scope = scope.group(:variable_value_id)
      scope.count
    end
end