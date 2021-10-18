class SessionPolicy < ApplicationPolicy
  def index?
    user.system_admin? || user.program_admin?
  end
  
  class Scope < Scope
    def resolve
      scope
    end
  end
end
