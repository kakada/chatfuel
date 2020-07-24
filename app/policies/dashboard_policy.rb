class DashboardPolicy < Struct.new(:user, :dashboard)
  def show?
    user.system_admin?
  end
end
