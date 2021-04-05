class CreateSocialProviders < ActiveRecord::Migration[6.0]
  def change
    create_table :social_providers do |t|
      t.string :provider_name

      t.timestamps
    end
  end
end
