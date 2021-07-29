class MostRequest < BasicReport
  def chart_options
    result_set.each_with_object({}) do |(key, count), hash|
      pro_code, district, variable_value = find_objects_by(key)
      district_name = district.send("name_#{I18n.locale}".to_sym)
    
      hash[pro_code] ||= {}
      hash[pro_code][:colors] ||= Color.generate
      hash[pro_code][:dataset] ||= {}
      hash[pro_code][:dataset][district_name] = {
        value: variable_value.mapping_value,
        count: count
      } if hash[pro_code][:dataset][district_name].nil? || hash[pro_code][:dataset][district_name][:count] < count
    end
  end

  private

  def find_objects_by(k)
    pro_code = k.shift
    [pro_code] + super(k)
  end

  def result_set
    Session.filter(@query.options)\
            .joins(:step_values)\
            .where(province_id: @query.province_codes )\
            .where(step_values: @variable.step_values)\
            .group(:province_id, :district_id, :variable_value_id)\
            .count
  end
end