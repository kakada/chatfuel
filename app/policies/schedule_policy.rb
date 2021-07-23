class SchedulePolicy < ApplicationPolicy
  def new?
    user.system_admin? and not scope.exists?
  end

  def create?
    new?
  end

  def edit?
    user.system_admin?
  end

  def update?
    edit?
  end

  def destroy?
    edit?
  end
end
