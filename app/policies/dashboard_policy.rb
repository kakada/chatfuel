class DashboardPolicy < Struct.new(:user, :dashboard)
  def show?
    true
  end

  def setting?
    user.system_admin?
  end
end
