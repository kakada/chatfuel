# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :mid
      t.string :first_name
      t.string :gender

      t.timestamps
    end
  end
end
