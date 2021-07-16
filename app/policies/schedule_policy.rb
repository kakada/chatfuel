class SchedulePolicy < ApplicationPolicy
  def new?
    not scope.exists?
  end

  def create?
    new?
  end
end
