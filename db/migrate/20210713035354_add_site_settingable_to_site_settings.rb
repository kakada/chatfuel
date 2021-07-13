class AddSiteSettingableToSiteSettings < ActiveRecord::Migration[6.0]
  def change
    add_reference :site_settings, :site_settingable, polymorpic: true, null: false
    # rename_column :site_settings, :site_id, :site_settingable_id
    # add_column :site_settings, :site_settingable_type, :string

    # add_index :site_settings, [:site_settingable_id, :site_settingable_type], name: "index_site_settingable_id_and_type"
  end
end
