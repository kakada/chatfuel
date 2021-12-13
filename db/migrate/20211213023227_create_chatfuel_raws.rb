class CreateChatfuelRaws < ActiveRecord::Migration[6.0]
  def change
    create_table :chatfuel_raws do |t|

      t.timestamps
    end
  end
end
