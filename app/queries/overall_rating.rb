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
          label: named_status(status),
          backgroundColor: colors_mapping[status],
          data: districts.keys.map { |district_name| districts[district_name][status].to_i }
        }
      end
    end

    def named_status(status)
      display_ratings.find_by(value_status: status)&.mapping_value || I18n.t(status)
    end

    def colors_mapping
      satisfied.zip(COLORS).to_h
    end

    def satisfied
      VariableValue.value_statuses.keys.reverse
    end
    
    def mapping
      result_set.each_with_object({}) do |(key, count), hash|
        pro_code, district, value = find_objects_by(key)
        district = district.send("name_#{I18n.locale}".to_sym)
      
        hash[pro_code] ||= {}
        hash[pro_code][district] ||= {}
        prev_count = hash[pro_code][district][value.value_status].to_i
        hash[pro_code][district][value.value_status] = (prev_count + count)
      end
    end

    def find_objects_by(key)
      pro_code = key.shift
      [pro_code] + super(key)
    end

    def result_set
      Session.filter(@query.options)
              .joins(:step_values)
              .where(step_values: { variable: @variable })
              .where(province_id: @query.province_codes)
              .where(district_id: @query.district_codes)
              .group(:province_id, :district_id, :variable_value_id)
              .count
    end
end