class UserByGender < BasicReport
  def dataset
    @query.users_visited_by_each_genders
  end

  def colors
    Gender::COLORS
  end
end
