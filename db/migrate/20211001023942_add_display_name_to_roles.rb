class AddDisplayNameToRoles < ActiveRecord::Migration[6.0]
  def change
    add_column :roles, :display_name, :string, default: ""
  end
end
