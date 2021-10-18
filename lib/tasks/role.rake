namespace :role do
  desc "Assigns role's display order"
  task order: :environment do
    Role.reset_column_information
    display_ordered_roles.each do |display_ordered_role|
      display_order, role_name = display_ordered_role
      role = Role.find_by(name: role_name)
      role.update(display_order: display_order) if role.present?
    end
  end

  def display_ordered_roles
    [
      [1, 'system_admin'],
      [2, 'program_admin'],
      [3, 'site_admin'],
      [4, 'site_ombudsman'],
    ]
  end

end
