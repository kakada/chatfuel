class AddDisplayOrderToRoles < ActiveRecord::Migration[6.0]
  def change
    add_column :roles, :display_order, :integer, default: 1
    Rake::Task["role:order"].invoke
  end
end
