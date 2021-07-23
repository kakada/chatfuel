class SiteSettingPolicy < ApplicationPolicy
  def create?
    user.system_admin?
  end

  def update?
    create?
  end
end
