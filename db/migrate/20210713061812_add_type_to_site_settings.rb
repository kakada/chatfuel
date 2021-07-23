class AddTypeToSiteSettings < ActiveRecord::Migration[6.0]
  def change
    add_column :site_settings, :type, :string
  end
end
