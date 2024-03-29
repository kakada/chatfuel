class FeedbackReport < GenericReport
  def sql
    Session.feedback_filter(@query.options)\
            .joins(:step_values)\
            .where(step_values: { variable: [like, dislike] })\
            .where(feedback_province_id: @query.province_codes)\
            .group(:variable_id, :variable_value_id)
  end

  def colors
    Color.generate(values.count)
  end

  def values
    mapping_values(like) & mapping_values(dislike)
  end

  def mapping_values(obj)
    values = Array.wrap(obj&.values)
    values.map { |v| v.mapping_value }
  end

  def like
    Variable.find_by(name: 'feedback_like')
  end

  def dislike
    Variable.find_by(name: 'feedback_dislike')
  end

  def accumulate_rating_each_variable(rs)
    rs.each_with_object({}) do |(key, count), hash|
      variable_id, value_id, district_id = key
      variable_value = VariableValue.find(value_id)
      variable = variable_value.variable

      hash[hash_key(district_id)] ||= {}
      hash[hash_key(district_id)][I18n.t(variable.name)] ||= {}
      prev = hash[hash_key(district_id)][I18n.t(variable.name)][variable_value.mapping_value].to_i
      hash[hash_key(district_id)][I18n.t(variable.name)][variable_value.mapping_value] = prev + count
    end
  end

  def dataset_item(mapping_value, index, data_values)
    {
      label: mapping_value,
      backgroundColor: colors[index],
      data: data_values.map { |raw| raw[mapping_value] || 0 }
    }
  end

  def hash_key(k)
    k.nil? ? 'all' : k
  end
end