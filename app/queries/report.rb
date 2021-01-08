class Report
  def initialize(variable)
    @variable = variable
  end

  def result
    @result = group_count
    self
  end

  def transform
    {
      peak: peak,
      data: tune_result
    }
  end

  private

  def peak
    @result.values.max
  end

  def tune_result
    @result.each_with_object({}) do |(key, count), hash|
      district, variable_value = find_objectes_by(key)
      hash_key = district.send("name_#{I18n.locale}".to_sym)

      hash[hash_key] = {
        value: replace_new_line(variable_value.mapping_value),
        count: count
      } if !hash[hash_key] || hash[hash_key][:count] < count
    end
  end

  def replace_new_line(str)
    str.sub(/\s/, "\n")
  end

  def find_objectes_by(key)
    district_id, variable_value_id = key

    district = Pumi::District.find_by_id(district_id)
    variable_value = VariableValue.find(variable_value_id)

    [district, variable_value]
  end

  def group_count
    @variable.step_values.joins(:message)\
      .where.not(messages: { district_id: ["", "null"] })\
      .group("messages.district_id")\
      .group(:variable_value_id)\
      .count
  end
end
