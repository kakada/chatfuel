class AdminPolicy < Struct.new(:user, :admin)
  def show?
    user.system_admin? || user.program_admin?
  end
end
