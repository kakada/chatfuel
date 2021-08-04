class RenameStatusToVariableValues < ActiveRecord::Migration[6.0]
  def change
    rename_column :variable_values, :status, :value_status
  end
end
