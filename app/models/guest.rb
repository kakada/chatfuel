class Guest
  delegate :system_admin?, :site_admin?, :site_ombudsman?, to: :role, allow_nil: true

  def role
    Role.new(name: "guest")
  end

  def email
    "guest@example.com"
  end
end
