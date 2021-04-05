class AddTypeOfToVariableValue < ActiveRecord::Migration[6.0]
  def change
    add_column :variable_values, :type_of, :string, default: ''
  end
end
